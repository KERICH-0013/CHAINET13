import 'package:flutter/material.dart';
import '../screens/weather_page.dart';
import '../screens/market_page.dart';
import '../screens/pest_detection_page.dart';
import '../screens/settings_page.dart'; // <-- added import for Settings

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHAINET'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Faded background images
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/dashboard.jpg',
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/dashboard2.jpg',
                fit: BoxFit.cover,
                height: 350,
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jambo Farmer ❤️',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Weather Card (tappable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WeatherPage()),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weather',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/dashboard.jpg',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '18°C',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Moderate Rain',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.warning, color: Colors.orange, size: 20),
                                    SizedBox(width: 4),
                                    Text(
                                      'High humidity detected! Check for pests!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Market Price + Temperature Table (tappable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MarketPage()),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Market Price',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'KSh 65/kg',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_upward,
                                            color: Colors.green, size: 16),
                                        Text(
                                          '+ KSh 2 ↑',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.green.shade800),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTempColumn('Wed', '24°', '17°'),
                              _buildTempColumn('Thu', '21°', '16°'),
                              _buildTempColumn('Fri', '25°', '15°'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Second Market Price Card with Trends (tappable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MarketPage()),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Market Price',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'KSh 65/kg',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.green.shade800),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'View Market Trends',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  _buildTrendButton('-1w'),
                                  const SizedBox(width: 8),
                                  _buildTrendButton('1d'),
                                  const SizedBox(width: 8),
                                  _buildTrendButton('Today', isSelected: true),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 NEW: Pest Detection Card (tappable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PestDetectionPage()),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.bug_report, size: 30, color: Colors.red.shade700),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pest Detection',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Scan leaves & identify threats',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green.shade800),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recommendation Card (unchanged)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommendation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'It\'s a good time to prune your tea bushes to prevent pest infestation. Focus on removing dead and damaged leaves.',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(200, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text('Ask for Farming Advice'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        // 👇 UPDATED onTap for Settings navigation
        onTap: (index) {
          if (index == 2) { // Settings tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
          // For other tabs (Dashboard=0, Chatbot=1) you can handle later
        },
      ),
    );
  }

  Widget _buildTempColumn(String day, String high, String low) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          '$high $low',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTrendButton(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade800 : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.green.shade800 : Colors.grey.shade400,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}