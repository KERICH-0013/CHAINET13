import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriceManagementPage extends StatefulWidget {
  @override
  _PriceManagementPageState createState() => _PriceManagementPageState();
}

class _PriceManagementPageState extends State<PriceManagementPage> {
  final _marketController = TextEditingController();
  final _priceController = TextEditingController();
  final _changeController = TextEditingController();

  Future<void> _addPrice() async {
    await FirebaseFirestore.instance.collection('market_prices').add({
      'market': _marketController.text.trim(),
      'price': double.parse(_priceController.text),
      'change': double.parse(_changeController.text),
      'unit': 'KSh/kg',
      'date': DateTime.now().toIso8601String(),
    });
    _marketController.clear();
    _priceController.clear();
    _changeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Market Prices')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _marketController, decoration: const InputDecoration(labelText: 'Market'))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _changeController, decoration: const InputDecoration(labelText: 'Change (%)'), keyboardType: TextInputType.number)),
                IconButton(onPressed: _addPrice, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('market_prices').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['market']),
                      subtitle: Text('${data['price']} ${data['unit']} | Change: ${data['change']}%'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => doc.reference.delete(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}