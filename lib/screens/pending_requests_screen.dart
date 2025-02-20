import 'package:flutter/material.dart';

class RequestItem {
  final String customerName;
  final String requestType;
  final String status;
  final DateTime timestamp;
  final String priority;

  const RequestItem({
    required this.customerName,
    required this.requestType,
    required this.status,
    required this.timestamp,
    required this.priority,
  });
}

class PendingRequestsScreen extends StatelessWidget {
  const PendingRequestsScreen({super.key});

  static final DateTime _now = DateTime.now();

  static final List<RequestItem> requests = [
    RequestItem(
      customerName: 'John Doe',
      requestType: 'Refund Request',
      status: 'Pending',
      timestamp: _now.subtract(const Duration(hours: 2)),
      priority: 'High',
    ),
    RequestItem(
      customerName: 'Alice Smith',
      requestType: 'Technical Support',
      status: 'In Progress',
      timestamp: _now.subtract(const Duration(hours: 3)),
      priority: 'Medium',
    ),
    // Add more requests
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: _getPriorityIcon(request.priority),
              title: Text(request.customerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.requestType),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          request.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getTimeAgo(request.timestamp),
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Navigate to request detail screen
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getPriorityIcon(String priority) {
    final color = switch (priority) {
      'High' => Colors.red,
      'Medium' => Colors.orange,
      _ => Colors.green,
    };

    return CircleAvatar(
      backgroundColor: color,
      child: const Icon(Icons.priority_high, color: Colors.white),
    );
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'Pending' => Colors.orange,
      'In Progress' => Colors.blue,
      _ => Colors.grey,
    };
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    return '${difference.inDays}d ago';
  }
}