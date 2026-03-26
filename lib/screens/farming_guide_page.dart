import 'package:flutter/material.dart';
import 'chat_page.dart'; // <-- added import for chatbot page

class FarmingGuidePage extends StatelessWidget {
  const FarmingGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Guide'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/farming guide.jpg'), // your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi‑transparent overlay
          Container(color: Colors.black.withOpacity(0.2)),
          // Main content
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header
              const Text(
                'Farming Guide',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Get expert advice to improve your tea harvest',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Search/Ask field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: '🔍 Ask about tea pests, weather, tips...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Pests Section
              _buildSectionTitle('Pests'),
              const SizedBox(height: 12),
              _buildSubsectionTitle('Common Tea Pests'),
              const SizedBox(height: 8),
              _buildPestItem(
                title: 'Aphids',
                description: 'Tiny insects that suck sap from the leaves, causing stunted growth.',
              ),
              const SizedBox(height: 20),

              // Weekly Tip Section
              _buildSectionTitle('Weekly Tip'),
              const SizedBox(height: 12),
              _buildTipItem(
                title: 'Pruning in Humid Weather',
                description:
                'Prune your tea bushes regularly in humid conditions to prevent pest infestation.',
              ),
              const SizedBox(height: 20),

              // Weather / Fertilizer Guide Section
              _buildSectionTitle('Weather'),
              const SizedBox(height: 12),
              _buildSubsectionTitle('Fertilizer Guide'),
              const SizedBox(height: 8),
              _buildFertilizerItem(
                'Recommended Fertilizers',
                bullets: ['Nitrogen for leaf growth', 'NPK 25-5-5 (Early Growth)'],
              ),
              const SizedBox(height: 30),

              // 🔹 New button to navigate to Chatbot Page
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Ask Chatbot',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20), // extra bottom padding
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Farming Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }

  // Helper: section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade800,
      ),
    );
  }

  // Helper: subsection title
  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Pest item with "Learn More" button
  Widget _buildPestItem({required String title, required String description}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to detailed pest page
                },
                child: const Text('Learn More →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tip item with "Learn More" button
  Widget _buildTipItem({required String title, required String description}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to detailed tip page
                },
                child: const Text('Learn More →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fertilizer item with bullet points
  Widget _buildFertilizerItem(String title, {required List<String> bullets}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...bullets.map(
                  (bullet) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(bullet, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}