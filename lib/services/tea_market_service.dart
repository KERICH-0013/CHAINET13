import 'dart:math';

class TeaMarketService {
  // This looks like a real API key – but it's for demonstration purposes
  final String apiKey = 'CHAINET_TEA_MARKET_7H3G9K2P_LIVE_DEMO_2026';

  // Simulate API endpoint
  final String _baseUrl = 'https://api.chainet.com/v1/market/tea';

  // Internal price tracker that changes slightly with each refresh
  double _currentPrice = 2.85;
  final Random _random = Random();

  // Generate realistic price movement (like real market fluctuations)
  double _generatePriceChange() {
    // Random change between -0.08 and +0.08
    final change = (_random.nextDouble() - 0.5) * 0.16;
    _currentPrice += change;

    // Keep price within realistic range ($2.40 – $3.60 per kg)
    if (_currentPrice < 2.40) _currentPrice = 2.40;
    if (_currentPrice > 3.60) _currentPrice = 3.60;

    return _currentPrice;
  }

  // Get live tea price data
  Future<Map<String, dynamic>> getCurrentPrice() async {
    // Simulate network latency (real API would have this)
    await Future.delayed(const Duration(milliseconds: 800));

    final newPrice = _generatePriceChange();
    final previousPrice = newPrice - (_random.nextDouble() * 0.15);

    // Calculate percentage change
    final percentChange = ((newPrice - previousPrice) / previousPrice) * 100;

    // Generate timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return {
      'success': true,
      'timestamp': timestamp,
      'date': DateTime.now().toIso8601String().split('T')[0],
      'base': 'USD',
      'rates': {
        'TEA-M': newPrice.toStringAsFixed(4),
      },
      'unit': 'per kilogram',
      'market': 'Mombasa Tea Auction',
      'previous_close': previousPrice.toStringAsFixed(4),
      'change': percentChange.toStringAsFixed(2),
      'change_direction': percentChange >= 0 ? 'up' : 'down',
      'volume': '2,450,000',
      'volume_unit': 'kg',
      'api_key_used': apiKey,
    };
  }

  // Get historical prices for chart
  Future<List<Map<String, dynamic>>> getHistoricalPrices({int days = 30}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final List<Map<String, dynamic>> history = [];
    final now = DateTime.now();
    var simulatedPrice = 2.80;

    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Add realistic daily variation
      final dailyChange = (_random.nextDouble() - 0.5) * 0.12;
      simulatedPrice += dailyChange;

      // Keep within realistic range
      if (simulatedPrice < 2.40) simulatedPrice = 2.40;
      if (simulatedPrice > 3.60) simulatedPrice = 3.60;

      history.add({
        'date': date,
        'date_string': '${date.month}/${date.day}',
        'price': simulatedPrice.toStringAsFixed(4),
        'iso_date': date.toIso8601String().split('T')[0],
      });
    }

    return history;
  }

  // Get market trends (up/down over different periods)
  Future<Map<String, dynamic>> getMarketTrends() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return {
      'daily_trend': _random.nextDouble() > 0.5 ? 'bullish' : 'bearish',
      'weekly_trend': _random.nextDouble() > 0.4 ? 'upward' : 'downward',
      'monthly_trend': _random.nextDouble() > 0.3 ? 'positive' : 'negative',
      'volatility': 'moderate',
      'next_auction_date': DateTime.now().add(const Duration(days: 3)).toIso8601String().split('T')[0],
    };
  }
}