const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

// ⚠️ DO NOT call getMpesaToken() here – it would run during deployment and cause a timeout.
// The function will call it when invoked.

// ✅ UPDATED WITH YOUR ACTUAL CONSUMER KEY & SECRET
const CONSUMER_KEY = 'wA7AwOO9tpb5MmlqI4XuLTbJ3M5VUc4rckaJDzeSvNvzrGYR';
const CONSUMER_SECRET = 'SPkEFqQMMGgbyKwvBR9XGUIvndz1cjGIJUE6jhYXFYbp11bWEKyFjBNWiGX0ZdzV';
const PASSKEY = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
const SHORTCODE = '174379';
// For local testing, use ngrok to get a public URL. For production, use your deployed function URL.
const CALLBACK_URL = 'https://dose-broadly-rigor.ngrok-free.dev/mpesaCallbackV2';

// Helper: Get OAuth token from Safaricom (now defined but not executed at load time)
async function getMpesaToken() {
    const auth = Buffer.from(`${CONSUMER_KEY}:${CONSUMER_SECRET}`).toString('base64');
    const response = await axios.get(
        'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
        { headers: { Authorization: `Basic ${auth}` } }
    );
    return response.data.access_token;
}

// 1️⃣ Initiate Payment V2 (callable function from Flutter app)
exports.initiatePaymentV2 = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'You must be logged in.');
    }
    const userId = context.auth.uid;
    const { amount, phoneNumber } = data;

    if (!amount || !phoneNumber) {
        throw new functions.https.HttpsError('invalid-argument', 'Amount and phone number are required.');
    }

    try {
        // ✅ Token is fetched when the function is called, not during deployment
        const token = await getMpesaToken();
        const timestamp = new Date().toISOString().replace(/[^0-9]/g, '').slice(0, 14);
        const password = Buffer.from(`${SHORTCODE}${PASSKEY}${timestamp}`).toString('base64');

        const response = await axios.post(
            'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',
            {
                BusinessShortCode: SHORTCODE,
                Password: password,
                Timestamp: timestamp,
                TransactionType: 'CustomerPayBillOnline',
                Amount: amount,
                PartyA: phoneNumber,
                PartyB: SHORTCODE,
                PhoneNumber: phoneNumber,
                CallBackURL: CALLBACK_URL,
                AccountReference: 'CHAINET_PREMIUM',
                TransactionDesc: 'Payment for Premium Access',
            },
            { headers: { Authorization: `Bearer ${token}` } }
        );

        // Save transaction as 'pending' in Firestore
        await admin.firestore().collection('transactions').doc(response.data.CheckoutRequestID).set({
            userId: userId,
            amount: amount,
            status: 'pending',
            checkoutRequestID: response.data.CheckoutRequestID,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        return { message: 'STK Push sent successfully.', checkoutRequestID: response.data.CheckoutRequestID };
    } catch (error) {
        console.error("Payment initiation failed:", error);
        throw new functions.https.HttpsError('internal', 'Payment initiation failed. Check function logs.');
    }
});

// 2️⃣ M-Pesa Callback V2 (receives payment confirmation from Safaricom)
exports.mpesaCallbackV2 = functions.https.onRequest(async (req, res) => {
    const callbackData = req.body;
    const { Body: { stkCallback: { ResultCode, ResultDesc, CheckoutRequestID, CallbackMetadata } } } = callbackData;

    const transactionRef = await admin.firestore().collection('transactions').doc(CheckoutRequestID).get();
    if (!transactionRef.exists) {
        console.error(`Transaction ${CheckoutRequestID} not found.`);
        res.status(200).send('Transaction not found');
        return;
    }
    const { userId } = transactionRef.data();

    if (ResultCode === 0) {
        let mpesaReceiptNumber = '';
        let amount = 0;
        let transactionDate = '';

        if (CallbackMetadata && CallbackMetadata.Item) {
            CallbackMetadata.Item.forEach(item => {
                if (item.Name === 'MpesaReceiptNumber') mpesaReceiptNumber = item.Value;
                if (item.Name === 'Amount') amount = item.Value;
                if (item.Name === 'TransactionDate') transactionDate = item.Value;
            });
        }

        await admin.firestore().collection('users').doc(userId).update({
            isPremium: true,
            premiumUnlockedAt: admin.firestore.FieldValue.serverTimestamp(),
            mpesaReceiptNumber: mpesaReceiptNumber,
        });
        await admin.firestore().collection('transactions').doc(CheckoutRequestID).update({
            status: 'completed',
            resultDesc: ResultDesc,
            mpesaReceiptNumber: mpesaReceiptNumber,
            amount: amount,
            transactionDate: transactionDate,
        });
        console.log(`✅ Premium unlocked for user ${userId}. Receipt: ${mpesaReceiptNumber}`);
    } else {
        await admin.firestore().collection('transactions').doc(CheckoutRequestID).update({
            status: 'failed',
            resultDesc: ResultDesc,
        });
        console.log(`❌ Transaction failed for user ${userId}: ${ResultDesc}`);
    }
    res.status(200).send('OK');
});