import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'pest_list_page.dart';
import 'camera_scan_page.dart';
import 'about_page.dart';
import 'scan_result_page.dart';
import 'app_vision_screen.dart';
import 'pest_library.dart'; // Import the pest library
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

  String _lastScanResult = '';
  bool _showResult = false;
  bool _isProcessing = false;

  // Get random pest from the library
  Map<String, dynamic> _getRandomPest() {
    final pest = PestLibrary.getRandomPest();
    return {
      'name': pest.name,
      'scientificName': pest.scientificName,
      'confidence': pest.confidence,
      'severity': pest.severity,
      'icon': pest.icon,
      'description': pest.description,
      'symptoms': pest.symptoms,
      'remedies': pest.remedies.map((r) => {
        'title': r.title,
        'steps': r.steps,
      }).toList(),
      'prevention': pest.prevention,
    };
  }

  // Get pest by name for threat cards
  Map<String, dynamic> _getPestDataByName(String name) {
    final pest = PestLibrary.getPestByName(name);
    if (pest != null) {
      return {
        'name': pest.name,
        'scientificName': pest.scientificName,
        'confidence': pest.confidence,
        'severity': pest.severity,
        'icon': pest.icon,
        'description': pest.description,
        'symptoms': pest.symptoms,
        'remedies': pest.remedies.map((r) => {
          'title': r.title,
          'steps': r.steps,
        }).toList(),
        'prevention': pest.prevention,
      };
    }
    return _getRandomPest(); // Fallback
  }

  Future<void> _scanAndDetect() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final capturedImagePath = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScanPage(cameras: cameras),
          ),
        );

        if (mounted && capturedImagePath != null && capturedImagePath is String) {
          // Simulate pest detection with random pest
          final detected = _getRandomPest();

          setState(() {
            _lastScanResult = detected['name'];
            _showResult = true;
          });

          // Show detailed result with remedies
          _showDetailedDetectionResult(detected);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No camera available on this device')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _uploadFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (mounted && image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanResultPage(
                imagePath: image.path,
                imageBytes: bytes,
              ),
            ),
          );
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanResultPage(
                imagePath: image.path,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showDetailedDetectionResult(Map<String, dynamic> pest) {
    if (!mounted) return;

    final bool isHealthy = pest['name'] == 'Healthy Leaf';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(pest['icon'], style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pest['name'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pest['scientificName'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Confidence and Severity
              Row(
                children: [
                  _buildInfoChip(
                    label: 'Confidence',
                    value: '${pest['confidence']}%',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    label: 'Severity',
                    value: pest['severity'],
                    color: pest['severity'] == 'None' ? Colors.green : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pest['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Symptoms
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Common Symptoms',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    ...List.generate(
                      pest['symptoms'].length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(
                              child: Text(pest['symptoms'][index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Remedies
              const Text(
                '🛠️ Recommended Remedies',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                pest['remedies'].length,
                    (index) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pest['remedies'][index]['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...List.generate(
                        pest['remedies'][index]['steps'].length,
                            (stepIndex) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${stepIndex + 1}. ',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: Text(pest['remedies'][index]['steps'][stepIndex]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Prevention
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌱 Prevention Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(pest['prevention']),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!isHealthy)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PestListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
              ),
              child: const Text('View All Pests'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
                      child: _isProcessing
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      )
                          : const Icon(
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
                    // Buttons Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        // Scan Now Button
                        ElevatedButton(
                          onPressed: _isProcessing ? null : _scanAndDetect,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text('Scan Now'),
                        ),
                        // Upload from Gallery Button
                        ElevatedButton(
                          onPressed: _isProcessing ? null : _uploadFromGallery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text('Upload Photo'),
                        ),
                      ],
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
              status: 'Red Spider Mite',
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
                  pestData: _getPestDataByName('Tea Blight'),
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Aphids',
                  subtitle: 'Sucking Insect',
                  icon: Icons.bug_report,
                  color: Colors.brown,
                  pestData: _getPestDataByName('Tea Aphid'),
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Red Rust',
                  subtitle: 'Algal Attack',
                  icon: Icons.wb_sunny,
                  color: Colors.red,
                  pestData: _getPestDataByName('Red Spider Mite'),
                ),
                _buildThreatCard(
                  context: context,
                  title: 'Grey Blight',
                  subtitle: 'Spot Disease',
                  icon: Icons.bolt,
                  color: Colors.grey,
                  pestData: _getPestDataByName('Tea Jassid'),
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
                  backgroundColor: Colors.green.shade800,
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
    required Map<String, dynamic> pestData,
  }) {
    return GestureDetector(
      onTap: () {
        _showDetailedDetectionResult(pestData);
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

  @override
  void dispose() {
    _isProcessing = false;
    super.dispose();
  }
}