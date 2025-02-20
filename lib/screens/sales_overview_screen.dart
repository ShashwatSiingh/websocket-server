import 'package:flutter/material.dart';
import '../widgets/animated_pie_chart.dart';
import '../models/chart_section_data.dart';

class SaleItem {
  final String orderNumber;
  final String customerName;
  final double amount;
  final String status;
  final DateTime timestamp;
  final String paymentMethod;

  const SaleItem({
    required this.orderNumber,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.paymentMethod,
  });
}

class SalesOverviewScreen extends StatelessWidget {
  const SalesOverviewScreen({super.key});

  static final DateTime _now = DateTime.now();

  static final List<SaleItem> sales = [
    SaleItem(
      orderNumber: 'ORD-001',
      customerName: 'John Doe',
      amount: 299.99,
      status: 'Completed',
      timestamp: _now.subtract(const Duration(hours: 2)),
      paymentMethod: 'Credit Card',
    ),
    SaleItem(
      orderNumber: 'ORD-002',
      customerName: 'Alice Smith',
      amount: 149.99,
      status: 'Processing',
      timestamp: _now.subtract(const Duration(hours: 3)),
      paymentMethod: 'PayPal',
    ),
    // Add more sales
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Implement date filter
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummaryCards(context),
            _buildPieChartSection(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Sales',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: _buildSalesList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Today\'s Sales',
                  '\$1,234.56',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Orders',
                  '25',
                  Icons.shopping_cart,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Average Order',
                  '\$49.38',
                  Icons.analytics,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Conversion Rate',
                  '3.2%',
                  Icons.show_chart,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesList() {
    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        sale.orderNumber,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sale.customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(sale.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sale.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(sale.paymentMethod),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${sale.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getTimeAgo(sale.timestamp),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              // Navigate to sale details
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'Completed' => Colors.green,
      'Processing' => Colors.blue,
      'Cancelled' => Colors.red,
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

  Widget _buildPieChartSection(BuildContext context) {
    final salesData = [
      ChartSectionData(
        title: 'Completed',
        value: 145,
        color: Colors.green.shade400,
      ),
      ChartSectionData(
        title: 'Processing',
        value: 45,
        color: Colors.blue.shade400,
      ),
      ChartSectionData(
        title: 'Pending',
        value: 23,
        color: Colors.orange.shade400,
      ),
      ChartSectionData(
        title: 'Cancelled',
        value: 7,
        color: Colors.red.shade400,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sales Distribution',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 200,
                      child: AnimatedPieChart(
                        data: salesData,
                        title: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Legend
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: salesData.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                '${item.value}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Total Orders',
                    '220',
                    Icons.shopping_cart,
                  ),
                  _buildStatItem(
                    context,
                    'Total Revenue',
                    '\$15,234',
                    Icons.attach_money,
                  ),
                  _buildStatItem(
                    context,
                    'Avg. Order Value',
                    '\$69.25',
                    Icons.trending_up,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}