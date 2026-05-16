// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _updateStatus(BuildContext context, String appId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(appId)
          .update({'status': newStatus});
      if (newStatus == 'approved') {
        final doc = await FirebaseFirestore.instance.collection('applications').doc(appId).get();
        final data = doc.data()!;
        await FirebaseFirestore.instance.collection('users').doc(data['userId']).set({
          'isOfficer': true,
          'officerName': data['applicantName'],
          'officerPhone': data['phoneNumber'],
          'officerEmail': data['email'],
          'officerAddress': data['address'],
        }, SetOptions(merge: true));
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application $newStatus')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add admin check (only show if current user is admin)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .orderBy('appliedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No applications'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending';
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${data['applicantName']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Email: ${data['email']}'),
                      Text('Phone: ${data['phoneNumber']}'),
                      Text('Address: ${data['address']}'),
                      const SizedBox(height: 8),
                      const Text('Questionnaire:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(data['questionnaire'] as Map<String, dynamic>).entries.map((e) => Text('• ${e.key}\n  ${e.value}')),
                      const SizedBox(height: 8),
                      if (data['certificateUrl'] != null)
                        GestureDetector(
                          onTap: () => {/* TODO: Open URL */},
                          child: Text('View Certificate', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(label: Text(status.toUpperCase())),
                          const Spacer(),
                          if (status == 'pending')
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _updateStatus(context, docs[i].id, 'approved'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Approve'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _updateStatus(context, docs[i].id, 'rejected'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
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