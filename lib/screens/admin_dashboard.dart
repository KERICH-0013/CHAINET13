import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_management_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay check to ensure auth is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAdmin();
    });
  }

  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not signed in – redirecting to login.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    // Debug – show current email
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your email: ${user.email}')),
      );
    }

    // Case‑insensitive comparison
    final allowedEmail = 'labankipkoechkerich@gmail.com';
    if (user.email?.toLowerCase() != allowedEmail.toLowerCase()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized – redirecting to user dashboard.')),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
      return;
    }

    setState(() {
      _isAdmin = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_isAdmin) {
      // Access denied – show a Retry button
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Access denied – admin only.'),
              const SizedBox(height: 8),
              Text(
                'Logged in as: ${FirebaseAuth.instance.currentUser?.email ?? 'unknown'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkAdmin,
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }

    // ---------- Admin dashboard (grid) ----------
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _adminCard(
              context,
              title: 'Applications',
              icon: Icons.assignment,
              color: Colors.orange,
              onTap: () => _navigateToApplications(context),
            ),
            _adminCard(
              context,
              title: 'User Management',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/admin/user-management'),
            ),
            _adminCard(
              context,
              title: 'Pest Management',
              icon: Icons.bug_report,
              color: Colors.red,
              onTap: () => _showComingSoon(context),
            ),
            _adminCard(
              context,
              title: 'Farming Guide',
              icon: Icons.book,
              color: Colors.green,
              onTap: () => _showComingSoon(context),
            ),
            _adminCard(
              context,
              title: 'Notifications',
              icon: Icons.notifications,
              color: Colors.purple,
              onTap: () => _showComingSoon(context),
            ),
            _adminCard(
              context,
              title: 'Analytics',
              icon: Icons.analytics,
              color: Colors.teal,
              onTap: () => _showComingSoon(context),
            ),
            _adminCard(
              context,
              title: 'Export Data',
              icon: Icons.download,
              color: Colors.brown,
              onTap: () => _showComingSoon(context),
            ),
            _adminCard(
              context,
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }

  void _navigateToApplications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApplicationsManagementPage(),
      ),
    );
  }
}

// ---------- Applications Management Page (unchanged) ----------
class ApplicationsManagementPage extends StatelessWidget {
  const ApplicationsManagementPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
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