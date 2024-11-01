
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'full_screen_image_page.dart'; // Import the full screen image page
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String instructions;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.instructions,
    required this.category,
  });
}

class RecommendedProductsPage extends StatefulWidget {
  @override
  _RecommendedProductsPageState createState() => _RecommendedProductsPageState();
}

class _RecommendedProductsPageState extends State<RecommendedProductsPage> {
  List<Product> recommendedProducts = [];
  List<int> productCounts = []; // To track the count of each product

  @override
  void initState() {
    super.initState();
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'];

      setState(() {
        recommendedProducts = (meals as List).map((meal) {
          return Product(
            id: meal['idMeal'],
            name: meal['strMeal'],
            imageUrl: meal['strMealThumb'],
            instructions: meal['strInstructions'],
            category: meal['strCategory'], // Get the category from the response
          );
        }).toList();

        // Initialize counts for each product
        productCounts = List.filled(recommendedProducts.length, 0);
      });
    } else {
      throw Exception('Failed to load recommended products');
    }
  }

  void incrementCount(int index) {
    setState(() {
      productCounts[index]++;
    });
  }

  void decrementCount(int index) {
    setState(() {
      if (productCounts[index] > 0) {
        productCounts[index]--;
      }
    });
  }

  Future<void> addToCart(int index) async {
    final meal = recommendedProducts[index];
    String title = meal.name;
    String imageUrl = meal.imageUrl;
    int count = productCounts[index];
    String category = meal.category; // Save the category

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
        msg: "$title " + 'added to cart!'.tr(),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recommended Meals'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 420, // Adjust height as necessary
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedProducts.length,
              itemBuilder: (ctx, index) {
                final product = recommendedProducts[index];
                final count = productCounts[index];
                const price = 170.0; // Fixed price for each product

                return Container(
                  width: 200, // Width for each product card
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7), // Cell background with opacity
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Card(
                    color: Colors.transparent, // Make card transparent to show background
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to the full-screen image page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(imageUrl: product.imageUrl),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product.imageUrl,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.category, // Display the category
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ),
                        SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${price.toStringAsFixed(2)} ' + 'EGP'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.instructions,
                            maxLines: 3, // Allow up to 4 lines for the description
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white70,fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding for buttons
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.74), // White background for minus button
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.black),
                                  onPressed: () => decrementCount(index),
                                ),
                              ),
                              Text(
                                '$count',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green, // Green background for plus button
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () => incrementCount(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Button background color
                                    padding: EdgeInsets.symmetric(vertical: 12.0), // Vertical padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // Rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    addToCart(index);
                                  },
                                  child: Text(
                                    'Add to Cart'.tr(),
                                    style: TextStyle(color: Colors.white), // Button text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
