import 'package:flutter/material.dart';
import '../models/pest_model.dart';

class PestDetailPage extends StatelessWidget {
  final Pest pest;

  const PestDetailPage({super.key, required this.pest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pest.name),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image gallery (simplified – just first image)
            if (pest.imageUrls.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(pest.imageUrls.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              pest.scientificName,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getSeverityColor(pest.severity).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getSeverityColor(pest.severity)),
              ),
              child: Text(
                'Severity: ${pest.severity.toUpperCase()}',
                style: TextStyle(color: _getSeverityColor(pest.severity)),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection('Description', pest.description),
            _buildSection('Symptoms', pest.symptoms),
            _buildSection('Affected Parts', pest.affectedParts.join(', ')),
            const SizedBox(height: 16),
            const Text('Treatments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...pest.treatments.map((t) => _buildTreatmentCard(t)),
            const SizedBox(height: 16),
            _buildSection('Prevention Tips', pest.preventionTips.join('\n• ')),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard(Treatment t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Active: ${t.activeIngredient}'),
            Text('Rate: ${t.applicationRate}'),
            Text('Waiting period: ${t.waitingPeriod}'),
            Text('Safety: ${t.safetyPrecautions}'),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }
}