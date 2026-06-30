import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../screens/tea_market_screen.dart';   // Correct import

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  final double _latitude = -1.2921;
  final double _longitude = 36.8219;

  Map<String, dynamic>? _currentWeather;
  List<Map<String, dynamic>>? _forecast;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final current = await _weatherService.getCurrentWeather(
        latitude: _latitude,
        longitude: _longitude,
      );
      final forecast = await _weatherService.getForecast(
        latitude: _latitude,
        longitude: _longitude,
      );

      setState(() {
        _currentWeather = current;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/weather.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi‑transparent overlay
          Container(color: Colors.black.withOpacity(0.4)),
          // Main content
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
            onRefresh: _loadWeatherData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nairobi Region',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tea Farming Area',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCurrentWeatherCard(),
                  const SizedBox(height: 8),
                  _buildDataSourceIndicator(), // Added data source indicator
                  const SizedBox(height: 16),
                  const Text(
                    '7-Day Forecast',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...?_forecast?.map((day) => _buildForecastItem(day)).toList(),

                  // Fixed: Use TeaMarketScreen instead of MarketPage
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TeaMarketScreen()),
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
                        'Check Market Prices',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    if (_currentWeather == null) return const SizedBox();

    final weatherCode = _currentWeather!['weather_code'] as int;
    final weatherInfo = WeatherService.getWeatherInfo(weatherCode);
    final temperature = _currentWeather!['temperature'];
    final tempUnit = _currentWeather!['temperature_unit'];
    final humidity = _currentWeather!['humidity'];
    final windSpeed = _currentWeather!['wind_speed'];
    final windUnit = _currentWeather!['wind_unit'];
    final pressure = _currentWeather!['pressure'];

    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weatherInfo['icon'],
                  style: const TextStyle(fontSize: 64),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              weatherInfo['description'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$temperature$tempUnit',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  icon: Icons.water_drop,
                  value: humidity != null ? '$humidity%' : 'N/A',
                  label: 'Humidity',
                ),
                _buildWeatherDetail(
                  icon: Icons.air,
                  value: '$windSpeed $windUnit',
                  label: 'Wind',
                ),
                _buildWeatherDetail(
                  icon: Icons.compress,
                  value: pressure != null ? '${pressure} hPa' : 'N/A',
                  label: 'Pressure',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(Map<String, dynamic> day) {
    final date = DateTime.parse(day['date']);
    final weatherInfo = WeatherService.getWeatherInfo(day['weather_code']);
    final tempMax = day['temp_max'];
    final tempMin = day['temp_min'];
    final tempUnit = day['temp_unit'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white.withOpacity(0.9),
      child: ListTile(
        leading: Text(
          weatherInfo['icon'],
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(
          _formatDate(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(weatherInfo['description']),
        trailing: Text(
          '$tempMax$tempUnit / $tempMin$tempUnit',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Add this method to show when using cached/mock data
  Widget _buildDataSourceIndicator() {
    if (_currentWeather == null) return const SizedBox();

    final isRealData = _currentWeather!['is_real_data'] ?? false;

    if (!isRealData) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.cloud_off, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Using cached weather data (offline mode)',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Failed to load weather',
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
              onPressed: _loadWeatherData,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
    }
  }
}