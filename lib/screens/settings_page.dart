import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about_page.dart';
import 'officer_directory.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String get _userName {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final namePart = user.email!.split('@')[0];
      return namePart;
    }
    return 'Farmer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Light background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Farmingguide/prunknife.png'),
                fit: BoxFit.cover,
                opacity: 0.1, // very light / faded
              ),
            ),
          ),
          // Main content
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade50.withOpacity(0.7), Colors.white.withOpacity(0.9)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Greeting card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          '👋',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jambo $_userName 😊',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Welcome to your CHAINET settings',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Settings options
                _buildSettingTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'Learn more about CHAINET',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.people,
                  title: 'Extension Officers',
                  subtitle: 'Find and connect with officers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OfficerDirectory()),
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.green.shade800),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}