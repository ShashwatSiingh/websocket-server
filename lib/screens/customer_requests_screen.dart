import 'package:flutter/material.dart';

class CustomerRequestsScreen extends StatelessWidget {
  const CustomerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Requests'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRequestCard(
            'Technical Support',
            'John Smith',
            'Pending',
            'High',
            DateTime.now().subtract(const Duration(hours: 2)),
          ),
          _buildRequestCard(
            'Product Inquiry',
            'Sarah Johnson',
            'New',
            'Medium',
            DateTime.now().subtract(const Duration(minutes: 45)),
          ),
          // Add more request cards as needed
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new request functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRequestCard(
    String type,
    String customerName,
    String status,
    String priority,
    DateTime timestamp,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(type),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customerName),
            Text('Status: $status • Priority: $priority'),
            Text('Submitted: ${_formatTimestamp(timestamp)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Handle request details
          },
        ),
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