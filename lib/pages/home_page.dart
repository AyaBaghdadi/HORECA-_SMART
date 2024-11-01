import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'meals_page.dart';
import 'links.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _categories = [];
  List<dynamic> _randomMeals = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchRandomMeals();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(Links().home));

    if (response.statusCode == 200) {
      setState(() {
        _categories = json.decode(response.body)['categories'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchRandomMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      setState(() {
        _randomMeals = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to load random meals');
    }
  }

  void selectCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider Section for Random Meals
            _randomMeals.isEmpty
                ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0, // Thinner loader
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Black color
              ),
            )
                : Container(
              height: 250, // Height of the slider
              child: PageView.builder(
                itemCount: _randomMeals.length,
                itemBuilder: (context, index) {
                  final meal = _randomMeals[index];
                  return Stack(
                    children: [
                      // Image Background
                      CachedNetworkImage(
                        imageUrl: meal['strMealThumb'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250, // Set the height to match the container
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0, // Thinner loader
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Black color
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error, size: 50),
                      ),
                      // Title Overlay at the Bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.black.withOpacity(0.7), // Black background with opacity
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
                            children: [
                              Text(
                                meal['strMeal'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4), // Space between title and description
                              Text(
                                meal['strInstructions'], // Assuming you want to display the instructions
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                maxLines: 1, // Limit to 1 line
                                overflow: TextOverflow.visible, // Show full text without ellipsis
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Categories Section as a List
            _categories.isEmpty
                ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0, // Thinner loader
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Black color
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8), // Added horizontal padding
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return GestureDetector(
                    onTap: () => selectCategory(category['strCategory']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8), // Background with opacity
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between category items
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: category['strCategoryThumb'],
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0, // Thinner loader
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Black color
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error, size: 50),
                              fit: BoxFit.contain, // Ensure the image is fully displayed
                              height: 60, // Reduced height for the image
                              width: 100, // Reduced width for the image
                            ),
                            SizedBox(width: 8), // Space between image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category['strCategory'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white), // Change title color to white
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    category['strCategoryDescription'],
                                    style: TextStyle(fontSize: 15, color: Colors.white70), // Improved font size
                                    maxLines: 1, // Limit to 1 line
                                    overflow: TextOverflow.visible, // Show full text without ellipsis
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
