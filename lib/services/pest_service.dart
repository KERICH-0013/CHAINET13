import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pest_model.dart';

class PestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'pests';

  // Call this once to populate your Firestore database with initial pests
  Future<void> initializePestDatabase() async {
    final pests = _getInitialPestData();
    for (var pest in pests) {
      await _firestore.collection(collectionName).doc(pest.id).set(pest.toMap());
    }
    print('Pest database initialized with ${pests.length} entries');
  }

  // Get all pests
  Future<List<Pest>> getAllPests() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs
          .map((doc) => Pest.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching pests: $e');
      return [];
    }
  }

  // Get a single pest by ID
  Future<Pest?> getPestById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        return Pest.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching pest: $e');
      return null;
    }
  }

  // Search pests by name or symptoms
  Future<List<Pest>> searchPests(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      List<Pest> allPests = snapshot.docs
          .map((doc) => Pest.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return allPests.where((pest) =>
      pest.name.toLowerCase().contains(query.toLowerCase()) ||
          pest.symptoms.toLowerCase().contains(query.toLowerCase()) ||
          pest.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error searching pests: $e');
      return [];
    }
  }

  // Initial data (you can expand this list)
  List<Pest> _getInitialPestData() {
    return [
      Pest(
        id: 'tea_mosquito_bug',
        name: 'Tea Mosquito Bug (Helopeltis)',
        scientificName: 'Helopeltis theivora',
        imageUrls: ['assets/images/pests/mosquito_bug.jpg'],
        description: 'A major pest of tea that sucks sap from young leaves, tender stems, and buds.',
        symptoms: 'Small water-soaked spots on leaves that turn brown and black; leaves become curled.',
        affectedParts: ['young leaves', 'tender stems', 'buds'],
        treatments: [
          Treatment(
            type: 'chemical',
            productName: 'Quinalphos 25% EC',
            activeIngredient: 'Quinalphos',
            applicationRate: '2 ml per liter of water',
            waitingPeriod: '7 days',
            safetyPrecautions: 'Wear protective gloves and mask.',
            effectiveness: 'high',
          ),
        ],
        preventionTips: [
          'Maintain proper shade',
          'Remove alternate host plants',
          'Use light traps',
        ],
        seasonality: 'peak during warm, humid weather (March-October)',
        severity: 'high',
      ),
      // Add more pests as needed...
    ];
  }
}