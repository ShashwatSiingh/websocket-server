import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';
import '../services/local_storage_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  final LocalStorageService _localStorage = LocalStorageService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<TodoModel> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize todos stream
  void initTodos() async {
    if (userId.isEmpty) return;

    // First load from local storage
    _todos = await _localStorage.loadTodos(userId);
    notifyListeners();

    // Then listen to Firestore updates
    _todoService.getTodos(userId).listen(
      (todos) {
        _todos = todos;
        // Save to local storage whenever Firestore updates
        _localStorage.saveTodos(todos);
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Add new todo
  Future<void> addTodo({
    required String title,
    required String priority,
    required DateTime dueTime,
    required String category,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final todo = TodoModel(
        userId: userId,
        title: title,
        priority: priority,
        dueTime: dueTime,
        category: category,
      );

      await _todoService.addTodo(todo);

      // Update local storage
      _todos.add(todo);
      await _localStorage.saveTodos(_todos);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update todo
  Future<void> updateTodo(TodoModel todo) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _todoService.updateTodo(todo);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _todoService.deleteTodo(userId, todoId);

      // Update local storage
      _todos.removeWhere((todo) => todo.id == todoId);
      await _localStorage.saveTodos(_todos);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle todo status
  Future<void> toggleTodoStatus(String todoId, bool isCompleted) async {
    try {
      await _todoService.toggleTodoStatus(userId, todoId, isCompleted);

      // Update local storage
      final index = _todos.indexWhere((todo) => todo.id == todoId);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(isCompleted: isCompleted);
        await _localStorage.saveTodos(_todos);
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear local storage when signing out
  Future<void> clearLocalData() async {
    await _localStorage.clearTodos();
  }

  void updateTodos() {
    // Update todos
    notifyListeners();
  }
}