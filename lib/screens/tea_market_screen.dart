import 'package:flutter/material.dart';
import '../services/tea_market_service.dart';
import '../screens/chat_page.dart';
import '../screens/farming_guide_page.dart'; // Add this import

class TeaMarketScreen extends StatefulWidget {
  const TeaMarketScreen({super.key});

  @override
  State<TeaMarketScreen> createState() => _TeaMarketScreenState();
}

class _TeaMarketScreenState extends State<TeaMarketScreen> {
  final TeaMarketService _marketService = TeaMarketService();
  Map<String, dynamic>? _currentPrice;
  List<Map<String, dynamic>>? _historicalPrices;
  Map<String, dynamic>? _marketTrends;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  int _selectedChartDays = 7;
  String _lastRefreshTime = '';

  // Exchange rate (USD to KES) - you can update this periodically
  final double _exchangeRate = 130.0;

  @override
  void initState() {
    super.initState();
    _loadMarketData();
  }

  // Convert USD to KES
  double _convertToKES(double usdPrice) {
    return usdPrice * _exchangeRate;
  }

  Future<void> _loadMarketData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final price = await _marketService.getCurrentPrice();
      final history = await _marketService.getHistoricalPrices(days: 30);
      final trends = await _marketService.getMarketTrends();

      setState(() {
        _currentPrice = price;
        _historicalPrices = history;
        _marketTrends = trends;
        _isLoading = false;
        _lastRefreshTime = _getCurrentTime();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final price = await _marketService.getCurrentPrice();
      final history = await _marketService.getHistoricalPrices(days: 30);
      final trends = await _marketService.getMarketTrends();

      setState(() {
        _currentPrice = price;
        _historicalPrices = history;
        _marketTrends = trends;
        _isRefreshing = false;
        _lastRefreshTime = _getCurrentTime();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isRefreshing = false;
      });
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> get _filteredHistory {
    if (_historicalPrices == null) return [];
    return _historicalPrices!.reversed.take(_selectedChartDays).toList().reversed.toList();
  }

  // Navigate to Farming Guide Page
  void _navigateToFarmingGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FarmingGuidePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tea Market Prices'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Farming Guide Button - Top Right
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: _navigateToFarmingGuide,
            tooltip: 'Farming Guide',
          ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
            tooltip: 'Refresh prices',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image (cover the whole page)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/market.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi‑transparent overlay for fade effect
          Container(color: Colors.black.withOpacity(0.3)),

          // Main content
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title for better visual
                  const Text(
                    'Kenya Tea Auction',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real‑time prices from major markets',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // API Key indicator (subtle – shows it's using an API)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Live Data • API Connected',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last updated time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last updated: $_lastRefreshTime',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      Text(
                        'API: ${(_currentPrice?['api_key_used'] ?? '').substring(0, 20)}...',
                        style: const TextStyle(fontSize: 10, color: Colors.white60),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main price card (UPDATED with KES)
                  _buildMainPriceCard(),
                  const SizedBox(height: 20),

                  // Market stats row (UPDATED with KES)
                  _buildMarketStatsRow(),
                  const SizedBox(height: 20),

                  // Price chart
                  _buildPriceChartCard(),
                  const SizedBox(height: 20),

                  // Recent prices table (UPDATED with KES)
                  _buildRecentPricesTable(),
                  const SizedBox(height: 20),

                  // Market trends
                  _buildMarketTrendsCard(),

                  const SizedBox(height: 20),

                  // Chat Button
                  _buildChatButton(),
                  const SizedBox(height: 20),

                  // Farming Guide Button - Bottom Center
                  _buildFarmingGuideButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPriceCard() {
    final isPositive = (_currentPrice?['change_direction'] ?? 'up') == 'up';
    final changeColor = isPositive ? Colors.green : Colors.red;
    final changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;
    final priceUSD = double.parse(_currentPrice?['rates']['TEA-M'] ?? '0');
    final priceKES = _convertToKES(priceUSD);
    final change = double.parse(_currentPrice?['change'] ?? '0');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.95),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              _currentPrice?['market'] ?? 'Mombasa Tea Auction',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // USD price (primary)
            Text(
              'USD ${priceUSD.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            // KES price (secondary - for local farmers)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '≈ KES ${priceKES.toStringAsFixed(2)} per kg',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              _currentPrice?['unit'] ?? 'per kilogram',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: changeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(changeIcon, size: 16, color: changeColor),
                  const SizedBox(width: 4),
                  Text(
                    '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                    style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'vs previous day',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Trading volume: ${_currentPrice?['volume']} ${_currentPrice?['volume_unit']}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketStatsRow() {
    final priceUSD = double.parse(_currentPrice?['rates']['TEA-M'] ?? '0');
    final previousCloseUSD = double.parse(_currentPrice?['previous_close'] ?? priceUSD.toString());
    final previousCloseKES = _convertToKES(previousCloseUSD);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Previous Close',
            value: 'USD ${previousCloseUSD.toStringAsFixed(4)}\n≈ KES ${previousCloseKES.toStringAsFixed(2)}',
            icon: Icons.history,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Today\'s Range',
            value: 'USD 2.68 – 3.02\n≈ KES 348 – 393',
            icon: Icons.compare_arrows,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: '52 Week Range',
            value: 'USD 2.45 – 3.35\n≈ KES 318 – 436',
            icon: Icons.show_chart,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.green.shade700),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price Trend (30 days)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildChartButton(7),
                    const SizedBox(width: 8),
                    _buildChartButton(14),
                    const SizedBox(width: 8),
                    _buildChartButton(30),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _filteredHistory.isEmpty
                  ? const Center(child: Text('No data available'))
                  : CustomPaint(
                painter: LineChartPainter(
                  data: _filteredHistory.map((e) => double.parse(e['price'])).toList(),
                  labels: _filteredHistory.map((e) => e['date_string'] as String).toList(),
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartButton(int days) {
    final isSelected = _selectedChartDays == days;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartDays = days;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade800 : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade800),
        ),
        child: Text(
          '$days days',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentPricesTable() {
    final history = _filteredHistory;
    if (history.isEmpty) return const SizedBox();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Auction Prices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(1.8),
                    2: FlexColumnWidth(1.8),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(1.5),
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Colors.green),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('USD/kg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('KES/kg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Change', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Volume', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...history.map((item) {
                      final index = history.indexOf(item);
                      final currentPriceUSD = double.parse(item['price']);
                      final currentPriceKES = _convertToKES(currentPriceUSD);
                      final prevPrice = index > 0 ? double.parse(history[index - 1]['price']) : currentPriceUSD;
                      final change = ((currentPriceUSD - prevPrice) / prevPrice * 100);
                      final isPositive = change >= 0;
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(item['date_string']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(currentPriceUSD.toStringAsFixed(4)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(currentPriceKES.toStringAsFixed(2)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                              style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('${(2200000 + (index * 15000)).toStringAsFixed(0)}'),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketTrendsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Outlook',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTrendIndicator(
                    label: 'Daily Trend',
                    value: _marketTrends?['daily_trend'] ?? 'neutral',
                  ),
                ),
                Expanded(
                  child: _buildTrendIndicator(
                    label: 'Weekly Trend',
                    value: _marketTrends?['weekly_trend'] ?? 'neutral',
                  ),
                ),
                Expanded(
                  child: _buildTrendIndicator(
                    label: 'Monthly Trend',
                    value: _marketTrends?['monthly_trend'] ?? 'neutral',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next auction date: ${_marketTrends?['next_auction_date'] ?? 'TBD'}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Exchange rate: 1 USD = ${_exchangeRate.toStringAsFixed(2)} KES',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
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

  Widget _buildTrendIndicator({required String label, required String value}) {
    Color color;
    IconData icon;

    if (value == 'bullish' || value == 'upward' || value == 'positive') {
      color = Colors.green;
      icon = Icons.trending_up;
    } else if (value == 'bearish' || value == 'downward' || value == 'negative') {
      color = Colors.red;
      icon = Icons.trending_down;
    } else {
      color = Colors.grey;
      icon = Icons.remove;
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        Text(
          value.toUpperCase(),
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  // Chat Button
  Widget _buildChatButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.95),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 32,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Farming Advice?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chat with our AI assistant for personalized farming tips, pest control advice, and market strategies',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.green.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Farming Guide Button - Bottom Center
  Widget _buildFarmingGuideButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _navigateToFarmingGuide,
        icon: const Icon(Icons.menu_book, size: 24),
        label: const Text(
          'View Farming Guide',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Failed to load market data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMarketData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// Line chart painter
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;

  LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final yPadding = range * 0.1;
    final effectiveMin = minY - yPadding;
    final effectiveMax = maxY + yPadding;
    final effectiveRange = effectiveMax - effectiveMin;

    final dx = size.width / (data.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final y = size.height - ((data[i] - effectiveMin) / effectiveRange) * size.height;
      points.add(Offset(x, y));
    }

    // Draw fill
    final fillPath = Path()..addPolygon([Offset(0, size.height), ...points, Offset(size.width, size.height)], true);
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, 4, Paint()..color = Colors.white);
      canvas.drawCircle(point, 4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}