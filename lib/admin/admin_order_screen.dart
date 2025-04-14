import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String selectedFilter = 'All';

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .get();

      if (!ds.exists) {
        throw 'Order not found';
      }

      final data = ds.data() as Map<String, dynamic>;
      String userId = data['userId'];
      String orderNumber = data['orderNumber'];

      await Future.wait([
        FirebaseFirestore.instance
            .collection('Orders')
            .doc(orderId)
            .update({'orderStatus': newStatus}),

        FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Orders')
            .doc(orderNumber)
            .update({'orderStatus': newStatus})
      ]);
    } catch (e) {
      print('Error updating order status: $e');
      rethrow; // or handle the error appropriately
    }
  }

  Widget _buildStatusDropdown(String currentStatus, String orderId) {
    return PopupMenuButton<String>(
      initialValue: currentStatus,
      onSelected: (String newStatus) {
        updateOrderStatus(orderId, newStatus);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Pending',
          child: Text('Pending'),
        ),
        const PopupMenuItem<String>(
          value: 'Preparing',
          child: Text('Preparing'),
        ),
        const PopupMenuItem<String>(
          value: 'Out for Delivery',
          child: Text('Out for Delivery'),
        ),
        const PopupMenuItem<String>(
          value: 'Delivered',
          child: Text('Delivered'),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: getStatusColor(currentStatus).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getOrderStatus(currentStatus),
              style: TextStyle(
                color: getStatusColor(currentStatus),
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: getStatusColor(currentStatus)),
          ],
        ),
      ),
    );
  }

  String getOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '🕒 Pending';
      case 'preparing':
        return '👨‍🍳 Preparing';
      case 'out for delivery':
        return 'Out for Delivery';
      case 'delivered':
        return '✅ Delivered';
      default:
        return '🕒 Pending';
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
        return Colors.orange;
    }
  }

  Widget buildOrderCard(DocumentSnapshot order) {
    final data = order.data() as Map<String, dynamic>;
    final orderTime = (data['OrderTime'] as Timestamp).toDate();
    final items = List<Map<String, dynamic>>.from(data['items']);
    final status = data['orderStatus'] ?? 'Pending';

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
                  _buildStatusDropdown(status, order.id),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                if (data['deliveryAddress']?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['deliveryAddress'],
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                ...items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(imageUrl: item['image'],
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
                )),
                Divider(),
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
          'Admin Orders Management',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // actions: [
        //   PopupMenuButton<String>(
        //     initialValue: selectedFilter,
        //     onSelected: (String value) {
        //       setState(() {
        //         selectedFilter = value;
        //       });
        //     },
        //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //       const PopupMenuItem<String>(
        //         value: 'All',
        //         child: Text('All Orders'),
        //       ),
        //       const PopupMenuItem<String>(
        //         value: 'Pending',
        //         child: Text('Pending Orders'),
        //       ),
        //       const PopupMenuItem<String>(
        //         value: 'Preparing',
        //         child: Text('Preparing Orders'),
        //       ),
        //       const PopupMenuItem<String>(
        //         value: 'Out for Delivery',
        //         child: Text('Out for Delivery'),
        //       ),
        //       const PopupMenuItem<String>(
        //         value: 'Delivered',
        //         child: Text('Delivered Orders'),
        //       ),
        //     ],
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 15),
        //       child: Row(
        //         children: [
        //           Text('Filter'),
        //           Icon(Icons.filter_list),
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: StreamBuilder(
        stream: selectedFilter == 'All'
            ? FirebaseFirestore.instance
            .collection('Orders')
            .orderBy('OrderTime', descending: true)
            .snapshots()
            : FirebaseFirestore.instance
            .collection('Orders')
            .where('orderStatus', isEqualTo: selectedFilter)
            .orderBy('OrderTime', descending: true)
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
                    'No orders found',
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