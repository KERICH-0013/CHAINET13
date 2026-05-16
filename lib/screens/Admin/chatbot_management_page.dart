import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotManagementPage extends StatefulWidget {
  @override
  _ChatbotManagementPageState createState() => _ChatbotManagementPageState();
}

class _ChatbotManagementPageState extends State<ChatbotManagementPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  Future<void> _addFaq() async {
    await FirebaseFirestore.instance.collection('chatbot_faqs').add({
      'question': _questionController.text.trim(),
      'answer': _answerController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _questionController.clear();
    _answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot FAQs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _questionController, decoration: const InputDecoration(labelText: 'Question'))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _answerController, decoration: const InputDecoration(labelText: 'Answer'))),
                IconButton(onPressed: _addFaq, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chatbot_faqs').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['question']),
                      subtitle: Text(data['answer']),
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