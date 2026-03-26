import 'package:flutter/material.dart';
import '../services/pest_service.dart';
import '../models/pest_model.dart';
import 'pest_detail_page.dart';

class PestListPage extends StatefulWidget {
  const PestListPage({super.key});

  @override
  State<PestListPage> createState() => _PestListPageState();
}

class _PestListPageState extends State<PestListPage> {
  final PestService _pestService = PestService();
  List<Pest> _pests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPests();
  }

  Future<void> _loadPests() async {
    setState(() => _isLoading = true);
    final pests = await _pestService.getAllPests();
    setState(() {
      _pests = pests;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Library'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pests.length,
        itemBuilder: (context, index) {
          final pest = _pests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Image.asset(
                pest.imageUrls.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.bug_report),
              ),
              title: Text(pest.name),
              subtitle: Text(pest.scientificName),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green.shade800),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PestDetailPage(pest: pest),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}