import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

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
                image: AssetImage('assets/images/farming guide.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi‑transparent overlay
          Container(color: Colors.black.withOpacity(0.2)),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                // 1. Weekly Tip Section (existing)
                _buildSectionTitle('Weekly Tip'),
                const SizedBox(height: 12),
                _buildTipItemWithImage(
                  title: 'Pruning in Humid Weather',
                  description:
                  'Prune your tea bushes regularly in humid conditions to prevent pest infestation.',
                  imageAsset: 'assets/images/Farmingguide/prun.png',
                ),
                const SizedBox(height: 20),

                // 2. Harvest Guide Section (new)
                _buildSectionTitle('Harvest Guide'),
                const SizedBox(height: 12),
                _buildGuideItemWithImage(
                  title: 'Pluck 2 Leaves and a Bud',
                  description:
                  'Always harvest the tender top two leaves and the unopened bud. This ensures high quality tea and promotes healthy regrowth.',
                  imageAsset: 'assets/images/Farmingguide/harvest.png',
                ),
                const SizedBox(height: 20),

                // 3. How to Prune Section (new)
                _buildSectionTitle('How to Prune'),
                const SizedBox(height: 12),
                _buildGuideItemWithImage(
                  title: 'Proper Pruning Techniques',
                  description:
                  'Use sharp, clean tools. Cut at an angle just above a leaf node. Remove dead or diseased branches first, then shape the bush to encourage air circulation.',
                  imageAsset: 'assets/images/Farmingguide/prunknife.png',
                ),
                const SizedBox(height: 20),

                // 4. Fertilizer Guide Section (moved and enhanced)
                _buildSectionTitle('Fertilizer Guide'),
                const SizedBox(height: 12),
                _buildGuideItemWithImage(
                  title: 'Recommended Fertilizers',
                  description:
                  'Apply the right nutrients for healthy tea bushes:',
                  imageAsset: 'assets/images/Farmingguide/Npk.png',
                  bullets: ['Nitrogen for leaf growth', 'NPK 25-5-5 (Early Growth)'],
                ),
                const SizedBox(height: 20),

                // 5. Pests Section (unchanged)
                _buildSectionTitle('Pests'),
                const SizedBox(height: 12),
                _buildSubsectionTitle('Common Tea Pests'),
                const SizedBox(height: 8),
                _buildPestItem(
                  title: 'Aphids',
                  description: 'Tiny insects that suck sap from the leaves, causing stunted growth.',
                ),
                const SizedBox(height: 20),

                // 6. Dynamic Farming Guides from Firestore
                _buildSectionTitle('Farming Guides'),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('farming_guides')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final guides = snapshot.data!.docs;
                    if (guides.isEmpty) {
                      return const Text('No farming guides available.');
                    }
                    return Column(
                      children: guides.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'] ?? 'Untitled',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(data['content'] ?? 'No content'),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Button to Chatbot
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
                const SizedBox(height: 20),
              ],
            ),
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

  // Helper widgets
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

  // Generic guide item with image and optional bullet list
  Widget _buildGuideItemWithImage({
    required String title,
    required String description,
    required String imageAsset,
    List<String>? bullets,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 30),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  if (bullets != null) ...[
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
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Learn More →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Weekly Tip (same as guide but without bullets)
  Widget _buildTipItemWithImage({
    required String title,
    required String description,
    required String imageAsset,
  }) {
    return _buildGuideItemWithImage(
      title: title,
      description: description,
      imageAsset: imageAsset,
      bullets: null,
    );
  }

  // Pest item (unchanged)
  Widget _buildPestItem({required String title, required String description}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Learn More →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}