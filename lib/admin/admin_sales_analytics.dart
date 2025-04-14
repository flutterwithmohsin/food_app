import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminSalesAnalytics extends StatefulWidget {
  const AdminSalesAnalytics({super.key});

  @override
  State<AdminSalesAnalytics> createState() => _AdminSalesAnalyticsState();
}

class _AdminSalesAnalyticsState extends State<AdminSalesAnalytics> {
  String selectedPeriod = 'Today';
  bool isLoading = true;
  double totalSales = 0;
  int totalOrders = 0;
  double averageOrderValue = 0;
  List<SalesData> salesData = [];

  @override
  void initState() {
    super.initState();
    loadSalesData();
  }

  Future<void> loadSalesData() async {
    setState(() => isLoading = true);

    DateTime now = DateTime.now();
    DateTime startDate;

    // Determine date range based on selected period
    switch (selectedPeriod) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        startDate = now.subtract(Duration(days: 7));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
    }

    // Query orders within the date range
    QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('OrderTime', isGreaterThanOrEqualTo: startDate)
        .where('OrderTime', isLessThanOrEqualTo: now)
        .get();

    // Process orders
    totalSales = 0;
    totalOrders = orderSnapshot.docs.length;
    Map<String, double> dailySales = {};

    for (var doc in orderSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime orderDate = (data['OrderTime'] as Timestamp).toDate();
      String dateKey = DateFormat('yyyy-MM-dd').format(orderDate);
      double orderTotal = double.parse(data['orderTotal'].toString());

      totalSales += orderTotal;
      dailySales[dateKey] = (dailySales[dateKey] ?? 0) + orderTotal;
    }

    // Calculate average order value
    averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0;

    // Convert daily sales to list for chart
    salesData = dailySales.entries.map((entry) {
      return SalesData(
        DateTime.parse(entry.key),
        entry.value,
      );
    }).toList();

    salesData.sort((a, b) => a.date.compareTo(b.date));

    setState(() => isLoading = false);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    if (salesData.isEmpty) {
      return Center(
        child: Text(
          'No sales data available for this period',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Container(
      height: 300,
      padding: EdgeInsets.all(15),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < salesData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('MM/dd').format(salesData[value.toInt()].date),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
              left: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          minX: 0,
          maxX: salesData.length.toDouble() - 1,
          minY: 0,
          maxY: salesData.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                salesData.length,
                    (index) => FlSpot(index.toDouble(), salesData[index].amount),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(
          'Sales Analytics',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            initialValue: selectedPeriod,
            onSelected: (String value) {
              setState(() {
                selectedPeriod = value;
                loadSalesData();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Today',
                child: Text('Today'),
              ),
              const PopupMenuItem<String>(
                value: 'Week',
                child: Text('This Week'),
              ),
              const PopupMenuItem<String>(
                value: 'Month',
                child: Text('This Month'),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(selectedPeriod),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orangeAccent,))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Sales',
                      '\$${totalSales.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Orders',
                      totalOrders.toString(),
                      Icons.shopping_bag,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildStatCard(
                'Average Order Value',
                '\$${averageOrderValue.toStringAsFixed(2)}',
                Icons.analytics,
                Colors.purple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Sales Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildSalesChart(),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final DateTime date;
  final double amount;

  SalesData(this.date, this.amount);
}