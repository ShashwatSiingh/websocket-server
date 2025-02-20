import 'package:flutter/material.dart';
import '../models/call_interaction.dart';
import '../widgets/call_card.dart';
import 'package:intl/intl.dart';
import '../services/call_handler_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ai_call_service.dart';

class LiveInteractionsScreen extends StatefulWidget {
  const LiveInteractionsScreen({super.key});

  @override
  State<LiveInteractionsScreen> createState() => _LiveInteractionsScreenState();
}

class _LiveInteractionsScreenState extends State<LiveInteractionsScreen> {
  final List<CallInteraction> _activeCalls = [
    CallInteraction(
      id: '1',
      customerName: 'John Doe',
      customerImage: 'https://i.pravatar.cc/150?img=1',
      startTime: DateTime.now().subtract(const Duration(minutes: 15)),
      status: 'In Progress',
      agentName: 'AI Agent 1',
      duration: 15,
      topic: 'Product Inquiry',
      satisfaction: 4.5,
    ),
    CallInteraction(
      id: '2',
      customerName: 'Jane Smith',
      customerImage: 'https://i.pravatar.cc/150?img=2',
      startTime: DateTime.now().subtract(const Duration(minutes: 5)),
      status: 'Waiting',
      agentName: 'AI Agent 2',
      duration: 5,
      topic: 'Technical Support',
      satisfaction: 4.0,
    ),
    // Add more mock data as needed
  ];

  String _selectedFilter = 'All';
  final CallHandlerService _callHandler = CallHandlerService();
  final AiCallService _aiCallService = AiCallService();

  @override
  void initState() {
    super.initState();
    _initializeCallHandling();
  }

  Future<void> _initializeCallHandling() async {
    try {
      await _aiCallService.initializeOpenAI();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing AI call service: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _aiCallService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Interactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatistics(),
          Expanded(
            child: _buildCallsList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _testAICall,
            heroTag: 'ai_test',
            child: const Icon(Icons.smart_toy), // Robot icon for AI
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _initiateCustomerCareCall,
            heroTag: 'call',
            child: const Icon(Icons.call),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showNewCallDialog,
            heroTag: 'add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            'Active Calls',
            _activeCalls
                .where((call) => call.status == 'In Progress')
                .length
                .toString(),
            Icons.phone_in_talk,
            Colors.green,
          ),
          _buildStatCard(
            'Waiting',
            _activeCalls
                .where((call) => call.status == 'Waiting')
                .length
                .toString(),
            Icons.hourglass_empty,
            Colors.orange,
          ),
          _buildStatCard(
            'Avg. Duration',
            '${_calculateAverageDuration()} min',
            Icons.timer,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallsList() {
    final filteredCalls = _selectedFilter == 'All'
        ? _activeCalls
        : _activeCalls.where((call) => call.status == _selectedFilter).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredCalls.length,
      itemBuilder: (context, index) {
        return CallCard(call: filteredCalls[index]);
      },
    );
  }

  double _calculateAverageDuration() {
    if (_activeCalls.isEmpty) return 0;
    final total = _activeCalls.fold(0, (sum, call) => sum + call.duration);
    return total / _activeCalls.length;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Calls'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text('All'),
                value: 'All',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value.toString());
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text('In Progress'),
                value: 'In Progress',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value.toString());
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text('Waiting'),
                value: 'Waiting',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value.toString());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewCallDialog() {
    final nameController = TextEditingController();
    final topicController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Call'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Enter customer name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                hintText: 'Enter call topic',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  topicController.text.trim().isEmpty) return;

              // Add new call to the list
              setState(() {
                _activeCalls.add(
                  CallInteraction(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    customerName: nameController.text,
                    customerImage:
                        'https://i.pravatar.cc/150?img=${_activeCalls.length + 1}',
                    startTime: DateTime.now(),
                    status: 'Waiting',
                    agentName: 'AI Agent ${_activeCalls.length + 1}',
                    duration: 0,
                    topic: topicController.text,
                    satisfaction: 0.0,
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Start Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _initiateCustomerCareCall() async {
    try {
      // Request phone call permission
      final status = await Permission.phone.request();
      if (status.isGranted) {
        final customerCareNumber = await _callHandler.getCustomerCareNumber();
        await _callHandler.makePhoneCall(customerCareNumber);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone permission is required to make calls'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  }

  Future<void> _testAICall() async {
    try {
      await _callHandler.testAICall();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
