// lib/screens/Extension_officer Application/officer_application_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/application_model.dart';

class OfficerApplicationPage extends StatefulWidget {
  const OfficerApplicationPage({super.key});

  @override
  State<OfficerApplicationPage> createState() => _OfficerApplicationPageState();
}

class _OfficerApplicationPageState extends State<OfficerApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  File? _idFile;
  File? _letterFile;
  File? _cvFile;

  String? _idFileName;
  String? _letterFileName;
  String? _cvFileName;

  bool _isUploading = false;
  String? _uploadError;

  Future<String?> _uploadFile(File file, String userId, String documentType) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('extension_applications')
          .child(userId)
          .child('$documentType.${file.path.split('.').last}');
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      setState(() => _uploadError = 'Failed to upload $documentType: ${e.toString()}');
      return null;
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    print('Form validated.');

    if (_idFile == null || _letterFile == null || _cvFile == null) {
      setState(() => _uploadError = 'Please upload all required documents.');
      print('Missing files: id=${_idFile != null}, letter=${_letterFile != null}, cv=${_cvFile != null}');
      return;
    }

    setState(() => _isUploading = true);
    _uploadError = null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to apply.')),
      );
      setState(() => _isUploading = false);
      print('User not logged in.');
      return;
    }

    print('User UID: ${user.uid}');

    try {
      print('Uploading ID...');
      final idUrl = await _uploadFile(_idFile!, user.uid, 'id');
      print('ID URL: $idUrl');

      print('Uploading Application Letter...');
      final letterUrl = await _uploadFile(_letterFile!, user.uid, 'application_letter');
      print('Letter URL: $letterUrl');

      print('Uploading CV...');
      final cvUrl = await _uploadFile(_cvFile!, user.uid, 'cv');
      print('CV URL: $cvUrl');

      if (idUrl == null || letterUrl == null || cvUrl == null) {
        print('One or more uploads returned null.');
        setState(() => _isUploading = false);
        return;
      }

      print('Creating Firestore document...');
      final application = ExtensionApplication(
        userId: user.uid,
        applicantName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        idUrl: idUrl,
        letterUrl: letterUrl,
        cvUrl: cvUrl,
        status: 'pending',
        appliedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('applications').add(application.toMap());
      print('Firestore document added.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error during submission: $e');
      setState(() => _uploadError = 'Failed to submit application: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ No premium check – direct access for all logged-in users
    return _buildApplicationForm();
  }

  Widget _buildApplicationForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extension Officer Application'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Personal details
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Upload National ID
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
                  );
                  if (result != null) {
                    setState(() {
                      _idFile = File(result.files.single.path!);
                      _idFileName = result.files.single.name;
                      print('ID file set: ${_idFile?.path}, name: $_idFileName');
                    });
                  } else {
                    print('No file selected for National ID');
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: Text(_idFileName ?? 'Upload National ID'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Upload Application Letter
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
                  );
                  if (result != null) {
                    setState(() {
                      _letterFile = File(result.files.single.path!);
                      _letterFileName = result.files.single.name;
                      print('Letter file set: ${_letterFile?.path}, name: $_letterFileName');
                    });
                  } else {
                    print('No file selected for Application Letter');
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: Text(_letterFileName ?? 'Upload Application Letter'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Upload CV/Resume
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
                  );
                  if (result != null) {
                    setState(() {
                      _cvFile = File(result.files.single.path!);
                      _cvFileName = result.files.single.name;
                      print('CV file set: ${_cvFile?.path}, name: $_cvFileName');
                    });
                  } else {
                    print('No file selected for CV');
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: Text(_cvFileName ?? 'Upload CV/Resume'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              if (_uploadError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_uploadError!, style: const TextStyle(color: Colors.red)),
                ),
              ElevatedButton(
                onPressed: _isUploading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}