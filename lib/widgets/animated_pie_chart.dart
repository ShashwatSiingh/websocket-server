import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/chart_section_data.dart';

class AnimatedPieChart extends StatelessWidget {
  final List<ChartSectionData> data;
  final String title;

  const AnimatedPieChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return PieChart(
      PieChartData(
        sections: data.map((item) {
          final percentage = (item.value / total) * 100;
          return PieChartSectionData(
            value: item.value,
            title: '${percentage.toStringAsFixed(1)}%',
            color: item.color,
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }
}