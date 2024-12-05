import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartSample2 extends StatelessWidget {
  final List<ChartData> data;
  final String chartTitle;
  final Color backgroundColor;
  final Color attendanceColor;
  final Color absenceColor;

  const BarChartSample2({
    Key? key,
    required this.data,
    required this.chartTitle,
    required this.backgroundColor,
    required this.attendanceColor,
    required this.absenceColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxY = data
        .map((e) => e.attendanceNumber + e.absencesNumber)
        .reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        final isLandscape = aspectRatio > 1;
        final fontSize = min(14.0, constraints.maxWidth / 30);

        return Container(
          color: backgroundColor,
          padding: EdgeInsets.all(min(16, constraints.maxWidth / 30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chartTitle,
                    style: TextStyle(
                      color: const Color.fromRGBO(181, 181, 181, 1),
                      fontSize: min(22, constraints.maxWidth / 20),
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  Row(
                    children: [
                      _LegendItem(color: attendanceColor, label: 'Asistencias'),
                      const SizedBox(width: 16),
                      _LegendItem(color: absenceColor, label: 'Inasistencias'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: min(40, constraints.maxHeight / 10)),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final chartData = data[groupIndex];
                          final value = rodIndex == 0 ? chartData.attendanceNumber : chartData.absencesNumber;
                          final label = rodIndex == 0 ? 'Asistencias' : 'Inasistencias';
                          return BarTooltipItem(
                            '${chartData.barTitle}\n$label: ${value.toStringAsFixed(1)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: isLandscape ? 42 : constraints.maxHeight / 8,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < data.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 16,
                                child: Text(
                                  data[value.toInt()].barTitle,
                                  style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    color: const Color.fromRGBO(181, 181, 181, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: isLandscape ? 28 : constraints.maxWidth / 10,
                          interval: maxY / 5,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 0,
                              child: Text(
                                value.toStringAsFixed(0),
                                style: TextStyle(
                                  color: const Color.fromRGBO(181, 181, 181, 1),
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final chartData = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: chartData.attendanceNumber,
                            color: attendanceColor,
                            width: 16,
                          ),
                          BarChartRodData(
                            toY: chartData.absencesNumber,
                            color: absenceColor,
                            width: 16,
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(181, 181, 181, 1),
            fontSize: 12,
            fontFamily: 'Helvetica',
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String barTitle;
  final double attendanceNumber;
  final double absencesNumber;

  ChartData({
    required this.barTitle,
    required this.attendanceNumber,
    required this.absencesNumber,
  });
}

