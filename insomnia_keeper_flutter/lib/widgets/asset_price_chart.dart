import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PriceChart extends HookWidget{
  final Color lineColor;
  final List<FlSpot>? data;

  const PriceChart({
    required this.lineColor,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      lineChartData,
      swapAnimationDuration: Duration(milliseconds: 250),
    );
  }

  LineChartData get lineChartData => LineChartData(
    lineTouchData: lineTouchData, // Customize touch points
    gridData: gridData, // Customize grid
    titlesData: titlesData, // Customize axis labels
    borderData: borderData, // Customize border
    lineBarsData: [
      lineChartBarData,
    ],
  );

  LineTouchData get lineTouchData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.black.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData => FlTitlesData(
    bottomTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    leftTitles: SideTitles(showTitles: false),
  );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(show: false);

  LineChartBarData get lineChartBarData => LineChartBarData(
    isCurved: true,
    colors: [this.lineColor],
    barWidth: 2,
    dotData: FlDotData(show: false),
    spots: data ?? PriceChart.generateSampleData(),
    belowBarData: BarAreaData(
      show: true,
      colors: [
        this.lineColor.withAlpha(50),
      ],
    ),
  );

  static List<FlSpot> generateSampleData() {
    final List<FlSpot> result = [];
    final numPoints = 20;
    final maxY = 6;

    double prev = 0;

    for (int i = 0; i < numPoints; i++) {
      final next = prev +
          Random().nextInt(3).toDouble() % -1000 * i +
          Random().nextDouble() * maxY / 10;

      prev = next;

      result.add(
        FlSpot(i.toDouble(), next),
      );
    }

    return result;
  }
  
}