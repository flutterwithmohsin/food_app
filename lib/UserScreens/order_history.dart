import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String? id = FirebaseAuth.instance.currentUser!.uid;

  String getOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '🕒 Pending';
      case 'preparing':
        return '👨‍🍳 Preparing';
      case 'out for delivery':
        return '🚚 Out for Delivery';
      case 'delivered':
        return '✅ Delivered';
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'out for delivery':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget buildOrderCard(DocumentSnapshot order) {
    final data = order.data() as Map<String, dynamic>;
    final orderTime = (data['orderTime'] as Timestamp).toDate();
    final estimatedDelivery = (data['estimatedDeliveryTime'] as Timestamp).toDate();
    final items = List<Map<String, dynamic>>.from(data['items']);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(15),
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          expandedAlignment: Alignment.topLeft,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${data['orderNumber'].substring(8)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: getStatusColor(data['orderStatus']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getOrderStatus(data['orderStatus']),
                      style: TextStyle(
                        color: getStatusColor(data['orderStatus']),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(orderTime),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          children: [
            // Order Details Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                // Items List
                ...items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item['image'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Quantity: ${item['quantity']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                Divider(),
                // Order Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${data['orderTotal']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Estimated Delivery Time
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(id)
            .collection('Orders')
            .orderBy('orderTime', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: snapshot.data!.docs.map((doc) => buildOrderCard(doc)).toList(),
          );
        },
      ),
    );
  }
}