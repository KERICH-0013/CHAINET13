import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pest_list_page.dart';
import 'camera_scan_page.dart';
import 'about_page.dart';
import 'scan_result_page.dart'; // <-- added for result display

class PestDetectionPage extends StatelessWidget {
  const PestDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest & Disease Detection'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          // 🔹 Prominent "About" button with icon and label
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            icon: const Icon(Icons.info_outline, color: Colors.white),
            label: const Text(
              'About',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Card with camera preview placeholder ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade800, width: 2),
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Align leaf within frame',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Updated Scan Now button – captures image and shows result
                    ElevatedButton(
                      onPressed: () async {
                        final cameras = await availableCameras();
                        if (cameras.isNotEmpty) {
                          final capturedImagePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScanPage(cameras: cameras),
                            ),
                          );
                          if (capturedImagePath != null && capturedImagePath is String) {
                            // Navigate to result page with the image
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScanResultPage(imagePath: capturedImagePath),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No camera available on this device')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Scan Now'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Recent Scans Section ---
            const Text(
              'Recent Scans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRecentScanItem(
              time: 'TODAY, 10:24 AM',
              status: 'Healthy',
              threat: 'NO THREAT',
              color: Colors.green,
            ),
            _buildRecentScanItem(
              time: 'MAY',
              status: 'Red',
              threat: 'ALERT',
              color: Colors.red,
            ),
            const SizedBox(height: 24),

            // --- Common Threats Guide ---
            const Text(
              'Common Threats Guide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildThreatCard(
                  context: context,
                  title: 'Tea Blight',
                  subtitle: 'Fungal Disease',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Aphids',
                  subtitle: 'Sucking Insect',
                  icon: Icons.bug_report,
                  color: Colors.brown,
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Red Rust',
                  subtitle: 'Algal Attack',
                  icon: Icons.wb_sunny,
                  color: Colors.red,
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Grey Blight',
                  subtitle: 'Spot Disease',
                  icon: Icons.bolt,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'SCAN'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'COMMUNITY'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
        onTap: (index) {},
      ),
    );
  }

  // Helper for recent scan items
  Widget _buildRecentScanItem({
    required String time,
    required String status,
    required String threat,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            threat == 'NO THREAT' ? Icons.check_circle : Icons.warning,
            color: color,
          ),
        ),
        title: Text(time),
        subtitle: Text('$status • $threat'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green.shade800),
      ),
    );
  }

  // Helper for threat guide grid items – receives context
  Widget _buildThreatCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PestListPage()),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}