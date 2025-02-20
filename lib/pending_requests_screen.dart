class PendingRequestsScreen extends StatelessWidget {
  const PendingRequestsScreen({super.key});  // Make constructor const

  // Move requests to a static field or provider
  static final List<RequestItem> requests = [
    RequestItem(
      customerName: 'John Doe',
      requestType: 'Refund Request',
      status: 'Pending',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      priority: 'High',
    ),
    RequestItem(
      customerName: 'Alice Smith',
      requestType: 'Technical Support',
      status: 'In Progress',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      priority: 'Medium',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ... rest of the code remains the same
  }
}