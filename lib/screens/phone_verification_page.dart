// lib/screens/phone_verification_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // <-- added
import '../dashboard.dart'; // Points to dashboard.dart in lib folder

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  const PhoneVerificationPage({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _codeSent = false;
  String _verificationId = '';
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber.isNotEmpty) {
      _sendOtp();
    }
  }

  void _sendOtp() async {
    setState(() => _isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto‑retrieval or instant verification on Android
        _auth.signInWithCredential(credential).then((_) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          }
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Auto‑verification failed: $e')),
          );
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
        setState(() => _isLoading = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _codeSent = true;
          _verificationId = verificationId;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Timeout – you could show a "resend" button
      },
    );
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      await _auth.signInWithCredential(credential);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_codeSent)
              const CircularProgressIndicator()
            else ...[
              const Text('Enter the 6‑digit code sent to'),
              const SizedBox(height: 8),
              Text(
                widget.phoneNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // 🔁 Pinput replaced with PinCodeTextField
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                onCompleted: (pin) => _verifyOtp(),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Colors.grey.shade200,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Verify'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}