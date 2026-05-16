import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuideManagementPage extends StatefulWidget {
  @override
  _GuideManagementPageState createState() => _GuideManagementPageState();
}

class _GuideManagementPageState extends State<GuideManagementPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _editingId;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    _editingId = null;
  }

  Future<void> _saveGuide() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': FirebaseAuth.instance.currentUser!.uid,
    };
    if (_editingId == null) {
      // Add new guide
      data['createdAt'] = FieldValue.serverTimestamp();
      await FirebaseFirestore.instance.collection('farming_guides').add(data);
    } else {
      // Update existing guide
      await FirebaseFirestore.instance.collection('farming_guides').doc(_editingId).update(data);
    }
    _resetForm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_editingId == null ? 'Guide added' : 'Guide updated')),
    );
  }

  void _editGuide(String id, String title, String content) {
    _editingId = id;
    _titleController.text = title;
    _contentController.text = content;
    _showFormDialog();
  }

  void _showFormDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingId == null ? 'Add Guide' : 'Edit Guide'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            _saveGuide();
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _deleteGuide(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Guide'),
        content: const Text('Are you sure you want to delete this guide?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance.collection('farming_guides').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Farming Guides')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetForm();
          _showFormDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('farming_guides')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No farming guides yet. Tap + to add.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['content']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editGuide(doc.id, data['title'], data['content']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteGuide(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}