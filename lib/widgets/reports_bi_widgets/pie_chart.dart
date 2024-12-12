import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatefulWidget {
  final List<PieData> data;
  final String chartTitle;

  const CustomPieChart({
    Key? key,
    required this.data,
    required this.chartTitle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final totalValue = widget.data.fold<double>(
        0, (previousValue, element) => previousValue + element.pieValue);

    final hasMissingPercentage = totalValue < 100;

    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.chartTitle,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(181, 181, 181, 1),
              ),
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: _generateSections(
                              totalValue, hasMissingPercentage),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...widget.data.asMap().entries.map((entry) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 30.0),
                            child: _buildIndicator(entry.value),
                          );
                        }).toList(),
                        if (hasMissingPercentage)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 30.0),
                            child: _buildIndicator(PieData(
                              pieTitle: 'None',
                              pieValue: 100 - totalValue,
                              color: Colors.grey,
                            )),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  List<PieChartSectionData> _generateSections(
      double totalValue, bool hasMissingPercentage) {
    final sections = widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 70.0 : 50.0;

      return PieChartSectionData(
        color: data.color,
        value: data.pieValue,
        title: '${((data.pieValue / 100) * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    if (hasMissingPercentage) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value: 100 - totalValue,
        title: '${(100 - totalValue).toStringAsFixed(1)}%',
        radius: touchedIndex == widget.data.length ? 70.0 : 50.0,
        titleStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return sections;
  }

  Widget _buildIndicator(PieData data) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: data.color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          data.pieTitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class PieData {
  final String pieTitle;
  final double pieValue;
  final Color color;

  PieData({
    required this.pieTitle,
    required this.pieValue,
    required this.color,
  });
}
