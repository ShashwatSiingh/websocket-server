import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  String _selectedFilter = 'All';
  final List<bool> _todoStatus = List.generate(5, (_) => false);
  bool _isLoading = false;

  String get selectedFilter => _selectedFilter;
  List<bool> get todoStatus => _todoStatus;
  bool get isLoading => _isLoading;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void toggleTodoStatus(int index) {
    _todoStatus[index] = !_todoStatus[index];
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void updateDashboard() {
    // Update dashboard data
    notifyListeners();
  }
}