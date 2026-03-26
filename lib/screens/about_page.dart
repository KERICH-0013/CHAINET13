import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Tea'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 🔹 Larger circular profile image (radius increased to 55)
              CircleAvatar(
                radius: 55, // slightly larger for better visibility
                backgroundImage: AssetImage('assets/images/about1.jpg'),
              ),
              const SizedBox(height: 8),

              // 🔹 Developer name prominently displayed
              const Text(
                'Developer: LabanKipkoechKerich',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // App name
              const Text(
                'Tea+',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),

              // Main title
              const Text(
                'CHAINET',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Empowering Tea Farmers with Real-Time Intelligence',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Version
              _buildInfoRow('Version', '1.0.0'),
              const SizedBox(height: 12),

              // Developer row (optional – you can keep or remove)
              _buildInfoRow('Developer', 'LabanKipkoechKerich'),
              const SizedBox(height: 40),

              // Legal links
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SUPPORT & LEGAL',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildLinkTile('Privacy Policy', () {
                // TODO: Launch privacy policy URL
              }),
              _buildLinkTile('Terms of Service', () {
                // TODO: Launch terms URL
              }),
              _buildLinkTile('Contact Support', () {
                // TODO: Launch email or support page
              }),
              const SizedBox(height: 40),

              // Copyright
              const Text(
                '© 2026 CHAINET. All Rights Reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to display a key-value row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Helper for legal links (tappable)
  Widget _buildLinkTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.green.shade700,
          decoration: TextDecoration.underline,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}