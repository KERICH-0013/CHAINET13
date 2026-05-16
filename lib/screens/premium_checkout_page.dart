import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumCheckoutPage extends StatefulWidget {
  const PremiumCheckoutPage({super.key}); // const constructor

  @override
  State<PremiumCheckoutPage> createState() => _PremiumCheckoutPageState();
}

class _PremiumCheckoutPageState extends State<PremiumCheckoutPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('initiatePayment');
      await callable.call(<String, dynamic>{
        'amount': 100, // KES 100 for premium access
        'phoneNumber': _phoneController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('STK Push sent! Check your phone to complete payment.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock Premium Services'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Get access to:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text('✅ Extension Officer Registration'),
            const Text('✅ Pest Detection Page'),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'M-Pesa Phone Number',
                hintText: 'e.g., 254712345678',
                prefixIcon: Icon(Icons.phone_android),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _initiatePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Pay with M-Pesa (KES 100)'),
            ),
          ],
        ),
      ),
    );
  }
}