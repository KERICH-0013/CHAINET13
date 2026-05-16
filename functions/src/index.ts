import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import axios from 'axios';

admin.initializeApp();
const db = admin.firestore();

// 🔁 Sandbox credentials (replace with your full Consumer Key/Secret if needed)
const CONSUMER_KEY = 'wA7AwOO9tpb5MmlqI4XuLTbJ3M5VUc4rckaJDzeSvNvzrGYR';      // Replace with your full Consumer Key
const CONSUMER_SECRET = 'SPkEFqQMMGgbyKwvBR9XGUIvndz1cjGIJUE6jhYXFYbp11bWEKyFjBNWiGX0ZdzV';   // Replace with your full Consumer Secret
const PASSKEY = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
const SHORTCODE = '174379';
const CALLBACK_URL = 'YOUR_CLOUD_FUNCTION_URL/mpesa-callback'; // Update after deploy

async function getMpesaToken(): Promise<string> {
    const auth = Buffer.from(`${CONSUMER_KEY}:${CONSUMER_SECRET}`).toString('base64');
    const response = await axios.get(
        'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
        { headers: { Authorization: `Basic ${auth}` } }
    );
    return response.data.access_token;
}

export const initiatePayment = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'You must be logged in.');
    }
    const userId = context.auth.uid;
    const { amount, phoneNumber } = data;

    if (!amount || !phoneNumber) {
        throw new functions.https.HttpsError('invalid-argument', 'Amount and phone number are required.');
    }

    try {
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
                TransactionDesc: 'Payment for CHAINET Premium Services',
            },
            { headers: { Authorization: `Bearer ${token}` } }
        );

        await db.collection('transactions').doc(response.data.CheckoutRequestID).set({
            userId: userId,
            amount: amount,
            status: 'pending',
            checkoutRequestID: response.data.CheckoutRequestID,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        return { message: 'STK Push sent successfully.', checkoutRequestID: response.data.CheckoutRequestID };
    } catch (error) {
        console.error("Payment initiation failed:", error);
        throw new functions.https.HttpsError('internal', `Payment initiation failed: ${error.message}`);
    }
});

export const mpesaCallback = functions.https.onRequest(async (req, res) => {
    const callbackData = req.body;
    const { Body: { stkCallback: { ResultCode, ResultDesc, CheckoutRequestID } } } = callbackData;

    const transactionRef = await db.collection('transactions').doc(CheckoutRequestID).get();
    if (!transactionRef.exists) {
        console.error(`Transaction ${CheckoutRequestID} not found.`);
        res.status(200).send('Transaction not found');
        return;
    }
    const { userId } = transactionRef.data()!;

    if (ResultCode === 0) {
        await db.collection('users').doc(userId).update({
            isPremium: true,
            premiumUnlockedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        await db.collection('transactions').doc(CheckoutRequestID).update({
            status: 'completed',
            resultDesc: ResultDesc,
        });
    } else {
        await db.collection('transactions').doc(CheckoutRequestID).update({
            status: 'failed',
            resultDesc: ResultDesc,
        });
    }
    res.status(200).send('OK');
});