import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/animated_stat_card.dart';
import '../widgets/animated_chart.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/animated_drawer_item.dart';
import '../widgets/custom_search_bar.dart';
import '../providers/dashboard_provider.dart';
import '../theme/custom_theme.dart';
import 'package:provider/provider.dart';
import '../widgets/animated_pie_chart.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_performance_screen.dart';
import '../screens/active_chats_screen.dart';
import '../screens/pending_requests_screen.dart';
import '../screens/sales_overview_screen.dart';
import '../models/chart_section_data.dart';
import '../providers/theme_provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_dialog.dart';
import '../screens/live_interactions_screen.dart';
import '../screens/customer_requests_screen.dart';
import '../screens/orders_sales_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize todos when dashboard loads
    Provider.of<TodoProvider>(context, listen: false).initTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        size: 32,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'AI Support Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            AnimatedDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                // Already on home, no need to navigate
              },
              delay: const Duration(milliseconds: 100),
            ),
            AnimatedDrawerItem(
              icon: Icons.phone_in_talk,
              title: 'Live Interactions',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveInteractionsScreen()),
                );
              },
              delay: const Duration(milliseconds: 150),
            ),
            AnimatedDrawerItem(
              icon: Icons.support,
              title: 'Customer Requests',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerRequestsScreen()),
                );
              },
              delay: const Duration(milliseconds: 200),
            ),
            AnimatedDrawerItem(
              icon: Icons.shopping_cart,
              title: 'Orders & Sales',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersSalesScreen()),
                );
              },
              delay: const Duration(milliseconds: 250),
            ),
            AnimatedDrawerItem(
              icon: Icons.checklist,
              title: 'To-Do List',
              onTap: () => Navigator.pop(context),
              delay: const Duration(milliseconds: 300),
            ),
            AnimatedDrawerItem(
              icon: Icons.analytics,
              title: 'AI Analytics',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIPerformanceScreen()),
                );
              },
              delay: const Duration(milliseconds: 350),
            ),
            AnimatedDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              delay: const Duration(milliseconds: 400),
            ),
            const Divider(),
            AnimatedDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              delay: const Duration(milliseconds: 450),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: context.watch<DashboardProvider>().isLoading,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  // Main Content Area
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const MainDashboardContent(),
                    ),
                  ),

                  // Right Panel - Only show if screen is wide enough
                  if (constraints.maxWidth > 1200)
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: const RightPanelContent(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MainDashboardContent extends StatelessWidget {
  const MainDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardProvider>().refreshData(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Quick Filters
              _buildQuickFilters(),
              const SizedBox(height: 24),

              // Stats Overview
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AnimatedStatCard(
                      title: 'Active Chats',
                      value: '12',
                      icon: Icons.chat_bubble,
                      color: Colors.blue,
                      delay: const Duration(milliseconds: 100),
                      onTap: () => _showDetailDialog(context, 'Active Chats'),
                    ),
                    const SizedBox(width: 16),
                    AnimatedStatCard(
                      title: 'Pending Requests',
                      value: '28',
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                      delay: const Duration(milliseconds: 200),
                      onTap: () => _showDetailDialog(context, 'Pending Requests'),
                    ),
                    const SizedBox(width: 16),
                    AnimatedStatCard(
                      title: 'Today\'s Sales',
                      value: '\$2,854',
                      icon: Icons.attach_money,
                      color: Colors.green,
                      delay: const Duration(milliseconds: 300),
                      onTap: () => _showDetailDialog(context, 'Today\'s Sales'),
                    ),
                    const SizedBox(width: 16),
                    AnimatedStatCard(
                      title: 'AI Response Rate',
                      value: '95%',
                      icon: Icons.speed,
                      color: Colors.purple,
                      delay: const Duration(milliseconds: 400),
                      onTap: () => _showDetailDialog(context, 'AI Response Rate'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Live Interactions Panel
              _buildSection(
                'Live Interactions',
                _buildLiveInteractionsPanel(),
              ),
              const SizedBox(height: 24),

              // AI Performance Metrics
              _buildSection(
                'AI Performance Metrics',
                _buildAIMetricsPanel(context),
              ),
              const SizedBox(height: 24),

              // Sales & Orders Overview
              _buildSection(
                'Sales & Orders Overview',
                _buildSalesOrdersPanel(context),
              ),
              const SizedBox(height: 24),

              // To-Do List
              _buildSection(
                'Today\'s Tasks',
                const TodoList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomSearchBar(
      hint: 'Search customers, orders, or requests...',
      onChanged: (value) {
        // Implement search functionality
      },
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Urgent'),
          _buildFilterChip('Pending'),
          _buildFilterChip('Completed'),
          _buildFilterChip('AI Handled'),
          _buildFilterChip('Human Required'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        onSelected: (bool selected) {
          // Add filter logic
        },
      ),
    );
  }

  Widget _buildLiveInteractionsPanel() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Active Chat - John Doe'),
            subtitle: const Text('Duration: 5:23'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.record_voice_over),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.call_end),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Add more active chats...
        ],
      ),
    );
  }

  Widget _buildAIMetricsPanel(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with time filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Performance Metrics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                DropdownButton<String>(
                  value: 'Today',
                  items: ['Today', 'Week', 'Month', 'Year']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // Implement time filter
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Key Metrics Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.8,
              children: [
                _buildMetricTile(
                  title: 'Response Time',
                  value: '1.2s',
                  trend: '+0.1s',
                  isUp: false,
                  icon: Icons.speed,
                  color: Colors.blue,
                ),
                _buildMetricTile(
                  title: 'Accuracy Rate',
                  value: '95.8%',
                  trend: '+2.3%',
                  isUp: true,
                  icon: Icons.precision_manufacturing,
                  color: Colors.green,
                ),
                _buildMetricTile(
                  title: 'Resolution Rate',
                  value: '88.5%',
                  trend: '+1.5%',
                  isUp: true,
                  icon: Icons.check_circle,
                  color: Colors.orange,
                ),
                _buildMetricTile(
                  title: 'User Satisfaction',
                  value: '4.8/5',
                  trend: '+0.2',
                  isUp: true,
                  icon: Icons.sentiment_satisfied_alt,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Performance Chart
            SizedBox(
              height: 200,
              child: AnimatedChart(
                title: 'Hourly Performance',
                color: Colors.blue,
                spots: [
                  const FlSpot(0, 92),
                  const FlSpot(4, 94),
                  const FlSpot(8, 96),
                  const FlSpot(12, 95),
                  const FlSpot(16, 93),
                  const FlSpot(20, 97),
                  const FlSpot(24, 95),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Additional Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricIndicator(
                    label: 'Handled Requests',
                    value: '1,234',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildMetricIndicator(
                    label: 'Escalations',
                    value: '45',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildMetricIndicator(
                    label: 'Avg. Handle Time',
                    value: '2m 34s',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String trend,
    required bool isUp,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: isUp ? Colors.green : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  trend,
                  style: TextStyle(
                    color: isUp ? Colors.green : Colors.red,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricIndicator({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSalesOrdersPanel(BuildContext context) {
    final salesData = [
      ChartSectionData(
        title: 'Completed',
        value: 145,
        color: Colors.green.shade400,
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AnimatedPieChart(
                      data: salesData,
                      title: '',
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                child: Text(item.title),
                              ),
                              Text(
                                '${item.value}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 48, color: color),
                    const SizedBox(height: 16),
                    Text('Current: $value'),
                    Text('Previous: ${(double.parse(value.replaceAll(RegExp(r'[^0-9.]'), '')) * 0.9).toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    const Text('Tap to see more details'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    final List<TodoItem> todos = [
      TodoItem(
        title: 'Follow up with Customer #123',
        priority: 'High',
        dueTime: DateTime.now().add(const Duration(hours: 2)),
        category: 'Customer Support',
      ),
      TodoItem(
        title: 'Review weekly sales report',
        priority: 'Medium',
        dueTime: DateTime.now().add(const Duration(hours: 4)),
        category: 'Analytics',
      ),
      TodoItem(
        title: 'Team meeting - Sprint Planning',
        priority: 'High',
        dueTime: DateTime.now().add(const Duration(hours: 1)),
        category: 'Meetings',
      ),
      TodoItem(
        title: 'Update customer database',
        priority: 'Low',
        dueTime: DateTime.now().add(const Duration(hours: 6)),
        category: 'Admin',
      ),
      TodoItem(
        title: 'Prepare AI performance report',
        priority: 'Medium',
        dueTime: DateTime.now().add(const Duration(hours: 5)),
        category: 'Analytics',
      ),
    ];

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks (${todos.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Task'),
                  onPressed: () {
                    // Implement add task functionality
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return _buildTodoItem(todo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(TodoItem todo) {
    return ListTile(
      leading: Checkbox(
        value: false,
        onChanged: (bool? value) {
          // Implement checkbox functionality
        },
      ),
      title: Text(
        todo.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          _buildPriorityChip(todo.priority),
          const SizedBox(width: 8),
          Icon(
            Icons.access_time,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            _formatDueTime(todo.dueTime),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          // Implement menu actions
        },
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    final color = switch (priority) {
      'High' => Colors.red[100]!,
      'Medium' => Colors.orange[100]!,
      _ => Colors.green[100]!,
    };

    final textColor = switch (priority) {
      'High' => Colors.red[900]!,
      'Medium' => Colors.orange[900]!,
      _ => Colors.green[900]!,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDueTime(DateTime dueTime) {
    final now = DateTime.now();
    final difference = dueTime.difference(now);

    if (difference.inHours < 24) {
      return 'Due in ${difference.inHours}h';
    } else {
      return 'Due in ${difference.inDays}d';
    }
  }

  void _showDetailDialog(BuildContext context, String title) {
    switch (title) {
      case 'Active Chats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ActiveChatsScreen()),
        );
      case 'Pending Requests':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PendingRequestsScreen()),
        );
      case 'Today\'s Sales':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SalesOverviewScreen()),
        );
      case 'AI Response Rate':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AIPerformanceScreen()),
        );
    }
  }
}

class RightPanelContent extends StatelessWidget {
  const RightPanelContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActions(),
          const SizedBox(height: 16),
          const Text(
            'AI Suggestions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildAISuggestions(),
          const SizedBox(height: 16),
          const Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildRecentActivities(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildActionButton('Resolve', Icons.check_circle),
        _buildActionButton('Transfer', Icons.call_merge),
        _buildActionButton('Escalate', Icons.warning),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildAISuggestions() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: Text('AI Suggestion ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Add action for suggestion
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentActivities() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text(
              'Activity ${index + 1}',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${30 - index} minutes ago',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

// Add this class at the top of the file or in a separate model file
class TodoItem {
  final String title;
  final String priority;
  final DateTime dueTime;
  final String category;

  const TodoItem({
    required this.title,
    required this.priority,
    required this.dueTime,
    required this.category,
  });
}