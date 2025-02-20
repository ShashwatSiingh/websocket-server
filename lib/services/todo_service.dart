import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get todos stream for a specific user
  Stream<List<TodoModel>> getTodos(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .orderBy('dueTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TodoModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            });
          }).toList();
        });
  }

  // Add new todo
  Future<void> addTodo(TodoModel todo) async {
    await _firestore
        .collection('users')
        .doc(todo.userId)
        .collection('todos')
        .add(todo.toJson());
  }

  // Update todo
  Future<void> updateTodo(TodoModel todo) async {
    await _firestore
        .collection('users')
        .doc(todo.userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toJson());
  }

  // Delete todo
  Future<void> deleteTodo(String userId, String todoId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }

  // Toggle todo status
  Future<void> toggleTodoStatus(String userId, String todoId, bool isCompleted) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .update({'isCompleted': isCompleted});
  }

  // Get todos by category
  Stream<List<TodoModel>> getTodosByCategory(String userId, String category) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .where('category', isEqualTo: category)
        .orderBy('dueTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TodoModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  // Get todos by priority
  Stream<List<TodoModel>> getTodosByPriority(String userId, String priority) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .where('priority', isEqualTo: priority)
        .orderBy('dueTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TodoModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }
}