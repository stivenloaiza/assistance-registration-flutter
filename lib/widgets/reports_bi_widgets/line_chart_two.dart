import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChart2 extends StatefulWidget {
  final List<double> data;
  final List<dynamic> ref;

  const LineChart2({required this.data, required this.ref, super.key});

  @override
  State<LineChart2> createState() => _LineChart2State();
}

class _LineChart2State extends State<LineChart2> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLegend(),
        const SizedBox(height: 8),
        Stack(
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
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem('A', 'Ausencias'),
          const SizedBox(width: 16),
          _legendItem('T', 'A tiempo'),
          const SizedBox(width: 16),
          _legendItem('R', 'Retraso'),
        ],
      ),
    );
  }

  Widget _legendItem(String letter, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey, // Color del círculo
          child: Text(
            letter,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
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
    // Mapear valores específicos a etiquetas
    final Map<int, String> labels = {
      1: 'A',
      2: 'R',
      3: 'T',
    };

    final String? label = labels[value.toInt()];

    // Mostrar solo si hay etiqueta definida
    if (label != null) {
      return Text(
        label,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.left,
      );
    }
    return const SizedBox.shrink(); // Si está en 0 o no hay etiqueta
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
            interval: 1, // Cambiamos el intervalo al rango deseado
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
      maxY: 4, // Rango ajustado al nuevo sistema de etiquetas
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.data.length,
            (index) => FlSpot(index.toDouble(), widget.data[index]),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Colors.orange,
              Colors.red,
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
                  Colors.orange.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
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
            interval: 1, // Misma lógica de etiquetas
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
              Colors.orange,
              Colors.red,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          barWidth: 2,
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
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
      maxY: 4,
    );
  }
}

