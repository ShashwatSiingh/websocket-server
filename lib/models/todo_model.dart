import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String? id;
  final String userId;
  final String title;
  final String priority;
  final DateTime dueTime;
  final String category;
  final bool isCompleted;

  TodoModel({
    this.id,
    required this.userId,
    required this.title,
    required this.priority,
    required this.dueTime,
    required this.category,
    this.isCompleted = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      priority: json['priority'],
      dueTime: (json['dueTime'] as Timestamp).toDate(),
      category: json['category'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // New method for local storage JSON
  factory TodoModel.fromLocalJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      priority: json['priority'],
      dueTime: DateTime.parse(json['dueTime']),
      category: json['category'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'priority': priority,
      'dueTime': Timestamp.fromDate(dueTime),
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  // New method for local storage JSON
  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'priority': priority,
      'dueTime': dueTime.toIso8601String(),
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? priority,
    DateTime? dueTime,
    String? category,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      dueTime: dueTime ?? this.dueTime,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}