import 'package:flutter/material.dart';

class ChatItem {
  final String customerName;
  final String lastMessage;
  final String time;
  final bool isActive;

  const ChatItem({
    required this.customerName,
    required this.lastMessage,
    required this.time,
    this.isActive = true,
  });
}

class ActiveChatsScreen extends StatelessWidget {
  const ActiveChatsScreen({super.key});

  static final List<ChatItem> chats = [
    ChatItem(
      customerName: 'John Doe',
      lastMessage: 'I need help with my order #1234',
      time: '2m ago',
    ),
    ChatItem(
      customerName: 'Alice Smith',
      lastMessage: 'When will my order arrive?',
      time: '5m ago',
    ),
    // Add more chat items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Chats'),
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
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(chat.customerName[0]),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      chat.customerName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (chat.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(chat.lastMessage),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(chat.time),
                  const SizedBox(height: 4),
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                ],
              ),
              onTap: () {
                // Navigate to chat detail screen
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Start new chat
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}