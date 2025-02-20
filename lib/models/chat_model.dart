class ChatModel {
  final String id;
  final String customerId;
  final String customerName;
  final String status;
  final DateTime startTime;
  final DateTime? endTime;
  final List<Message> messages;
  final String assignedTo;
  final bool isAIHandled;

  const ChatModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.messages,
    required this.assignedTo,
    required this.isAIHandled,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'status': status,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'messages': messages.map((m) => m.toJson()).toList(),
    'assignedTo': assignedTo,
    'isAIHandled': isAIHandled,
  };

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id'],
    customerId: json['customerId'],
    customerName: json['customerName'],
    status: json['status'],
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    messages: (json['messages'] as List)
        .map((m) => Message.fromJson(m))
        .toList(),
    assignedTo: json['assignedTo'],
    isAIHandled: json['isAIHandled'],
  );
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String type;

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    senderId: json['senderId'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
  );
}