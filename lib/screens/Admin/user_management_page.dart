import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    if (user.email != 'labankipkoechkerich@gmail.com') {
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      return;
    }
    setState(() {
      _isAdmin = true;
      _isLoading = false;
    });
  }

  Future<void> _toggleRole(String uid, String field, bool currentValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({field: !currentValue});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${field.replaceFirst('is', '')} role toggled.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update role: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _toggleDisable(String uid, bool currentDisabled) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'disabled': !currentDisabled});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentDisabled ? 'User enabled' : 'User disabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to disable user: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_isAdmin) {
      return const Scaffold(body: Center(child: Text('Access denied')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.green.shade800,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;
              final uid = doc.id;
              return _buildUserCard(uid, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(String uid, Map<String, dynamic> data) {
    final email = data['email'] ?? 'No email';
    final isOfficer = data['isOfficer'] ?? false;
    final isAdmin = data['isAdmin'] ?? false;
    final disabled = data['disabled'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                _buildChip('Officer', isOfficer, Colors.orange),
                _buildChip('Admin', isAdmin, Colors.blue),
                _buildChip('Disabled', disabled, Colors.red),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isOfficer ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () => _toggleRole(uid, 'isOfficer', isOfficer),
                  tooltip: 'Toggle Officer',
                ),
                IconButton(
                  icon: Icon(
                    isAdmin ? Icons.admin_panel_settings : Icons.person_outline,
                    color: Colors.blue,
                  ),
                  onPressed: () => _toggleRole(uid, 'isAdmin', isAdmin),
                  tooltip: 'Toggle Admin',
                ),
                IconButton(
                  icon: Icon(
                    disabled ? Icons.check_circle : Icons.block,
                    color: disabled ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _toggleDisable(uid, disabled),
                  tooltip: disabled ? 'Enable' : 'Disable',
                ),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.purple),
                  onPressed: () => _resetPassword(email),
                  tooltip: 'Send Password Reset',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.2) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? color : Colors.grey.shade400),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: active ? color : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}