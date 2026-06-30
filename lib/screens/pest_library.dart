import 'package:flutter/material.dart';

class Pest {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String type; // 'insect', 'mite', 'fungal', 'viral', 'bacterial', 'healthy'
  final String icon;
  final String severity; // 'Low', 'Medium', 'High', 'Critical', 'None'
  final int confidence;
  final String description;
  final List<String> symptoms;
  final List<String> affectedParts; // 'leaves', 'stems', 'roots', 'shoots', 'flowers'
  final List<Remedy> remedies;
  final String prevention;
  final String seasonalActivity;
  final List<String> favorableConditions;
  final List<String> similarPests;
  final String imageUrl;
  final bool isOrganic;

  Pest({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.type,
    required this.icon,
    required this.severity,
    this.confidence = 0,
    required this.description,
    required this.symptoms,
    required this.affectedParts,
    required this.remedies,
    required this.prevention,
    required this.seasonalActivity,
    required this.favorableConditions,
    required this.similarPests,
    required this.imageUrl,
    this.isOrganic = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'category': category,
      'type': type,
      'icon': icon,
      'severity': severity,
      'confidence': confidence,
      'description': description,
      'symptoms': symptoms,
      'affectedParts': affectedParts,
      'remedies': remedies.map((r) => r.toJson()).toList(),
      'prevention': prevention,
      'seasonalActivity': seasonalActivity,
      'favorableConditions': favorableConditions,
      'similarPests': similarPests,
      'imageUrl': imageUrl,
      'isOrganic': isOrganic,
    };
  }

  factory Pest.fromJson(Map<String, dynamic> json) {
    return Pest(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      category: json['category'],
      type: json['type'],
      icon: json['icon'],
      severity: json['severity'],
      confidence: json['confidence'] ?? 0,
      description: json['description'],
      symptoms: List<String>.from(json['symptoms']),
      affectedParts: List<String>.from(json['affectedParts']),
      remedies: (json['remedies'] as List)
          .map((r) => Remedy.fromJson(r))
          .toList(),
      prevention: json['prevention'],
      seasonalActivity: json['seasonalActivity'],
      favorableConditions: List<String>.from(json['favorableConditions']),
      similarPests: List<String>.from(json['similarPests']),
      imageUrl: json['imageUrl'],
      isOrganic: json['isOrganic'] ?? false,
    );
  }

