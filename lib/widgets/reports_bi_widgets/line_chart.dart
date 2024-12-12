import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final List<double> data;
  final List<String> ref;

  const CustomLineChart({required this.data, required this.ref, super.key});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              showAvg ? "Hide Avg" : "Show Avg",
              style: const TextStyle(fontSize: 12, color: Colors.indigo),
            ),
          ),
        ),
      ],
    );
  }

  double get maxX => widget.data.length - 1;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // Mostrar títulos solo si están definidos en 'ref'
    if (value.toInt() >= 0 && value.toInt() < widget.ref.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(widget.ref[value.toInt()], style: style),
      );
    }
    return const SizedBox.shrink();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(fontSize: 12),
      textAlign: TextAlign.left,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20, // Intervalos fijos para que se adapte a 100 como máximo
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 32,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: 100, // Máximo del eje Y fijo a 100
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.data.length,
            (index) => FlSpot(index.toDouble(), widget.data[index]),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Colors.lime,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.lime.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(),
      ),
    );
  }

  LineChartData avgData() {
    final average =
        widget.data.reduce((a, b) => a + b) / widget.data.length.toDouble();

    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 32,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.data.length,
            (index) => FlSpot(index.toDouble(), average),
          ),
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              Colors.lime,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          barWidth: 2,
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.lime.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
      ],
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: 100,
    );
  }
}
