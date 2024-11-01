import 'package:flutter/material.dart';
import '../main.dart'; // Import the main.dart file where MainPage is defined
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed(BuildContext context) {
    // Handle login logic (you can replace this with your actual login logic)
    print('Login pressed with email: ${_emailController.text} and password: ${_passwordController.text}');

    // Navigate to the main page after login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void _onSkipPressed(BuildContext context) {
    // Navigate to the main page directly when "Skip" is pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // Set background to black
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900, // Dark background for the container
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Favorite Icon
                      Center(
                        child: Icon(
                          Icons.fastfood_sharp,
                          size: 100,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 20), // Space between icon and title

                      Text(
                        'Login'.tr(),
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white, // White text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40), // Space between title and text fields

                      // Email Text Field
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white), // White text color
                        decoration: InputDecoration(
                          labelText: 'Email'.tr(),
                          labelStyle: TextStyle(color: Colors.grey), // Grey label color
                          filled: true,
                          fillColor: Colors.grey.shade800, // Dark grey for text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Space between text fields

                      // Password Text Field
                      TextField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white), // White text color
                        obscureText: true, // Hide password text
                        decoration: InputDecoration(
                          labelText: 'Password'.tr(),
                          labelStyle: TextStyle(color: Colors.grey), // Grey label color
                          filled: true,
                          fillColor: Colors.grey.shade800, // Dark grey for text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Space between text fields and buttons

                      // Login Button
                      ElevatedButton(
                        onPressed: () => _onLoginPressed(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Button color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          minimumSize: Size(double.infinity, 50), // Full width
                        ),
                        child: Text(
                          'Login'.tr(),
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 50), // Space between buttons
                      // Skip Button
                      ElevatedButton(
                        onPressed: () => _onSkipPressed(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70, // Color for skip button
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          minimumSize: Size(double.infinity, 50), // Full width
                        ),
                        child: Text(
                          'Skip'.tr(),
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
