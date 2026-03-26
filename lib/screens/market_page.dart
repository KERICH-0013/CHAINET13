import 'package:flutter/material.dart';
import '../services/market_service.dart';
import '../screens/farming_guide_page.dart';   // <-- added import

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final MarketService _marketService = MarketService();
  List<Map<String, dynamic>>? _prices;
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'All Markets';

  final List<String> _filters = ['All Markets', 'Mombasa Auction', 'Kericho', 'Nandi Hills', 'Muranga', 'Kisii'];

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prices = await _marketService.getTeaPrices();
      setState(() {
        _prices = prices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredPrices {
    if (_prices == null) return [];
    if (_selectedFilter == 'All Markets') return _prices!;
    return _prices!.where((p) => p['market'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tea Market Prices'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 🔹 Background image (cover the whole page)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/market.jpg'), // use your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 🔹 Semi‑transparent overlay for fade effect
          Container(color: Colors.black.withOpacity(0.3)),

          // 🔹 Main content (unchanged)
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
            onRefresh: _loadPrices,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                  const SizedBox(height: 20),

                  // Filter chips
                  _buildFilterChips(),
                  const SizedBox(height: 20),

                  // Last updated
                  if (_prices != null && _prices!.isNotEmpty)
                    Text(
                      'Last updated: ${_formatDate(_prices![0]['date'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Price cards
                  ..._filteredPrices.map((price) => _buildPriceCard(price)).toList(),

                  // 🔹 New button to navigate to Farming Guide
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FarmingGuidePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'View Farming Guide',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // extra bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filter),
              selected: _selectedFilter == filter,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white.withOpacity(0.2),
              selectedColor: Colors.green.shade800,
              labelStyle: TextStyle(
                color: _selectedFilter == filter ? Colors.white : Colors.white70,
                fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
              ),
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceCard(Map<String, dynamic> price) {
    final isUp = price['trend'] == 'up';
    final changeColor = isUp ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price['market'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${price['price'].toStringAsFixed(2)} ${price['unit']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: changeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                  color: changeColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${price['change'].toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: changeColor,
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
                // Market icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.agriculture,
                    size: 32,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
              'Failed to load market prices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPrices,
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}