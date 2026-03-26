import 'dart:io'; // <-- required for File
import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  final String imagePath;

  const ScanResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the captured image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text('Image could not be loaded'),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pest name (placeholder)
            const Text(
              'Possible Pest: Tea Aphid',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toxoptera aurantii',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),

            // Confidence (mock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade800),
              ),
              child: const Text(
                'Confidence: 87%',
                style: TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Small soft-bodied insects that cluster on young shoots, sucking sap and secreting honeydew. Causes curling and distortion of leaves.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Recommended treatments
            const Text(
              'Recommended Treatments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Chemical: Dimethoate 30% EC',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Application rate: 1.5 ml per liter of water'),
                    Text('Waiting period: 10 days'),
                    Text('Safety: Wear protective gear'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Organic: Neem oil',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Application rate: 5 ml per liter of water'),
                    Text('Waiting period: 1 day'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Prevention tips
            const Text(
              'Prevention Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Remove heavily infested shoots'),
            const Text('• Conserve ladybird beetles'),
            const Text('• Avoid excessive nitrogen'),
          ],
        ),
      ),
    );
  }
}