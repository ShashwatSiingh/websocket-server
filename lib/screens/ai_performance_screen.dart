import 'package:flutter/material.dart';

class AIMetric {
  final String name;
  final double value;
  final String unit;
  final IconData icon;
  final Color color;
  final double trend;

  AIMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

class AIPerformanceScreen extends StatelessWidget {
  AIPerformanceScreen({super.key});

  final List<AIMetric> metrics = [
    AIMetric(
      name: 'Response Rate',
      value: 95.5,
      unit: '%',
      icon: Icons.speed,
      color: Colors.green,
      trend: 2.3,
    ),
    AIMetric(
      name: 'Average Response Time',
      value: 2.5,
      unit: 's',
      icon: Icons.timer,
      color: Colors.blue,
      trend: -0.3,
    ),
    AIMetric(
      name: 'Accuracy Score',
      value: 89.2,
      unit: '%',
      icon: Icons.analytics,
      color: Colors.orange,
      trend: 1.5,
    ),
    AIMetric(
      name: 'Customer Satisfaction',
      value: 4.8,
      unit: '/5',
      icon: Icons.sentiment_satisfied_alt,
      color: Colors.purple,
      trend: 0.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Performance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // Implement date range picker
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Implement report download
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsGrid(),
            const SizedBox(height: 24),
            _buildPerformanceHistory(context),
            const SizedBox(height: 24),
            _buildTopIssues(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(metric.icon, color: metric.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        metric.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${metric.value}${metric.unit}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: metric.color,
                          ),
                    ),
                    const SizedBox(width: 8),
                    _buildTrendIndicator(metric.trend),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendIndicator(double trend) {
    final isPositive = trend >= 0;
    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? Colors.green : Colors.red,
          size: 16,
        ),
        Text(
          '${trend.abs()}%',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceHistory(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Performance Chart will be displayed here',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIssues(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Issues',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildIssueItem(
              'Product Inquiries',
              65,
              Colors.blue,
            ),
            _buildIssueItem(
              'Order Status',
              45,
              Colors.orange,
            ),
            _buildIssueItem(
              'Technical Support',
              30,
              Colors.purple,
            ),
            _buildIssueItem(
              'Returns & Refunds',
              25,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueItem(String name, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name),
          ),
          Text(
            count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}