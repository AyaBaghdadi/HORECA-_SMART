import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'full_screen_image_page.dart'; // Import the FullScreenImagePage
import 'package:easy_localization/easy_localization.dart';
import 'links.dart';

class MealsPage extends StatefulWidget {
  final String category;

  MealsPage({required this.category});

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<dynamic> _meals = [];
  List<int> _counts = [];

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
  }

  Future<void> fetchMealsByCategory() async {
    final response = await http.get(Uri.parse('${Links().meals}${widget.category}'));

    if (response.statusCode == 200) {
      setState(() {
        _meals = json.decode(response.body)['meals'];
        _counts = List<int>.filled(_meals.length, 0); // Initialize counts
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  void incrementCount(int index) {
    setState(() {
      _counts[index]++;
    });
  }

  void decrementCount(int index) {
    setState(() {
      if (_counts[index] > 0) {
        _counts[index]--;
      }
    });
  }

  Future<void> addToCart(int index) async {
    final meal = _meals[index];
    String title = meal['strMeal'];
    String imageUrl = meal['strMealThumb'];
    int count = _counts[index];
    String category = widget.category; // Save the category

    if (count > 0) {
      final prefs = await SharedPreferences.getInstance();
      List<String> cartItems = prefs.getStringList('cart') ?? [];

      // Check if the meal is already in the cart
      bool mealExists = false;
      for (int i = 0; i < cartItems.length; i++) {
        var item = json.decode(cartItems[i]);
        if (item['title'] == title && item['category'] == category) {
          mealExists = true;
          // Update the count
          item['count'] += count;
          cartItems[i] = json.encode(item);
          break;
        }
      }

      if (!mealExists) {
        // Create a new item if it doesn't exist
        String item = json.encode({
          'title': title,
          'imageUrl': imageUrl,
          'count': count,
          'category': category, // Include category in the item
        });
        cartItems.add(item);
      }

      await prefs.setStringList('cart', cartItems);

      // Show a toast message with custom background and text color
      Fluttertoast.showToast(
        msg: "$title " + "added to cart!".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white, // Set background color to white
        textColor: Colors.black, // Set text color to black
        fontSize: 16.0,
        webBgColor: "#ffffff", // For web support
        webShowClose: true,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white70,
            ),
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _meals.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Image with top corners rounded
                      ClipRRect(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to FullScreenImagePage on tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: meal['strMealThumb'],
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: meal['strMealThumb'],
                            placeholder: (context, url) => Center(
                              child: Container(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, color: Colors.white),
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Overlay for title and buttons at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(10)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                meal['strMeal'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Count and Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Add to Cart Button
                                  ElevatedButton(
                                    onPressed: () => addToCart(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Text(
                                      'Add to Cart'.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      // Minus Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.remove, color: Colors.black),
                                          onPressed: () => decrementCount(index),
                                        ),
                                      ),
                                      // Count
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Text(
                                          '${_counts[index]}',
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                      ),
                                      // Plus Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.add, color: Colors.white),
                                          onPressed: () => incrementCount(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Bottom ad-like banner
          Container(
            width: double.infinity,
            color: Colors.black.withOpacity(0.8),
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Fixed Price in All Meals'.tr(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    '170 ' + 'EGP'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Expected ( Breakfast or Sides )'.tr(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    '100 ' + 'EGP'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
