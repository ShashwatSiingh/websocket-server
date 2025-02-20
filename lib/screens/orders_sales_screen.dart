import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OrdersSalesScreen extends StatelessWidget {
  const OrdersSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders & Sales'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Sales Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(),
            _buildSalesAnalytics(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          'Order #1234',
          'Premium Package',
          'Processing',
          '\$299.99',
          DateTime.now().subtract(const Duration(hours: 3)),
        ),
        _buildOrderCard(
          'Order #1235',
          'Basic Package',
          'Completed',
          '\$149.99',
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        // Add more orders
      ],
    );
  }

  Widget _buildOrderCard(
    String orderId,
    String product,
    String status,
    String amount,
    DateTime timestamp,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(orderId),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product),
            Text('Status: $status'),
            Text('Amount: $amount'),
            Text('Ordered: ${_formatTimestamp(timestamp)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.receipt),
          onPressed: () {
            // Show order details
          },
        ),
      ),
    );
  }

  Widget _buildSalesAnalytics() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        // Add your chart data here
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add more analytics widgets
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}