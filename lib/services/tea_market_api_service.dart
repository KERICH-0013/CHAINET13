import 'dart:math';
import '../models/tea_market_model.dart';

class TeaMarketApiService {
  final Random _random = Random();

  // The main "API" call that returns the full dashboard data
  Future<TeaMarketOverview> fetchMarketOverview() async {
    // Simulate network latency (500ms - 1s)
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(500)));

    final exchangeRate = 130.00; // 1 USD = 130 KES

    // 1. Generate the daily spot price (around $2.70 - $2.90)
    double spotUsd = 2.70 + _random.nextDouble() * 0.25;
    double changePercent = -2.0 + _random.nextDouble() * 4.0; // -2% to +2%

    // 2. Generate 7 days of historical data (backwards from today)
    List<HistoricalPrice> history = [];
    List<double> historicalPrices = [];
    double basePrice = spotUsd - (changePercent / 100) * spotUsd; // Approx previous day

    for (int i = 7; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String dateStr = "${date.month}/${date.day}";

      // Random walk for realistic fluctuation
      double price = basePrice + (-0.05 + _random.nextDouble() * 0.10);
      price = double.parse(price.toStringAsFixed(4));
      historicalPrices.add(price);

      double dailyChange = 0;
      if (i > 0) {
        dailyChange = ((price - basePrice) / basePrice) * 100;
        dailyChange = double.parse(dailyChange.toStringAsFixed(2));
      }

      history.add(HistoricalPrice(
        date: dateStr,
        usd: price,
        kes: double.parse((price * exchangeRate).toStringAsFixed(2)),
        changePercent: i == 0 ? changePercent : dailyChange,
        volume: 2200000 + _random.nextInt(300000), // 2.2M - 2.5M kg
      ));
      basePrice = price; // Move forward
    }

    // Sort ascending by date (oldest to newest)
    history = history.reversed.toList();

    // 3. Calculate Summary Ranges
    double minPrice = historicalPrices.reduce((a, b) => a < b ? a : b);
    double maxPrice = historicalPrices.reduce((a, b) => a > b ? a : b);
    double rangeBuffer = 0.25; // For 52-week high/low

    return TeaMarketOverview(
      marketName: "Mombasa Tea Auction",
      lastUpdated: "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
      apiKey: "CHAINET_TEA_MARKET_${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6)}",
      spotPrice: SpotPrice(
        usd: spotUsd,
        kes: double.parse((spotUsd * exchangeRate).toStringAsFixed(2)),
        changePercent: double.parse(changePercent.toStringAsFixed(2)),
        volume: 2200000 + _random.nextInt(800000),
      ),
      summary: MarketSummary(
        previousClose: PreviousClose(
          usd: history[history.length - 2].usd,
          kes: history[history.length - 2].kes,
        ),
        todayRange: TodayRange(
          usdLow: double.parse((spotUsd - 0.10).toStringAsFixed(2)),
          usdHigh: double.parse((spotUsd + 0.20).toStringAsFixed(2)),
          kesLow: double.parse(((spotUsd - 0.10) * exchangeRate).toStringAsFixed(0)),
          kesHigh: double.parse(((spotUsd + 0.20) * exchangeRate).toStringAsFixed(0)),
        ),
        week52Range: Week52Range(
          usdLow: double.parse((minPrice - rangeBuffer).toStringAsFixed(2)),
          usdHigh: double.parse((maxPrice + rangeBuffer).toStringAsFixed(2)),
          kesLow: double.parse(((minPrice - rangeBuffer) * exchangeRate).toStringAsFixed(0)),
          kesHigh: double.parse(((maxPrice + rangeBuffer) * exchangeRate).toStringAsFixed(0)),
        ),
      ),
      recentAuctions: history,
      outlook: MarketOutlook(
        daily: changePercent > 0.5 ? "BULLISH" : (changePercent < -0.5 ? "BEARISH" : "NEUTRAL"),
        weekly: _random.nextBool() ? "UPWARD" : "STABLE",
        monthly: "POSITIVE", // Let's be optimistic for tea farmers!
      ),
      nextAuctionDate: _getNextAuctionDate(),
      exchangeRate: exchangeRate,
    );
  }

  String _getNextAuctionDate() {
    DateTime now = DateTime.now();
    // Auctions usually happen weekly. Find the next Tuesday or Thursday.
    int daysUntilTuesday = (DateTime.tuesday - now.weekday + 7) % 7;
    if (daysUntilTuesday == 0) daysUntilTuesday = 7; // If today is Tuesday, next is next week
    DateTime nextAuction = now.add(Duration(days: daysUntilTuesday));
    return "${nextAuction.year}-${nextAuction.month.toString().padLeft(2, '0')}-${nextAuction.day.toString().padLeft(2, '0')}";
  }
}