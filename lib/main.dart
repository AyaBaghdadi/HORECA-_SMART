import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/my_cart_page.dart';
import 'pages/my_orders_page.dart';
import 'pages/settings_page.dart';
import 'pages/recommended_page.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Initialize easy_localization

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AE')],
      path: 'assets/translations', // Path to the translation files
      fallbackLocale: Locale('en', 'US'), // Fallback locale
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodApp',
      theme:
      ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green,
        ),
        fontFamily: 'Tajawal', // Set default font for the entire app
      ),
      localizationsDelegates: context.localizationDelegates, // Add localization delegates
      supportedLocales: context.supportedLocales, // Supported locales
      locale: context.locale, // Set the locale
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MyCartPage(),
    MyOrdersPage(),
    RecommendedProductsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TASK'.tr(), // Use localized string
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'.tr(), // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'My Cart'.tr(), // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Orders'.tr(), // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Recommend'.tr(), // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'.tr(), // Use localized string
          ),
        ],
      ),
    );
  }
}
