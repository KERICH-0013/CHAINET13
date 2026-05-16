// lib/screens/admin/applications_review_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationsReviewPage extends StatelessWidget {
  const ApplicationsReviewPage({super.key});

  Future<void> _updateApplicationStatus(BuildContext context, String appId, String newStatus, {String? feedback}) async {
    try {
      await FirebaseFirestore.instance.collection('applications').doc(appId).update({
        'status': newStatus,
        'adminFeedback': feedback,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application ${newStatus.toUpperCase()}!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status.')),
        );
      }
    }
  }

  void _viewDocument(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extension Officer Applications'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .orderBy('appliedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final applications = snapshot.data!.docs;

          if (applications.isEmpty) {
            return const Center(child: Text('No applications found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final doc = applications[index];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['applicantName'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Email: ${data['email']}'),
                      Text('Phone: ${data['phoneNumber']}'),
                      const SizedBox(height: 8),
                      const Text('Documents:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (data['idUrl'] != null)
                            ElevatedButton(
                              onPressed: () => _viewDocument(data['idUrl']),
                              child: const Text('View ID'),
                            ),
                          if (data['letterUrl'] != null)
                            ElevatedButton(
                              onPressed: () => _viewDocument(data['letterUrl']),
                              child: const Text('View Letter'),
                            ),
                          if (data['cvUrl'] != null)
                            ElevatedButton(
                              onPressed: () => _viewDocument(data['cvUrl']),
                              child: const Text('View CV'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(
                            label: Text(status.toUpperCase()),
                            backgroundColor: status == 'approved'
                                ? Colors.green.shade100
                                : status == 'rejected'
                                ? Colors.red.shade100
                                : Colors.orange.shade100,
                          ),
                          const Spacer(),
                          if (status == 'pending') ...[
                            ElevatedButton(
                              onPressed: () => _updateApplicationStatus(context, doc.id, 'approved'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _updateApplicationStatus(context, doc.id, 'rejected'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Reject'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}