import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pest_list_page.dart';
import 'camera_scan_page.dart';
import 'about_page.dart';
import 'scan_result_page.dart';
import 'app_vision_screen.dart';
import '../dashboard.dart';
import 'officer_directory.dart';
import 'settings_page.dart';

class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  State<PestDetectionPage> createState() => _PestDetectionPageState();
}

class _PestDetectionPageState extends State<PestDetectionPage> {
  int _currentIndex = 1; // SCAN tab is selected

  // Dummy pest data for demo results
  final List<Map<String, dynamic>> _dummyPests = [
    {'name': 'Tea Aphid', 'confidence': 92, 'severity': 'Medium', 'icon': '🐛'},
    {'name': 'Red Spider Mite', 'confidence': 78, 'severity': 'High', 'icon': '🕷️'},
    {'name': 'Tea Mosquito Bug', 'confidence': 65, 'severity': 'High', 'icon': '🦟'},
    {'name': 'Healthy Leaf', 'confidence': 95, 'severity': 'None', 'icon': '🍃'},
  ];

  String _lastScanResult = '';
  bool _showResult = false;

  Future<void> _scanAndDetect() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final capturedImagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScanPage(cameras: cameras),
        ),
      );
      if (capturedImagePath != null && capturedImagePath is String) {
        // Simulate pest detection (dummy result)
        final randomPest = _dummyPests[_dummyPests.length - 1]; // Use Healthy Leaf for demo
        // For demo, let's cycle through pests randomly
        final randomIndex = DateTime.now().millisecondsSinceEpoch % _dummyPests.length;
        final detected = _dummyPests[randomIndex.toInt()];

        setState(() {
          _lastScanResult = detected['name'];
          _showResult = true;
        });

        // Show result dialog
        _showDetectionResult(detected);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera available on this device')),
      );
    }
  }

  void _showDetectionResult(Map<String, dynamic> pest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(pest['icon'], style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            const Text('Detection Result'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected: ${pest['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Confidence: ${pest['confidence']}%'),
            Text('Severity: ${pest['severity']}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '📋 Recommendation: Apply appropriate pesticide or consult an extension officer.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PestListPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade800,
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest & Disease Detection'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
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
            // Top Card with camera
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
                    ElevatedButton(
                      onPressed: _scanAndDetect,
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
                    if (_showResult && _lastScanResult.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Last scan: $_lastScanResult detected',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Scans Section
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

            // Common Threats Guide
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
            const SizedBox(height: 16),

            // View Our Vision Button (dark green)
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppVisionScreen()),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Our Vision'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800, // dark green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'SCAN'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'COMMUNITY'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OfficerDirectory()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
          // Index 1 (SCAN) – stay on current page
        },
      ),
    );
  }

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