  // Get severity color
  Color getSeverityColor() {
    switch (severity) {
      case 'Low':
        return Colors.yellow;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Critical':
        return Colors.deepOrange;
      case 'None':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get severity icon
  IconData getSeverityIcon() {
    switch (severity) {
      case 'Low':
        return Icons.warning_amber;
      case 'Medium':
        return Icons.warning;
      case 'High':
        return Icons.error;
      case 'Critical':
        return Icons.crisis_alert;
      case 'None':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  // Get type color
  Color getTypeColor() {
    switch (type) {
      case 'insect':
        return Colors.brown;
      case 'mite':
        return Colors.red.shade300;
      case 'fungal':
        return Colors.purple;
      case 'viral':
        return Colors.pink;
      case 'bacterial':
        return Colors.blue;
      case 'healthy':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get type icon
  IconData getTypeIcon() {
    switch (type) {
      case 'insect':
        return Icons.bug_report;
      case 'mite':
        return Icons.grain;
      case 'fungal':
        return Icons.grass;
      case 'viral':
        return Icons.health_and_safety;
      case 'bacterial':
        return Icons.science;
      case 'healthy':
        return Icons.eco;
      default:
        return Icons.help;
    }
  }
}

class Remedy {
  final String id;
  final String title;
  final String type; // 'organic', 'chemical', 'preventive', 'biological', 'cultural'
  final List<String> steps;
  final String? applicationMethod;
  final String? frequency;
  final String? duration;
  final List<String>? precautions;
  final int? effectiveness; // 0-100
  final bool isRecommended;
  final List<String>? alternativeProducts;

  Remedy({
    required this.id,
    required this.title,
    required this.type,
    required this.steps,
    this.applicationMethod,
    this.frequency,
    this.duration,
    this.precautions,
    this.effectiveness,
    this.isRecommended = false,
    this.alternativeProducts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'steps': steps,
      'applicationMethod': applicationMethod,
      'frequency': frequency,
      'duration': duration,
      'precautions': precautions,
      'effectiveness': effectiveness,
      'isRecommended': isRecommended,
      'alternativeProducts': alternativeProducts,
    };
  }

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      steps: List<String>.from(json['steps']),
      applicationMethod: json['applicationMethod'],
      frequency: json['frequency'],
      duration: json['duration'],
      precautions: json['precautions'] != null
          ? List<String>.from(json['precautions'])
          : null,
      effectiveness: json['effectiveness'],
      isRecommended: json['isRecommended'] ?? false,
      alternativeProducts: json['alternativeProducts'] != null
          ? List<String>.from(json['alternativeProducts'])
          : null,
    );
  }

  // Get type color
  Color getTypeColor() {
    switch (type) {
      case 'organic':
        return Colors.green;
      case 'chemical':
        return Colors.red;
      case 'preventive':
        return Colors.blue;
      case 'biological':
        return Colors.purple;
      case 'cultural':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get type icon
  IconData getTypeIcon() {
    switch (type) {
      case 'organic':
        return Icons.eco;
      case 'chemical':
        return Icons.science;
      case 'preventive':
        return Icons.shield;
      case 'biological':
        return Icons.grass;
      case 'cultural':
        return Icons.agriculture;
      default:
        return Icons.help;
    }
  }
}

// Pest Library Data Class
class PestLibrary {
  static final List<Pest> _pests = [
    // TEA APHID
    Pest(
      id: 'pest_001',
      name: 'Tea Aphid',
      scientificName: 'Toxoptera aurantii',
      category: 'Sucking Pests',
      type: 'insect',
      icon: '🐛',
      severity: 'Medium',
      description: 'Small, soft-bodied insects that colonize young shoots and leaves, causing curling, yellowing, and stunted growth. They secrete honeydew which promotes sooty mold growth.',
      symptoms: [
        'Leaves curl downward and inward',
        'Yellowing and chlorosis of leaves',
        'Sticky honeydew secretion on leaves',
        'Black sooty mold growth on honeydew',
        'Stunted shoot growth',
        'Reduced plant vigor',
        'Presence of ants (attracted to honeydew)'
      ],
      affectedParts: ['leaves', 'shoots'],
      remedies: [
        Remedy(
          id: 'rem_001_a',
          title: 'Neem Oil Spray',
          type: 'organic',
          steps: [
            'Mix 5ml neem oil with 1L water',
            'Add 2-3 drops of mild liquid soap',
            'Spray thoroughly on affected leaves (both sides)',
            'Apply every 7-10 days',
            'Continue for 3-4 weeks'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 7-10 days',
          duration: '3-4 weeks',
          precautions: [
            'Avoid spraying in direct sunlight',
            'Test on a small area first',
            'Wear protective gloves'
          ],
          effectiveness: 85,
          isRecommended: true,
          alternativeProducts: ['Garlic-chili spray', 'Insecticidal soap'],
        ),
        Remedy(
          id: 'rem_001_b',
          title: 'Imidacloprid Application',
          type: 'chemical',
          steps: [
            'Use Imidacloprid 17.8% SL (0.5ml/L water)',
            'Spray thoroughly on infested areas',
            'Apply early morning or late afternoon',
            'Wait 7-10 days before harvest'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'As needed',
          duration: '2-3 applications',
          precautions: [
            'Follow safety guidelines',
            'Use protective equipment',
            'Keep away from water sources'
          ],
          effectiveness: 92,
          isRecommended: false,
          alternativeProducts: ['Thiamethoxam', 'Acetamiprid'],
        ),
        Remedy(
          id: 'rem_001_c',
          title: 'Biological Control',
          type: 'biological',
          steps: [
            'Introduce ladybugs (Coccinellidae)',
            'Release lacewing larvae',
            'Encourage natural predators',
            'Maintain diverse plant species',
            'Avoid broad-spectrum pesticides'
          ],
          applicationMethod: 'Biological release',
          frequency: 'As needed',
          duration: 'Ongoing',
          precautions: [
            'Ensure predators are compatible',
            'Release in the evening',
            'Provide water sources'
          ],
          effectiveness: 75,
          isRecommended: true,
        ),
      ],
      prevention: 'Regular field monitoring, maintain proper plant spacing, remove weed hosts, use resistant tea varieties, maintain balanced nutrition, and encourage natural predators.',
      seasonalActivity: 'Active year-round, peak during warm, dry seasons',
      favorableConditions: [
        'Warm temperatures (20-28°C)',
        'Low humidity',
        'Excessive nitrogen fertilization',
        'Dense plant canopy'
      ],
      similarPests: ['Green aphid', 'Black aphid', 'Mealybug'],
      imageUrl: 'assets/pests/tea_aphid.jpg',
      isOrganic: true,
    ),

    // RED SPIDER MITE
    Pest(
      id: 'pest_002',
      name: 'Red Spider Mite',
      scientificName: 'Oligonychus coffeae',
      category: 'Mites',
      type: 'mite',
      icon: '🕷️',
      severity: 'High',
      description: 'Tiny, reddish mites that feed on leaf sap, causing characteristic bronzing, webbing, and severe leaf drop under heavy infestations. They thrive in hot, dry conditions.',
      symptoms: [
        'Bronze or reddish-brown discoloration',
        'Fine silken webbing on leaves',
        'Leaf drop in severe cases',
        'Stunted shoot growth',
        'Reduced photosynthesis',
        'Mottled appearance of leaves',
        'Presence of tiny moving dots on leaves'
      ],
      affectedParts: ['leaves', 'stems'],
      remedies: [
        Remedy(
          id: 'rem_002_a',
          title: 'Sulfur-Based Spray',
          type: 'organic',
          steps: [
            'Mix 2g wettable sulfur per 1L water',
            'Spray thoroughly on both leaf surfaces',
            'Apply early morning or late evening',
            'Repeat every 10-14 days',
            'Stop before harvest'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 10-14 days',
          duration: '3-4 weeks',
          precautions: [
            'Do not mix with oil-based sprays',
            'Avoid high temperatures (>30°C)',
            'Wear protective mask'
          ],
          effectiveness: 80,
          isRecommended: true,
          alternativeProducts: ['Neem oil', 'Garlic extract'],
        ),
        Remedy(
          id: 'rem_002_b',
          title: 'Fenazaquin 10% EC',
          type: 'chemical',
          steps: [
            'Use 1.5ml Fenazaquin 10% EC per 1L water',
            'Spray uniformly on infested plants',
            'Apply in the evening',
            'Rotate with other miticides',
            'Observe 7-day waiting period'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'As needed',
          duration: '1-2 applications',
          precautions: [
            'Rotate with different mode of action',
            'Use protective equipment',
            'Do not exceed recommended dose'
          ],
          effectiveness: 90,
          isRecommended: false,
          alternativeProducts: ['Propargite', 'Abamectin'],
        ),
        Remedy(
          id: 'rem_002_c',
          title: 'Humidity Management',
          type: 'cultural',
          steps: [
            'Maintain high humidity levels',
            'Regular irrigation schedule',
            'Avoid water stress',
            'Mulch to retain soil moisture',
            'Increase canopy shade'
          ],
          applicationMethod: 'Cultural practice',
          frequency: 'Ongoing',
          duration: 'Permanent',
          precautions: [
            'Avoid waterlogging',
            'Monitor moisture levels'
          ],
          effectiveness: 70,
          isRecommended: true,
        ),
      ],
      prevention: 'Maintain proper irrigation and humidity levels, avoid water stress, regular monitoring, remove infected leaves, use predatory mites for biological control, and maintain plant health.',
      seasonalActivity: 'Peak during hot, dry seasons (December-March)',
      favorableConditions: [
        'High temperatures (25-32°C)',
        'Low humidity (<60%)',
        'Water stress',
        'Dense foliage'
      ],
      similarPests: ['Two-spotted spider mite', 'Yellow mite'],
      imageUrl: 'assets/pests/red_spider_mite.jpg',
      isOrganic: true,
    ),

    // TEA MOSQUITO BUG
    Pest(
      id: 'pest_003',
      name: 'Tea Mosquito Bug',
      scientificName: 'Helopeltis theivora',
      category: 'Sucking Pests',
      type: 'insect',
      icon: '🦟',
      severity: 'High',
      description: 'A serious sucking pest that causes characteristic circular necrotic lesions on leaves and stems. It injects toxic saliva during feeding, leading to tissue death and reduced plant growth.',
      symptoms: [
        'Circular brown spots with pale center',
        'Necrotic lesions on young stems',
        'Dieback of young shoots',
        'Reduced leaf quality and yield',
        'Honeydew secretion',
        'Stunted growth of new shoots',
        'Characteristic "shot-hole" appearance'
      ],
      affectedParts: ['leaves', 'stems', 'shoots'],
      remedies: [
        Remedy(
          id: 'rem_003_a',
          title: 'Neem Seed Kernel Extract (NSKE)',
          type: 'organic',
          steps: [
            'Prepare 5% NSKE solution',
            'Soak 50g neem seeds in 1L water overnight',
            'Filter and add 2-3 drops of soap',
            'Spray in the evening',
            'Apply every 15 days'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 15 days',
          duration: '3-4 months',
          precautions: [
            'Use fresh neem seeds',
            'Test on small area first',
            'Avoid spraying in rain'
          ],
          effectiveness: 78,
          isRecommended: true,
          alternativeProducts: ['Neem oil', 'Pongamia oil'],
        ),
        Remedy(
          id: 'rem_003_b',
          title: 'Acephate 75% SP',
          type: 'chemical',
          steps: [
            'Dissolve 1.5g Acephate 75% SP in 1L water',
            'Spray thoroughly on infested areas',
            'Apply early morning or late evening',
            'Repeat after 10-14 days if needed',
            'Follow waiting period of 14 days'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'As needed',
          duration: '2-3 applications',
          precautions: [
            'Use protective equipment',
            'Keep away from children and pets',
            'Dispose of unused solution properly'
          ],
          effectiveness: 88,
          isRecommended: false,
          alternativeProducts: ['Fipronil', 'Thiamethoxam'],
        ),
        Remedy(
          id: 'rem_003_c',
          title: 'Pheromone Traps',
          type: 'biological',
          steps: [
            'Install pheromone traps at 10m intervals',
            'Replace lures every 4-6 weeks',
            'Monitor trap catches weekly',
            'Use for mass trapping or monitoring',
            'Combine with other control methods'
          ],
          applicationMethod: 'Trap installation',
          frequency: 'Continuous',
          duration: 'Ongoing',
          precautions: [
            'Place traps at canopy level',
            'Check regularly',
            'Clean traps as needed'
          ],
          effectiveness: 75,
          isRecommended: true,
        ),
      ],
      prevention: 'Proper shade management, balanced nutrition, regular pruning of infected shoots, use of pheromone traps for monitoring, and field sanitation.',
      seasonalActivity: 'Active throughout the year, peak during monsoon season',
      favorableConditions: [
        'Warm and humid conditions',
        'Dense shade',
        'Excessive nitrogen',
        'Poor pruning practices'
      ],
      similarPests: ['Green bug', 'Tea leafhopper'],
      imageUrl: 'assets/pests/tea_mosquito_bug.jpg',
      isOrganic: true,
    ),

    // TEA JASSID
    Pest(
      id: 'pest_004',
      name: 'Tea Jassid',
      scientificName: 'Empoasca flavescens',
      category: 'Sucking Pests',
      type: 'insect',
      icon: '🦗',
      severity: 'Medium',
      description: 'Small leafhoppers that feed on leaf sap, causing characteristic scorching and yellowing of leaves. They are active during warm weather and can cause significant yield loss.',
      symptoms: [
        'Scorching at leaf margins',
        'Yellowing and browning of leaves',
        'Stunted shoot growth',
        'Reduced plant vigor',
        'Honeydew secretion',
        'Leaf curling',
        'Presence of jumping insects when disturbed'
      ],
      affectedParts: ['leaves', 'shoots'],
      remedies: [
        Remedy(
          id: 'rem_004_a',
          title: 'Yellow Sticky Traps',
          type: 'biological',
          steps: [
            'Place yellow sticky traps at canopy level',
            'Install 20-25 traps per hectare',
            'Replace traps when full',
            'Monitor insect populations weekly',
            'Combine with other control methods'
          ],
          applicationMethod: 'Trap installation',
          frequency: 'Continuous',
          duration: 'Ongoing',
          precautions: [
            'Position traps just above canopy',
            'Check and replace regularly',
            'Avoid placing near flowers'
          ],
          effectiveness: 70,
          isRecommended: true,
        ),
        Remedy(
          id: 'rem_004_b',
          title: 'Neem Oil Application',
          type: 'organic',
          steps: [
            'Mix 5ml neem oil in 1L water',
            'Add few drops of soap as emulsifier',
            'Spray early morning or late evening',
            'Apply every 7-10 days',
            'Repeat as needed'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 7-10 days',
          duration: '3-4 weeks',
          precautions: [
            'Avoid spraying in hot conditions',
            'Test on small area first',
            'Wear protective clothing'
          ],
          effectiveness: 82,
          isRecommended: true,
          alternativeProducts: ['Insecticidal soap', 'Garlic spray'],
        ),
        Remedy(
          id: 'rem_004_c',
          title: 'Cypermethrin 10% EC',
          type: 'chemical',
          steps: [
            'Use 1ml Cypermethrin 10% EC per 1L water',
            'Spray in the evening',
            'Apply when pest population reaches threshold',
            'Observe waiting period of 5-7 days',
            'Rotate with other insecticides'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'As needed',
          duration: '1-2 applications',
          precautions: [
            'Use protective equipment',
            'Avoid spray drift',
            'Follow safety guidelines'
          ],
          effectiveness: 85,
          isRecommended: false,
          alternativeProducts: ['Dimethoate', 'Lambda-cyhalothrin'],
        ),
      ],
      prevention: 'Regular field monitoring, proper nutrition management, maintaining plant health, use of yellow sticky traps, and encouraging natural enemies.',
      seasonalActivity: 'Active from April to December, peak during warm months',
      favorableConditions: [
        'Warm temperatures',
        'High humidity',
        'New growth flush',
        'Excessive nitrogen'
      ],
      similarPests: ['Green leafhopper', 'Thrips'],
      imageUrl: 'assets/pests/tea_jassid.jpg',
      isOrganic: true,
    ),

    // TEA BLIGHT
    Pest(
      id: 'pest_005',
      name: 'Tea Blight',
      scientificName: 'Colletotrichum gloeosporioides',
      category: 'Fungal Diseases',
      type: 'fungal',
      icon: '🍂',
      severity: 'High',
      description: 'A serious fungal disease that affects leaves, stems, and young shoots. It causes brown spots, blighting, and can lead to severe defoliation during wet conditions.',
      symptoms: [
        'Dark brown to black circular spots',
        'Leaf tips and margins turn brown',
        'Premature leaf drop',
        'Dieback of young shoots',
        'Reduced photosynthesis',
        'Spots may coalesce forming large lesions',
        'Fungal growth visible in wet conditions'
      ],
      affectedParts: ['leaves', 'stems', 'shoots'],
      remedies: [
        Remedy(
          id: 'rem_005_a',
          title: 'Copper-Based Fungicide',
          type: 'organic',
          steps: [
            'Use copper oxychloride 50% WP (2g/L water)',
            'Spray thoroughly on all plant parts',
            'Apply before rainy season',
            'Repeat every 10-14 days',
            'Continue until disease is controlled'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 10-14 days',
          duration: '4-6 weeks',
          precautions: [
            'Avoid spraying in hot conditions',
            'Do not mix with other chemicals',
            'Wear protective gear'
          ],
          effectiveness: 84,
          isRecommended: true,
          alternativeProducts: ['Bordeaux mixture', 'Sulfur'],
        ),
        Remedy(
          id: 'rem_005_b',
          title: 'Carbendazim 50% WP',
          type: 'chemical',
          steps: [
            'Dissolve 1g Carbendazim 50% WP in 1L water',
            'Spray at first sign of disease',
            'Apply in the morning',
            'Repeat every 10 days',
            'Follow waiting period of 7-10 days'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 10 days',
          duration: '3-4 applications',
          precautions: [
            'Rotate with different fungicides',
            'Use protective equipment',
            'Dispose of unused solution safely'
          ],
          effectiveness: 90,
          isRecommended: false,
          alternativeProducts: ['Propiconazole', 'Tebuconazole'],
        ),
        Remedy(
          id: 'rem_005_c',
          title: 'Cultural Management',
          type: 'cultural',
          steps: [
            'Avoid overhead irrigation',
            'Ensure proper drainage',
            'Maintain plant spacing',
            'Remove infected plant debris',
            'Prune affected branches',
            'Improve air circulation'
          ],
          applicationMethod: 'Cultural practice',
          frequency: 'Ongoing',
          duration: 'Permanent',
          precautions: [
            'Dispose of infected material properly',
            'Sterilize pruning tools',
            'Monitor regularly'
          ],
          effectiveness: 75,
          isRecommended: true,
        ),
      ],
      prevention: 'Proper drainage, avoid overhead irrigation, maintain plant spacing, remove and destroy infected plant parts, regular fungicide spray schedule, and use of disease-resistant varieties.',
      seasonalActivity: 'Active during rainy season (June-September), spreads rapidly in wet conditions',
      favorableConditions: [
        'High humidity (>85%)',
        'Wet weather conditions',
        'Poor air circulation',
        'Dense plant canopy',
        'Nutrient deficiency'
      ],
      similarPests: ['Grey blight', 'Leaf spot', 'Anthracnose'],
      imageUrl: 'assets/pests/tea_blight.jpg',
      isOrganic: true,
    ),

    // RED RUST (ALGAL ATTACK)
    Pest(
      id: 'pest_006',
      name: 'Red Rust',
      scientificName: 'Cephaleuros virescens',
      category: 'Fungal Diseases',
      type: 'fungal',
      icon: '🟠',
      severity: 'Medium',
      description: 'An algal disease that forms characteristic reddish-orange spots on leaves and stems. It affects older leaves and can reduce photosynthesis and plant vigor.',
      symptoms: [
        'Reddish-orange circular spots',
        'Rust-colored patches on leaves',
        'Velvety appearance on upper leaf surface',
        'Leaf yellowing around spots',
        'Premature leaf drop',
        'Reduced photosynthesis',
        'Spots may coalesce on heavily infected leaves'
      ],
      affectedParts: ['leaves', 'stems'],
      remedies: [
        Remedy(
          id: 'rem_006_a',
          title: 'Copper Oxychloride Spray',
          type: 'organic',
          steps: [
            'Mix 2g copper oxychloride per 1L water',
            'Add a wetting agent',
            'Spray on affected areas',
            'Apply during dry weather',
            'Repeat every 14 days'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 14 days',
          duration: '4-6 weeks',
          precautions: [
            'Avoid spraying in hot sun',
            'Wear protective clothing',
            'Do not exceed concentration'
          ],
          effectiveness: 82,
          isRecommended: true,
          alternativeProducts: ['Bordeaux mixture', 'Mancozeb'],
        ),
        Remedy(
          id: 'rem_006_b',
          title: 'Pruning and Sanitation',
          type: 'cultural',
          steps: [
            'Prune infected branches',
            'Remove fallen leaves',
            'Improve air circulation',
            'Reduce canopy density',
            'Apply balanced fertilizer'
          ],
          applicationMethod: 'Cultural practice',
          frequency: 'As needed',
          duration: 'Ongoing',
          precautions: [
            'Sterilize pruning tools',
            'Dispose of infected material',
            'Avoid wounding branches'
          ],
          effectiveness: 80,
          isRecommended: true,
        ),
      ],
      prevention: 'Maintain proper plant spacing, ensure good air circulation, avoid dense canopy, regular pruning, apply balanced nutrition, and monitor regularly.',
      seasonalActivity: 'Active during warm, humid conditions (April-September)',
      favorableConditions: [
        'High humidity',
        'Poor air circulation',
        'Dense plant canopy',
        'Warm temperatures (25-30°C)'
      ],
      similarPests: ['Leaf rust', 'Brown rust'],
      imageUrl: 'assets/pests/red_rust.jpg',
      isOrganic: true,
    ),

    // TEA THRIPS
    Pest(
      id: 'pest_007',
      name: 'Tea Thrips',
      scientificName: 'Scirtothrips dorsalis',
      category: 'Sucking Pests',
      type: 'insect',
      icon: '🪳',
      severity: 'Medium',
      description: 'Very small insects that feed on young leaves, causing characteristic silvery streaks and curling. They are active during dry weather and can cause significant damage.',
      symptoms: [
        'Silvery-white streaks on leaves',
        'Leaf curling and distortion',
        'Scarring on young leaves',
        'Reduced leaf quality',
        'Stunted shoot growth',
        'Fecal spots on leaves',
        'Presence of tiny insects on leaf undersides'
      ],
      affectedParts: ['leaves', 'shoots'],
      remedies: [
        Remedy(
          id: 'rem_007_a',
          title: 'Spinosad Application',
          type: 'organic',
          steps: [
            'Use Spinosad 45% SC (0.5ml/L water)',
            'Spray in the evening',
            'Apply when pests are first noticed',
            'Repeat every 7 days if needed',
            'Rotate with other organic pesticides'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'Every 7 days',
          duration: '3-4 applications',
          precautions: [
            'Avoid spraying in hot conditions',
            'Target young leaves',
            'Wear protective gear'
          ],
          effectiveness: 88,
          isRecommended: true,
          alternativeProducts: ['Neem oil', 'Garlic-chili spray'],
        ),
        Remedy(
          id: 'rem_007_b',
          title: 'Fipronil 5% SC',
          type: 'chemical',
          steps: [
            'Use 1ml Fipronil 5% SC per 1L water',
            'Spray early morning or late evening',
            'Apply when threshold is reached',
            'Observe waiting period of 7-10 days',
            'Do not exceed recommended dose'
          ],
          applicationMethod: 'Foliar spray',
          frequency: 'As needed',
          duration: '1-2 applications',
          precautions: [
            'Toxic to bees and aquatic life',
            'Use protective equipment',
            'Follow safety guidelines'
          ],
          effectiveness: 92,
          isRecommended: false,
          alternativeProducts: ['Imidacloprid', 'Thiamethoxam'],
        ),
      ],
      prevention: 'Regular monitoring, maintain plant health, use reflective mulches, apply neem oil preventively, and encourage natural enemies like predatory mites.',
      seasonalActivity: 'Active during dry seasons (October-June)',
      favorableConditions: [
        'Dry weather conditions',
        'New leaf flush',
        'Low humidity',
        'High temperatures (25-30°C)'
      ],
      similarPests: ['Jassid', 'Leafhopper'],
      imageUrl: 'assets/pests/tea_thrips.jpg',
      isOrganic: true,
    ),

    // HEALTHY LEAF
    Pest(
      id: 'pest_008',
      name: 'Healthy Leaf',
      scientificName: 'Camellia sinensis',
      category: 'Healthy',
      type: 'healthy',
      icon: '🍃',
      severity: 'None',
      description: 'A healthy tea leaf showing no signs of pest or disease damage. It exhibits normal color, texture, and growth patterns.',
      symptoms: [
        'No visible damage or discoloration',
        'Green, glossy leaves',
        'Normal growth pattern',
        'No spots or lesions',
        'Proper leaf size and shape'
      ],
      affectedParts: ['leaves'],
      remedies: [
        Remedy(
          id: 'rem_008_a',
          title: 'Maintain Health',
          type: 'cultural',
          steps: [
            'Continue regular care practices',
            'Monitor weekly for any changes',
            'Maintain proper nutrition',
            'Ensure adequate irrigation',
            'Apply preventive sprays when necessary'
          ],
          applicationMethod: 'Cultural practice',
          frequency: 'Ongoing',
          duration: 'Permanent',
          precautions: [
            'Keep monitoring regularly',
            'Maintain balanced fertilization',
            'Avoid over-watering'
          ],
          effectiveness: 100,
          isRecommended: true,
        ),
      ],
      prevention: 'Continue with good agricultural practices, regular monitoring, balanced nutrition, proper irrigation, and timely pest management.',
      seasonalActivity: 'N/A',
      favorableConditions: [],
      similarPests: [],
      imageUrl: 'assets/pests/healthy_leaf.jpg',
      isOrganic: true,
    ),
  ];

  // Get all pests
  static List<Pest> getPests() {
    return _pests;
  }

  // Get pest by ID
  static Pest? getPestById(String id) {
    try {
      return _pests.firstWhere((pest) => pest.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get pest by name
  static Pest? getPestByName(String name) {
    try {
      return _pests.firstWhere((pest) => pest.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  // Search pests
  static List<Pest> searchPests(String query) {
    if (query.isEmpty) return _pests;
    final lowerQuery = query.toLowerCase();
    return _pests.where((pest) =>
    pest.name.toLowerCase().contains(lowerQuery) ||
        pest.scientificName.toLowerCase().contains(lowerQuery) ||
        pest.category.toLowerCase().contains(lowerQuery) ||
        pest.description.toLowerCase().contains(lowerQuery) ||
        pest.symptoms.any((s) => s.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  // Filter by type
  static List<Pest> filterByType(String type) {
    if (type == 'All') return _pests;
    return _pests.where((pest) => pest.type == type).toList();
  }

  // Filter by severity
  static List<Pest> filterBySeverity(String severity) {
    if (severity == 'All') return _pests;
    return _pests.where((pest) => pest.severity == severity).toList();
  }

  // Get random pest
  static Pest getRandomPest() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _pests.length;
    return _pests[randomIndex.toInt()];
  }

  // Get pests by affected part
  static List<Pest> filterByAffectedPart(String part) {
    return _pests.where((pest) =>
        pest.affectedParts.any((p) => p.toLowerCase() == part.toLowerCase())
    ).toList();
  }

  // Get pests by category
  static List<Pest> filterByCategory(String category) {
    if (category == 'All') return _pests;
    return _pests.where((pest) => pest.category == category).toList();
  }

  // Get all categories
  static List<String> getCategories() {
    final categories = _pests.map((p) => p.category).toSet();
    return ['All', ...categories];
  }

  // Get all types
  static List<String> getTypes() {
    final types = _pests.map((p) => p.type).toSet();
    return ['All', ...types];
  }

  // Get all severities
  static List<String> getSeverities() {
    final severities = _pests.map((p) => p.severity).toSet();
    return ['All', ...severities];
  }

  // Get similar pests
  static List<Pest> getSimilarPests(Pest pest) {
    final similar = <Pest>[];
    for (final similarName in pest.similarPests) {
      final found = getPestByName(similarName);
      if (found != null) {
        similar.add(found);
      }
    }
    return similar;
  }

  // Get organic remedies for a pest
  static List<Remedy> getOrganicRemedies(Pest pest) {
    return pest.remedies.where((r) => r.type == 'organic').toList();
  }

  // Get chemical remedies for a pest
  static List<Remedy> getChemicalRemedies(Pest pest) {
    return pest.remedies.where((r) => r.type == 'chemical').toList();
  }

  // Get recommended remedies for a pest
  static List<Remedy> getRecommendedRemedies(Pest pest) {
    return pest.remedies.where((r) => r.isRecommended).toList();
  }

  // Check if pest is healthy
  static bool isHealthy(Pest pest) {
    return pest.type == 'healthy';
  }

  // Get severity level text
  static String getSeverityText(String severity) {
    switch (severity) {
      case 'Low': return 'Low - Monitor and take preventive measures';
      case 'Medium': return 'Medium - Take action soon';
      case 'High': return 'High - Immediate action required';
      case 'Critical': return 'Critical - Emergency intervention needed';
      case 'None': return 'No threat detected';
      default: return 'Unknown severity';
    }
  }

  // Get severity color
  static Color getSeverityColor(String severity) {
    switch (severity) {
      case 'Low': return Colors.yellow.shade700;
      case 'Medium': return Colors.orange;
      case 'High': return Colors.red;
      case 'Critical': return Colors.deepOrange;
      case 'None': return Colors.green;
      default: return Colors.grey;
    }
  }
}

// Extension methods for Pest
extension PestExtension on Pest {
  bool get isHealthy => this.type == 'healthy';
  bool get isOrganic => this.remedies.any((r) => r.type == 'organic');
  bool get hasChemicalRemedies => this.remedies.any((r) => r.type == 'chemical');
  bool get hasBiologicalControl => this.remedies.any((r) => r.type == 'biological');
  bool get hasCulturalRemedies => this.remedies.any((r) => r.type == 'cultural');

  String get severityText => PestLibrary.getSeverityText(severity);
  Color get severityColor => PestLibrary.getSeverityColor(severity);
}