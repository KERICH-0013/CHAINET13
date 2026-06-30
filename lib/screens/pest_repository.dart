// lib/repositories/pest_repository.dart
import '../screens/pest_library.dart';

class PestRepository {
  // Use local pest library instead of Firebase
  static List<Pest> getPests() {
    return PestLibrary.getPests();
  }

  static Pest? getPestById(String id) {
    return PestLibrary.getPestById(id);
  }

  static List<Pest> searchPests(String query) {
    return PestLibrary.searchPests(query);
  }

  static List<Pest> filterByType(String type) {
    return PestLibrary.filterByType(type);
  }

  static List<Pest> filterBySeverity(String severity) {
    return PestLibrary.filterBySeverity(severity);
  }

  static List<Pest> filterByCategory(String category) {
    return PestLibrary.filterByCategory(category);
  }

  static List<String> getCategories() {
    return PestLibrary.getCategories();
  }

  static List<String> getTypes() {
    return PestLibrary.getTypes();
  }

  static List<String> getSeverities() {
    return PestLibrary.getSeverities();
  }

  static Pest getRandomPest() {
    return PestLibrary.getRandomPest();
  }
}