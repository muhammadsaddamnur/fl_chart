import 'package:dartx/dartx.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 22;
  static const shadowOpacity = 0.2;
  static const mainItems = <int, List<double>>{
    0: [15],
    1: [-1.8],
    2: [1.5],
    3: [1.5],
    4: [-2],
    5: [-1.2],
    6: [1.2],
    7: [1.2],
    8: [1.2],
    9: [-1.8],
    10: [-1.8],
    11: [-1.8],
    12: [-1.8],
    13: [1.2],
  };

  final lineCharts = [
    const FlSpot(0, 15),
    const FlSpot(1, -1.8),
    const FlSpot(2, 1.5),
    // const FlSpot(3, 1.5),
    const FlSpot(4, -2),
    // const FlSpot(5, -1.2),
    const FlSpot(6, 10),
    const FlSpot(10, 10),
  ];

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  // Widget topTitles(double value, TitleMeta meta) {
  //   const style = TextStyle(color: Colors.white, fontSize: 10);
  //   String text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = 'Mon';
  //       break;
  //     case 1:
  //       text = 'Tue';
  //       break;
  //     case 2:
  //       text = 'Wed';
  //       break;
  //     case 3:
  //       text = 'Thu';
  //       break;
  //     case 4:
  //       text = 'Fri';
  //       break;
  //     case 5:
  //       text = 'Sat';
  //       break;
  //     case 6:
  //       text = 'Sun';
  //       break;
  //     default:
  //       return Container();
  //   }
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: Text(text, style: style),
  //   );
  // }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}';
    }
    return SideTitleWidget(
      // angle: AppUtils().degreeToRadian(value < 0 ? -45 : 45),
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget rightTitles(double value, TitleMeta meta) {
  //   const style = TextStyle(color: Colors.white, fontSize: 10);
  //   String text;
  //   if (value == 0) {
  //     text = '0';
  //   } else {
  //     text = '${value.toInt()}0k';
  //   }
  //   return SideTitleWidget(
  //     angle: AppUtils().degreeToRadian(90),
  //     axisSide: meta.axisSide,
  //     space: 0,
  //     child: Text(
  //       text,
  //       style: style,
  //       textAlign: TextAlign.center,
  //     ),
  //   );
  // }

  BarChartGroupData generateGroup(
    int x,
    double value1,
  ) {
    final isTop = value1 > 0;
    final sum = value1;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: 10,
          borderRadius: isTop
              ? const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
          rodStackItems: [
            // BarChartRodStackItem(
            //   0,
            //   value1,
            //   AppColors.contentColorGreen,
            //   BorderSide(
            //     color: Colors.white,
            //     width: isTouched ? 2 : 0,
            //   ),
            // ),
            // BarChartRodStackItem(
            //   value1,
            //   value1 + value2,
            //   AppColors.contentColorYellow,
            //   BorderSide(
            //     color: Colors.white,
            //     width: isTouched ? 2 : 0,
            //   ),
            // ),
            // BarChartRodStackItem(
            //   value1 + value2,
            //   value1 + value2 + value3,
            //   AppColors.contentColorPink,
            //   BorderSide(
            //     color: Colors.white,
            //     width: isTouched ? 2 : 0,
            //   ),
            // ),
            // BarChartRodStackItem(
            //   value1 + value2 + value3,
            //   value1 + value2 + value3 + value4,
            //   AppColors.contentColorBlue,
            //   BorderSide(
            //     color: Colors.white,
            //     width: isTouched ? 2 : 0,
            //   ),
            // ),
          ],
        ),
        BarChartRodData(
          toY: -sum,
          width: barWidth,
          color: Colors.transparent,
          borderRadius: isTop
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
          rodStackItems: [
            // BarChartRodStackItem(
            //   0,
            //   -value1,
            //   AppColors.contentColorGreen
            //       .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
            //   const BorderSide(color: Colors.transparent),
            // ),
            // BarChartRodStackItem(
            //   -value1,
            //   -(value1 + value2),
            //   AppColors.contentColorYellow
            //       .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
            //   const BorderSide(color: Colors.transparent),
            // ),
            // BarChartRodStackItem(
            //   -(value1 + value2),
            //   -(value1 + value2 + value3),
            //   AppColors.contentColorPink
            //       .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
            //   const BorderSide(color: Colors.transparent),
            // ),
            // BarChartRodStackItem(
            //   -(value1 + value2 + value3),
            //   -(value1 + value2 + value3 + value4),
            //   AppColors.contentColorBlue
            //       .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
            //   const BorderSide(color: Colors.transparent),
            // ),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          customTooltip: (barTooltip) {
            double x = barTooltip?.barGroupIndex.toDouble() ?? 0;
            FlSpot? s = lineCharts.firstOrNullWhere((element) {
              return element.x == x;
            });
            return Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      mainItems[barTooltip?.barGroupIndex].toString(),
                    ),
                    if (s != null)
                      Text(
                        s.y.toString(),
                      ),
                  ],
                ),
              ),
            );
          },
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 15,
            minY: -2,
            groupsSpace: 12,
            lineBarChartData: LineBarChartData(
              color: Colors.green,
              strokeWidth: 2,
              strokeCap: StrokeCap.round,
            ),
            barTouchData: BarTouchData(
              handleBuiltInTouches: false,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  setState(() {
                    touchedIndex = -1;
                  });
                  return;
                }
                final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                if (isShadowBar(rodIndex)) {
                  setState(() {
                    touchedIndex = -1;
                  });
                  return;
                }
                setState(() {
                  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 32,
                  // getTitlesWidget: topTitles,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: bottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitles,
                  interval: 5,
                  reservedSize: 42,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  // getTitlesWidget: rightTitles,
                  interval: 5,
                  reservedSize: 42,
                ),
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (value) => value % 5 == 0,
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                    color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 3,
                  );
                }
                return FlLine(
                  color: AppColors.borderColor.withOpacity(0.05),
                  strokeWidth: 0.8,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            lineCharts: lineCharts,
            barGroups: mainItems.entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    e.value[0],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
