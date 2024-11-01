import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  List<dynamic> _cartItems = [];
  double _totalPrice = 0.0;
  final double _defaultMealPrice = 170.0; // Default price per meal
  final double _breakfastSidePrice = 100.0; // Price for Breakfast or Side
  TextEditingController _orderDetailsController = TextEditingController(); // Controller for order details

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];

    setState(() {
      _cartItems = cartItems.map((item) => json.decode(item)).toList();
      _totalPrice = _cartItems.fold(0.0, (sum, item) {
        double itemPrice = (item['category'] == 'Breakfast' || item['category'] == 'Side')
            ? _breakfastSidePrice
            : _defaultMealPrice;
        return sum + (item['count'] * itemPrice);
      });
    });
  }

  void removeFromCart(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];

    // Remove the item from the cart
    cartItems.removeAt(index);
    await prefs.setStringList('cart', cartItems);

    // Reload the cart items
    loadCartItems();
  }

  void incrementCount(int index) async {
    setState(() {
      _cartItems[index]['count']++;
    });
    await _saveCartItems();
  }

  void decrementCount(int index) async {
    if (_cartItems[index]['count'] > 1) {
      setState(() {
        _cartItems[index]['count']--;
      });
      await _saveCartItems();
    }
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = _cartItems.map((item) => json.encode(item)).toList();
    await prefs.setStringList('cart', cartItems);
    loadCartItems();
  }

  void placeOrder() async {
    String orderDetails = _orderDetailsController.text;

    if (_cartItems.isEmpty) {
      // Show a toast message if the cart is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty! Please add items to place an order.'.tr())),
      );
      return; // Exit the function if the cart is empty
    }

    if (orderDetails.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      List<String> orders = prefs.getStringList('orders') ?? [];

      // Add order details to local storage
      orders.add(json.encode({
        'details': orderDetails,
        'items': _cartItems,
        'totalPrice': _totalPrice,
      }));

      await prefs.setStringList('orders', orders);

      // Clear cart items
      await prefs.remove('cart');
      _cartItems.clear();
      _totalPrice = 0.0;
      _orderDetailsController.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Order Placed'.tr()),
          content: Text('Your order has been placed successfully! Details:'.tr() + '$orderDetails'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Sets the text color to green
              ),
              child: Text('OK'.tr()),
            ),
          ],
        ),
      );

      // Reload the cart items
      loadCartItems();
    } else {
      // Show a message if the order details are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter order details'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Total:'.tr() + ' ${_totalPrice.toStringAsFixed(2)} ' + 'EGP'.tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            )
                : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                double itemPricePerPiece = (item['category'] == 'Breakfast' || item['category'] == 'Side')
                    ? _breakfastSidePrice
                    : _defaultMealPrice;
                double itemTotalPrice = item['count'] * itemPricePerPiece;

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8), // Background color with opacity
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: CircleAvatar(
                          radius: 35, // Adjust the radius for the circle size
                          backgroundImage: NetworkImage(item['imageUrl']),
                        ),
                        title: Text(
                          item['title'],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price per piece:'.tr() + ' ${itemPricePerPiece.toStringAsFixed(2)} ' + 'EGP'.tr(),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, // Background color for minus button
                                    foregroundColor: Colors.red, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // Square with 4px radius
                                    ),
                                    minimumSize: Size(40, 40), // Set width and height to be the same
                                  ),
                                  child: Text('-', style: TextStyle(color: Colors.red)),
                                  onPressed: () => decrementCount(index),
                                ),
                                SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '${item['count']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Background color for plus button
                                    foregroundColor: Colors.white, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // Square with 4px radius
                                    ),
                                    minimumSize: Size(40, 40), // Set width and height to be the same
                                  ),
                                  child: Text('+'),
                                  onPressed: () => incrementCount(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => removeFromCart(index),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: context.locale.languageCode == 'ar' ? null : 8.0,
                        left: context.locale.languageCode == 'ar' ? 8.0 : null,
                        // left:8,
                        child: Text(
                          'Total:'.tr() + ' ${itemTotalPrice.toStringAsFixed(2)} ' + 'EGP'.tr(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                controller: _orderDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter order details'.tr(),
                  hintStyle: TextStyle(color: Colors.grey), // Gray placeholder text
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button background color
                padding: EdgeInsets.symmetric(vertical: 16), // Increased vertical padding for a larger button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 48), // Full width button
              ),
              onPressed: placeOrder,
              child: Text(
                'Place Order'.tr(),
                style: TextStyle(fontSize: 18,color: Colors.white), // Larger font size for button text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
