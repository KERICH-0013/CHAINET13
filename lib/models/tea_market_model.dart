class TeaMarketOverview {
  final String marketName;
  final String lastUpdated;
  final String apiKey;
  final SpotPrice spotPrice;
  final MarketSummary summary;
  final List<HistoricalPrice> recentAuctions;
  final MarketOutlook outlook;
  final String nextAuctionDate;
  final double exchangeRate;

  TeaMarketOverview({
    required this.marketName,
    required this.lastUpdated,
    required this.apiKey,
    required this.spotPrice,
    required this.summary,
    required this.recentAuctions,
    required this.outlook,
    required this.nextAuctionDate,
    required this.exchangeRate,
  });
}

class SpotPrice {
  final double usd;
  final double kes;
  final double changePercent;
  final int volume; // Trading volume in kg

  SpotPrice({required this.usd, required this.kes, required this.changePercent, required this.volume});
}

class MarketSummary {
  final PreviousClose previousClose;
  final TodayRange todayRange;
  final Week52Range week52Range;

  MarketSummary({required this.previousClose, required this.todayRange, required this.week52Range});
}

class PreviousClose {
  final double usd;
  final double kes;
  PreviousClose({required this.usd, required this.kes});
}

class TodayRange {
  final double usdLow;
  final double usdHigh;
  final double kesLow;
  final double kesHigh;
  TodayRange({required this.usdLow, required this.usdHigh, required this.kesLow, required this.kesHigh});
}

class Week52Range {
  final double usdLow;
  final double usdHigh;
  final double kesLow;
  final double kesHigh;
  Week52Range({required this.usdLow, required this.usdHigh, required this.kesLow, required this.kesHigh});
}

class HistoricalPrice {
  final String date; // e.g., "8/4"
  final double usd;
  final double kes;
  final double changePercent;
  final int volume;

  HistoricalPrice({required this.date, required this.usd, required this.kes, required this.changePercent, required this.volume});
}

class MarketOutlook {
  final String daily; // BEARISH / BULLISH
  final String weekly;
  final String monthly;

  MarketOutlook({required this.daily, required this.weekly, required this.monthly});
}