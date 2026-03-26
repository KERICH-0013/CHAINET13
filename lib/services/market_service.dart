import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  // Mock data for development – replace with real API when ready
  Future<List<Map<String, dynamic>>> getTeaPrices() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock price data (Kenyan tea auction regions)
    return [
      {
        'market': 'Mombasa Auction',
        'price': 265.50,
        'change': 2.30,   // removed '+'
        'unit': 'ksh/kg',
        'date': '2026-02-20',
        'trend': 'up',
      },
      {
        'market': 'Kericho',
        'price': 258.00,
        'change': -1.20,
        'unit': 'ksh/kg',
        'date': '2026-02-20',
        'trend': 'down',
      },
      {
        'market': 'Nandi Hills',
        'price': 262.75,
        'change': 1.85,   // removed '+'
        'unit': 'ksh/kg',
        'date': '2026-02-20',
        'trend': 'up',
      },
      {
        'market': 'Muranga',
        'price': 254.20,
        'change': 0.45,   // removed '+'
        'unit': 'ksh/kg',
        'date': '2026-02-20',
        'trend': 'up',
      },
      {
        'market': 'Kisii',
        'price': 251.90,
        'change': -0.80,
        'unit': 'ksh/kg',
        'date': '2026-02-20',
        'trend': 'down',
      },
    ];
  }

// 🚀 READY FOR REAL API – replace the function above with this structure
/*
  Future<List<Map<String, dynamic>>> getTeaPrices() async {
    final url = Uri.parse('https://api.commodities-api.com/v1/latest?access_key=YOUR_API_KEY&symbols=TEA-M');

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load prices: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      // Parse according to actual API response format
      // This is an example – adjust based on the API you choose
      return [
        {
          'market': 'Mombasa Auction',
          'price': data['rates']['TEA-M'] ?? 0.0,
          'change': 0.0, // Would need historical comparison
          'unit': 'USD/kg',
          'date': data['date'] ?? DateTime.now().toIso8601String(),
          'trend': 'neutral',
        },
        // Add other markets if available
      ];
    } catch (e) {
      throw Exception('Failed to fetch prices: $e');
    }
  }
  */
}