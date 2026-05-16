import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherSettingsPage extends StatefulWidget {
  @override
  _WeatherSettingsPageState createState() => _WeatherSettingsPageState();
}

class _WeatherSettingsPageState extends State<WeatherSettingsPage> {
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _refreshController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final doc = await FirebaseFirestore.instance.collection('weather_config').doc('settings').get();
    if (doc.exists) {
      final data = doc.data()!;
      _latController.text = data['latitude'].toString();
      _lonController.text = data['longitude'].toString();
      _refreshController.text = data['refreshMinutes'].toString();
    }
  }

  Future<void> _saveSettings() async {
    await FirebaseFirestore.instance.collection('weather_config').doc('settings').set({
      'latitude': double.parse(_latController.text),
      'longitude': double.parse(_lonController.text),
      'refreshMinutes': int.parse(_refreshController.text),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _latController, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _lonController, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _refreshController, decoration: const InputDecoration(labelText: 'Refresh interval (minutes)'), keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _saveSettings, child: const Text('Save Settings')),
          ],
        ),
      ),
    );
  }
}