class Pest {
  final String id;
  final String name;
  final String scientificName;
  final List<String> imageUrls;
  final String description;
  final String symptoms;
  final List<String> affectedParts;
  final List<Treatment> treatments;
  final List<String> preventionTips;
  final String seasonality;
  final String severity;

  Pest({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.imageUrls,
    required this.description,
    required this.symptoms,
    required this.affectedParts,
    required this.treatments,
    required this.preventionTips,
    required this.seasonality,
    required this.severity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'imageUrls': imageUrls,
      'description': description,
      'symptoms': symptoms,
      'affectedParts': affectedParts,
      'treatments': treatments.map((t) => t.toMap()).toList(),
      'preventionTips': preventionTips,
      'seasonality': seasonality,
      'severity': severity,
    };
  }

  factory Pest.fromMap(Map<String, dynamic> map) {
    return Pest(
      id: map['id'],
      name: map['name'],
      scientificName: map['scientificName'],
      imageUrls: List<String>.from(map['imageUrls']),
      description: map['description'],
      symptoms: map['symptoms'],
      affectedParts: List<String>.from(map['affectedParts']),
      treatments: (map['treatments'] as List)
          .map((t) => Treatment.fromMap(t))
          .toList(),
      preventionTips: List<String>.from(map['preventionTips']),
      seasonality: map['seasonality'],
      severity: map['severity'],
    );
  }
}

class Treatment {
  final String type; // chemical, organic, cultural
  final String productName;
  final String activeIngredient;
  final String applicationRate;
  final String waitingPeriod;
  final String safetyPrecautions;
  final String effectiveness;

  Treatment({
    required this.type,
    required this.productName,
    required this.activeIngredient,
    required this.applicationRate,
    required this.waitingPeriod,
    required this.safetyPrecautions,
    required this.effectiveness,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'productName': productName,
      'activeIngredient': activeIngredient,
      'applicationRate': applicationRate,
      'waitingPeriod': waitingPeriod,
      'safetyPrecautions': safetyPrecautions,
      'effectiveness': effectiveness,
    };
  }

  factory Treatment.fromMap(Map<String, dynamic> map) {
    return Treatment(
      type: map['type'],
      productName: map['productName'],
      activeIngredient: map['activeIngredient'],
      applicationRate: map['applicationRate'],
      waitingPeriod: map['waitingPeriod'],
      safetyPrecautions: map['safetyPrecautions'],
      effectiveness: map['effectiveness'],
    );
  }
}