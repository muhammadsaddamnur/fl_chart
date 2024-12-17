import 'dart:math';

import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    spots = [
      FlSpot(0, 3, isBuy: true, isSell: true),
      FlSpot(2.6, 2, isSell: true),
      FlSpot(4.9, 5, isBuy: true),
      FlSpot(6.8, 3.1, isSell: true),
      FlSpot(8, 4, isBuy: true),
      FlSpot(9.5, 3, isBuy: true, isSell: true),
      FlSpot(11, 4, isSell: true),
      FlSpot(11, 6, isSell: true),
      FlSpot(13, 5, isBuy: true),
      FlSpot(14.5, 4.5, isSell: true),
      FlSpot(16, 6, isBuy: true, isSell: true),
      FlSpot(17.5, 5.5, isSell: true),
      FlSpot(19, 7, isBuy: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 12,
              left: 12,
              // top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
              markerStyle: const MarkerStyle(
                isShowBuyMarks: true,
                isShowSellMarks: true,
                // markerSize: 16,
                buyMarkMargin: 16,
                sellMarkMargin: 20,
              ),
              customTooltip: ((lineBarSpots) {
                print('ssss $lineBarSpots');
                if (lineBarSpots == null) {
                  return Container();
                }

                if (lineBarSpots.isEmpty) {
                  return Container();
                }

                final lineBarSpot = lineBarSpots.first;

                if (true) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.contentColorBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Buy: \$${lineBarSpot.y.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else if (lineBarSpot.isSell) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.contentColorCyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sell: \$${lineBarSpot.y.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                return Container();
              }),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    var random = Random().nextInt(2);

                    FlSpot spot = FlSpot(spots.last.x + 1, spots.last.x + 1,
                        isBuy: true, isSell: true);
                    if (random == 1) {
                      spot =
                          FlSpot(spots.last.x, spots.last.y + 1, isSell: true);
                    } else if (random == 0) {
                      spot =
                          FlSpot(spots.last.x, spots.last.y + 1, isBuy: true);
                    }
                    spots.add(spot);
                    setState(() {});
                  },
                  child: Text('Add item')),
              ElevatedButton(
                  onPressed: () {
                    spots.clear();
                    spots.addAll([
                      FlSpot(0, 3, isBuy: true, isSell: true),
                      FlSpot(2.6, 2, isSell: true),
                      FlSpot(4.9, 5, isBuy: true),
                      FlSpot(6.8, 3.1, isSell: true),
                      FlSpot(8, 4, isBuy: true),
                      FlSpot(9.5, 3, isBuy: true, isSell: true),
                      FlSpot(11, 4, isSell: true),
                    ]);
                    setState(() {});
                  },
                  child: Text('reset item')),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    double? minX, maxX, minY, maxY;
    for (var element in spots) {
      minX = minX == null ? element.x : min(minX, element.x);
      maxX = maxX == null ? element.x : max(maxX, element.x);
      minY = minY == null ? element.y : min(minY, element.y);
      maxY = maxY == null ? element.y : max(maxY, element.y);
    }
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: minX != null ? (minX - 0.5) : null,
      maxX: maxX != null ? (maxX + 0.5) : null,
      minY: minY != null ? (minY - 1) : null,
      maxY: maxY != null ? (maxY + 1) : null,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
