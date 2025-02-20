class RequestModel {
  final String id;
  final String customerId;
  final String customerName;
  final String type;
  final String status;
  final String priority;
  final DateTime createdAt;
  final String description;
  final String? assignedTo;
  final List<RequestUpdate> updates;

  const RequestModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.type,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.description,
    this.assignedTo,
    required this.updates,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'type': type,
    'status': status,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'description': description,
    'assignedTo': assignedTo,
    'updates': updates.map((u) => u.toJson()).toList(),
  };

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json['id'],
    customerId: json['customerId'],
    customerName: json['customerName'],
    type: json['type'],
    status: json['status'],
    priority: json['priority'],
    createdAt: DateTime.parse(json['createdAt']),
    description: json['description'],
    assignedTo: json['assignedTo'],
    updates: (json['updates'] as List)
        .map((u) => RequestUpdate.fromJson(u))
        .toList(),
  );
}

class RequestUpdate {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;

  const RequestUpdate({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory RequestUpdate.fromJson(Map<String, dynamic> json) => RequestUpdate(
    id: json['id'],
    userId: json['userId'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}