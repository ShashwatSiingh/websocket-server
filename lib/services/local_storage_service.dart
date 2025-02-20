import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo_model.dart';

class LocalStorageService {
  static const String _todosKey = 'todos';

  // Save todos to local storage
  Future<void> saveTodos(List<TodoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = todos.map((todo) => todo.toLocalJson()).toList();
    await prefs.setString(_todosKey, jsonEncode(todosJson));
  }

  // Load todos from local storage
  Future<List<TodoModel>> loadTodos(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosString = prefs.getString(_todosKey);
      if (todosString == null) return [];

      final todosList = jsonDecode(todosString) as List;
      return todosList
          .map((json) => TodoModel.fromLocalJson({...json, 'userId': userId}))
          .toList();
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }

  // Clear todos from local storage
  Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_todosKey);
  }
}