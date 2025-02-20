class SalesOverviewScreen extends StatelessWidget {
  const SalesOverviewScreen({super.key});  // Make constructor const

  // Move sales to a static field or provider
  static final List<SaleItem> sales = [
    SaleItem(
      orderNumber: 'ORD-001',
      customerName: 'John Doe',
      amount: 299.99,
      status: 'Completed',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      paymentMethod: 'Credit Card',
    ),
    SaleItem(
      orderNumber: 'ORD-002',
      customerName: 'Alice Smith',
      amount: 149.99,
      status: 'Processing',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      paymentMethod: 'PayPal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ... rest of the code remains the same
  }
}