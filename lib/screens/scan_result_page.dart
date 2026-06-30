import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScanResultPage extends StatefulWidget {
  final String imagePath;
  final Uint8List? imageBytes;

  const ScanResultPage({
    super.key,
    required this.imagePath,
    this.imageBytes,
  });

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _detectedPest;

  // Pest database (same as in PestDetectionPage)
  final List<Map<String, dynamic>> _pestDatabase = [
    {
      'name': 'Tea Aphid',
      'scientificName': 'Toxoptera aurantii',
      'confidence': 92,
      'severity': 'Medium',
      'icon': '🐛',
      'description': 'Small soft-bodied insects that feed on tea leaves, causing curling and stunted growth.',
      'symptoms': [
        'Leaves curl downward',
        'Yellowing of leaves',
        'Sticky honeydew on leaves',
        'Black sooty mold growth',
        'Stunted plant growth'
      ],
      'remedies': [
        {
          'title': '🌿 Organic Control',
          'steps': [
            'Spray neem oil (5ml/L water) every 7-10 days',
            'Introduce natural predators like ladybugs',
            'Use garlic-chili spray for mild infestations'
          ]
        },
        {
          'title': '🧪 Chemical Control',
          'steps': [
            'Apply Imidacloprid 17.8% SL (0.5ml/L water)',
            'Use Thiamethoxam 25% WG (0.3g/L water)',
            'Follow safety guidelines and waiting period'
          ]
        },
        {
          'title': '🌱 Preventive Measures',
          'steps': [
            'Regular field monitoring',
            'Maintain proper plant spacing',
            'Remove weed hosts',
            'Use resistant tea varieties'
          ]
        }
      ],
      'prevention': 'Regular monitoring and maintaining plant health through proper nutrition and irrigation.'
    },
    {
      'name': 'Red Spider Mite',
      'scientificName': 'Oligonychus coffeae',
      'confidence': 78,
      'severity': 'High',
      'icon': '🕷️',
      'description': 'Tiny red mites that suck sap from leaves, causing bronzing and leaf drop.',
      'symptoms': [
        'Bronze or reddish discoloration',
        'Fine webbing on leaves',
        'Leaf drop in severe cases',
        'Stunted shoot growth',
        'Reduced photosynthesis'
      ],
      'remedies': [
        {
          'title': '🌿 Organic Control',
          'steps': [
            'Spray sulfur-based fungicide (2g/L water)',
            'Use neem oil emulsion (10ml/L water)',
            'Maintain high humidity around plants'
          ]
        },
        {
          'title': '🧪 Chemical Control',
          'steps': [
            'Apply Fenazaquin 10% EC (1.5ml/L water)',
            'Use Propargite 57% EC (2ml/L water)',
            'Rotate miticides to prevent resistance'
          ]
        },
        {
          'title': '🌱 Preventive Measures',
          'steps': [
            'Regular irrigation to maintain humidity',
            'Avoid water stress',
            'Remove infected plant parts',
            'Use predatory mites for biological control'
          ]
        }
      ],
      'prevention': 'Maintain proper irrigation and humidity levels. Regular monitoring and early detection are crucial.'
    },
    {
      'name': 'Tea Mosquito Bug',
      'scientificName': 'Helopeltis theivora',
      'confidence': 65,
      'severity': 'High',
      'icon': '🦟',
      'description': 'Sucking pest that causes characteristic circular lesions on leaves and stems.',
      'symptoms': [
        'Circular brown spots on leaves',
        'Necrotic lesions on stems',
        'Dieback of young shoots',
        'Reduced leaf quality',
        'Honeydew secretion'
      ],
      'remedies': [
        {
          'title': '🌿 Organic Control',
          'steps': [
            'Spray NSKE (5%) every 15 days',
            'Use neem cake in soil',
            'Encourage natural enemies like spiders'
          ]
        },
        {
          'title': '🧪 Chemical Control',
          'steps': [
            'Apply Acephate 75% SP (1.5g/L water)',
            'Use Fipronil 5% SC (1ml/L water)',
            'Rotate insecticides for better control'
          ]
        },
        {
          'title': '🌱 Preventive Measures',
          'steps': [
            'Maintain proper shade',
            'Avoid excessive nitrogen fertilization',
            'Regular pruning of infected shoots',
            'Use pheromone traps for monitoring'
          ]
        }
      ],
      'prevention': 'Proper shade management and balanced nutrition. Regular pruning and field sanitation.'
    },
    {
      'name': 'Healthy Leaf',
      'scientificName': 'Camellia sinensis',
      'confidence': 95,
      'severity': 'None',
      'icon': '🍃',
      'description': 'Healthy tea leaf with no signs of pest or disease damage.',
      'symptoms': [
        'No visible damage',
        'Green, glossy leaves',
        'Normal growth pattern',
        'No discoloration or spots'
      ],
      'remedies': [
        {
          'title': '✅ Maintain Health',
          'steps': [
            'Continue regular care practices',
            'Monitor weekly for any changes',
            'Maintain proper nutrition',
            'Ensure adequate irrigation'
          ]
        }
      ],
      'prevention': 'Continue with good agricultural practices and regular monitoring.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadImage();
    // Simulate pest detection
    _detectPest();
  }

  void _detectPest() {
    // Randomly select a pest for demo
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _pestDatabase.length;
    _detectedPest = _pestDatabase[randomIndex.toInt()];
  }

  Future<void> _loadImage() async {
    try {
      if (widget.imageBytes != null) {
        setState(() {
          _imageBytes = widget.imageBytes;
          _isLoading = false;
        });
        return;
      }

      if (kIsWeb) {
        final response = await http.get(Uri.parse(widget.imagePath));
        if (response.statusCode == 200) {
          setState(() {
            _imageBytes = response.bodyBytes;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to load image';
            _isLoading = false;
          });
        }
      } else {
        final File file = File(widget.imagePath);
        final bytes = await file.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading image: $e';
        _isLoading = false;
      });
    }
  }

  void _showDetailedPestInfo(Map<String, dynamic> pest) {
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
        title: const Text('Scan Result'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 16),
            Text('Loading image...'),
          ],
        ),
      )
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadImage();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      )
          : _imageBytes != null && _detectedPest != null
          ? Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text('Failed to display image'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        _detectedPest!['icon'],
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _detectedPest!['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _detectedPest!['scientificName'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildResultChip(
                        label: 'Status',
                        value: _detectedPest!['name'] == 'Healthy Leaf' ? 'Healthy' : 'Infected',
                        color: _detectedPest!['name'] == 'Healthy Leaf' ? Colors.green : Colors.red,
                        icon: _detectedPest!['name'] == 'Healthy Leaf' ? Icons.check_circle : Icons.warning,
                      ),
                      _buildResultChip(
                        label: 'Confidence',
                        value: '${_detectedPest!['confidence']}%',
                        color: Colors.blue,
                        icon: Icons.analytics,
                      ),
                      _buildResultChip(
                        label: 'Severity',
                        value: _detectedPest!['severity'],
                        color: _detectedPest!['severity'] == 'None' ? Colors.green : Colors.orange,
                        icon: Icons.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: const Text('Close'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDetailedPestInfo(_detectedPest!),
                          icon: const Icon(Icons.info),
                          label: const Text('Details & Remedies'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: Text('No image available'),
      ),
    );
  }

  Widget _buildResultChip({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imageBytes = null;
    super.dispose();
  }
}