import 'package:cloud_firestore/cloud_firestore.dart';

class ExtensionApplication {
  final String? id;
  final String userId;
  final String applicantName;
  final String email;
  final String phoneNumber;
  final String idUrl;
  final String letterUrl;
  final String cvUrl;
  final String status;
  final DateTime appliedAt;
  final String? adminFeedback;

  ExtensionApplication({
    this.id,
    required this.userId,
    required this.applicantName,
    required this.email,
    required this.phoneNumber,
    required this.idUrl,
    required this.letterUrl,
    required this.cvUrl,
    required this.status,
    required this.appliedAt,
    this.adminFeedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'applicantName': applicantName,
      'email': email,
      'phoneNumber': phoneNumber,
      'idUrl': idUrl,
      'letterUrl': letterUrl,
      'cvUrl': cvUrl,
      'status': status,
      'appliedAt': appliedAt,
      'adminFeedback': adminFeedback,
    };
  }

  factory ExtensionApplication.fromMap(String id, Map<String, dynamic> map) {
    return ExtensionApplication(
      id: id,
      userId: map['userId'],
      applicantName: map['applicantName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      idUrl: map['idUrl'],
      letterUrl: map['letterUrl'],
      cvUrl: map['cvUrl'],
      status: map['status'],
      appliedAt: (map['appliedAt'] as Timestamp).toDate(),
      adminFeedback: map['adminFeedback'],
    );
  }
}