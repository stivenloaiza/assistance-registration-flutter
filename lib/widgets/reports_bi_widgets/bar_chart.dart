import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  final String chartTitle;
  final List<ChartData> data;
  final Map<String, String> ref;
  final Color backgroundColor;

  BarChartWidget({
    super.key,
    required this.chartTitle,
    required this.data,
    required this.ref,
    this.backgroundColor = Colors.white,
  });

  // Definir los colores como variables de instancia
  final Color firstBarColor = Colors.red;
  final Color secondBarColor = Colors.green;
  final Color thirdBarColor = Colors.orange;
  final Color avgColor = Colors.grey;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final double barWidth = 7;
  late List<BarChartGroupData> barGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;
  bool isLoading = true; // Variable para manejar el estado de carga

  @override
  void initState() {
    super.initState();
    // Simulando un retraso en la carga de los datos (esto debe reemplazarse con tu lógica real de carga de datos)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        barGroups = widget.data.asMap().entries.map((entry) {
          final index = entry.key;
          final chartData = entry.value;
          return makeGroupData(index, chartData.numberFirstValue,
              chartData.numberSecondValue ?? 0, chartData.numberThirdValue ?? 0);
        }).toList();
        showingBarGroups = List.of(barGroups);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double roundUpToNextMultipleOfFive(double value) {
      return (value / 5).ceil() * 5;
    }

    final maxY = roundUpToNextMultipleOfFive(widget.data.fold<double>(
      0,
          (previousMax, element) => [
        element.numberFirstValue,
        element.numberSecondValue ?? 0,
        element.numberThirdValue ?? 0,
      ].reduce((a, b) => a > b ? a : b).clamp(previousMax, double.infinity),
    ));

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              widget.chartTitle,
              style: const TextStyle(
                color: Color.fromRGBO(181, 181, 181, 1),
                fontSize: 22,
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(),
            const SizedBox(height: 40),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(), // Indicador de carga
              )
                  : BarChart(
                BarChartData(
                  minY: 0,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) =>
                      const Color.fromRGBO(181, 181, 181, 1),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final chartData = widget.data[group.x.toInt()];
                        print("sss $chartData");
                        return BarTooltipItem(
                          'Avg: ${chartData.average.toStringAsFixed(1)}\n',
                          const TextStyle(
                            color: Color.fromRGBO(92, 92, 92, 1),
                            fontSize: 14,
                            fontFamily: 'Helvetica',
                          ),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(barGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(barGroups);
                          return;
                        }
                        showingBarGroups = List.of(barGroups);
                        if (touchedGroupIndex != -1) {
                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                                barRods: showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                    toY: widget.data[touchedGroupIndex].average,
                                    color: widget.avgColor,
                                  );
                                }).toList(),
                              );
                        }
                      });
                    },
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
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < widget.data.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 16,
                              child: Text(
                                widget.data[value.toInt()].barTitle,
                                style: const TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Color.fromRGBO(181, 181, 181, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                        reservedSize: 28,
                        interval: maxY > 0 ? maxY / 5 : 1,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 0,
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Color.fromRGBO(181, 181, 181, 1),
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    horizontalInterval: 20,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _legendItem(widget.firstBarColor, widget.ref['titleFirstValue']!),
            if (widget.ref['titleSecondValue'] != null)
              _legendItem(widget.secondBarColor, widget.ref['titleSecondValue']!),
            if (widget.ref['titleThirdValue'] != null)
              _legendItem(widget.thirdBarColor, widget.ref['titleThirdValue']!),
          ],
        ));
  }

  Widget _legendItem(Color color, String title) {
    return Row(
      children: [
        const SizedBox(width: 5),
        CircleAvatar(radius: 8, backgroundColor: color),
        const SizedBox(width: 5),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.firstBarColor,
          width: barWidth,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.secondBarColor,
          width: barWidth,
        ),
        BarChartRodData(
          toY: y3,
          color: widget.thirdBarColor,
          width: barWidth,
        ),
      ],
    );
  }
}

class ChartData {
  final String barTitle;
  final double numberFirstValue;
  final double? numberSecondValue;
  final double? numberThirdValue;
  final double average;

  ChartData({
    required this.barTitle,
    required this.numberFirstValue,
    this.numberSecondValue,
    this.numberThirdValue,
  }) : average = (numberFirstValue + (numberSecondValue ?? 0) + (numberThirdValue ?? 0)) / 3;
}
