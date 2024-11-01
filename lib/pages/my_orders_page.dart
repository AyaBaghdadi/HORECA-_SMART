import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orderList = prefs.getStringList('orders') ?? [];

    setState(() {
      _orders = orderList.map((order) => json.decode(order)).toList();
      _orders = _orders.reversed.toList(); // Reverse the list to show the most recent orders first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders'.tr(),
          style: TextStyle(color: Colors.white,fontSize: 20), // Set text color to white
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white if any icons are present
      ),
      body: _orders.isEmpty
          ? Center(
        child: Text(
          'No orders found',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final items = order['items'] as List<dynamic>;
          final totalPrice = order['totalPrice'] as double;

          return Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.8), // Set card background with opacity
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order'.tr() + ' #${_orders.length - index}', // Adjust order number for reversed list
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10), // Space below order title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                    children: [
                      Text(
                        'Total:'.tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5), // Space between label and price
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ' + "EGP".tr(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Space below total
                  Text(
                    'Details:'.tr() + ' ${order['details']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10), // Add spacing between details and items
                  Text(
                    'Items:'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Add spacing between details and items
                  // Loop through items to display title and count
                  for (var item in items) ...[
                    Row(
                      children: [
                        // Display circular item image
                        ClipOval(
                          child: Image.network(
                            item['imageUrl'], // Assuming each item has an imageUrl field
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10), // Add some spacing
                        Expanded(
                          child: Text(
                            '- ${item['title']} (x${item['count']})',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Vertical space between each meal
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
