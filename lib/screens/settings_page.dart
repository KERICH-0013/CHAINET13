import 'package:flutter/material.dart';
import 'about_page.dart'; // import the about page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // About ListTile
          ListTile(
            leading: Icon(Icons.info, color: Colors.green.shade800),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          // You can add more settings options here later
        ],
      ),
    );
  }
}