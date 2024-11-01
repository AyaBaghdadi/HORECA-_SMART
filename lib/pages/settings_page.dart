import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_task/main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the selected language based on the current locale
    _selectedLanguage = context.locale.languageCode;
  }

  void _changeLanguage(String? languageCode) {
    if (languageCode != null) {
      setState(() {
        _selectedLanguage = languageCode;
      });

      // Set the new locale
      context.setLocale(Locale(
        languageCode == 'ar' ? 'ar' : 'en',
        languageCode == 'ar' ? 'AE' : 'US',
      ));

      // This will ensure the UI refreshes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false,
      );
    }
  }

  void _onLoginPressed() {
    // Navigate to the LoginPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings'.tr(),
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Language Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF333344),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16, // Adjust font size here
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text(
                            'عربي',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16, // Adjust font size here
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _changeLanguage(value);
                        }
                      },
                      dropdownColor: Color(0xFF333344),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                        fontSize: 18, // Adjust font size here
                      ),
                      iconEnabledColor: Colors.white,
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 8),
                    Text(
                      'Login'.tr(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Contact Information
              Text(
                'Contact Me'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // LinkedIn Link
              GestureDetector(
                onTap: () {
                  print('Tapped on LinkedIn');
                },
                child: Row(
                  children: [
                    Icon(Icons.code, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'LinkedIn: www.linkedin.com/in/aya-baghdadi-500693138/',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Email Address
              GestureDetector(
                onTap: () {
                  print('Tapped on Email');
                },
                child: Row(
                  children: [
                    Icon(Icons.email, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Email: aya10.4.96@gmail.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Website URL
              GestureDetector(
                onTap: () {
                  print('Tapped on Website URL');
                },
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Portfolio: https://ayabaghdadi83.netlify.app',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Copyright
              Center(
                child: Text(
                  '© Aya Baghdadi 2024',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
