// links.dart
class Links {
  // Private constructor
  Links._privateConstructor();

  // The single instance of the Links class
  static final Links _instance = Links._privateConstructor();

  // Factory method to return the same instance
  factory Links() {
    return _instance;
  }

  // Define your links here
  String get home => 'https://www.themealdb.com/api/json/v1/1/categories.php';
  String get meals => 'https://www.themealdb.com/api/json/v1/1/filter.php?c=';
  String get contact => 'https://yourwebsite.com/contact';
  String get terms => 'https://yourwebsite.com/terms';
  String get privacy => 'https://yourwebsite.com/privacy';

// Add more links as needed
}
