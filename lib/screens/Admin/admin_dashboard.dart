import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_management_page.dart';
import 'guide_management_page.dart';
import 'price_management_page.dart';
import 'weather_settings_page.dart';
import 'chatbot_management_page.dart';
import 'system_logs_page.dart';
import 'applications_review_page.dart'; // <-- added import

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Adminpage images/admin_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Darker overlay for better text readability
          Container(color: Colors.black.withOpacity(0.65)),
          // Main content with white text
          ListView(
            children: [
              _buildMenuItem(Icons.people, 'User Management', () => _navigateTo(context, UserManagementPage())),
              _buildMenuItem(Icons.menu_book, 'Farming Guides', () => _navigateTo(context, GuideManagementPage())),
              _buildMenuItem(Icons.attach_money, 'Market Prices', () => _navigateTo(context, PriceManagementPage())),
              _buildMenuItem(Icons.cloud, 'Weather Settings', () => _navigateTo(context, WeatherSettingsPage())),
              _buildMenuItem(Icons.chat, 'Chatbot FAQs', () => _navigateTo(context, ChatbotManagementPage())),
              // 🔹 New Applications menu item
              _buildMenuItem(Icons.assignment, 'Applications', () => _navigateTo(context, const ApplicationsReviewPage())),
              _buildMenuItem(Icons.settings, 'System Logs', () => _navigateTo(context, SystemLogsPage())),
              const Divider(color: Colors.white54),
              _buildMenuItem(Icons.logout, 'Log Out', () => _logout(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}