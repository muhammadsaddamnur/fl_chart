import 'dart:math';

import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Customizable, theme-aware "Avg. Buy" pill label.
/// Colors default from the current [Brightness]; every color is overridable.
class AvgBuyPill extends StatelessWidget {
  const AvgBuyPill({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.borderColor,
    this.labelColor,
    this.valueColor,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final String label;
  final String value;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? labelColor;
  final Color? valueColor;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? Colors.black : Colors.white);
    final border = borderColor ?? AppColors.contentColorCyan;
    final labelC = labelColor ?? (isDark ? Colors.white : Colors.black);
    final valueC = valueColor ?? AppColors.contentColorCyan;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 1),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(color: labelC, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: valueC, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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

  // Trade data (external — NOT derived from the chart spots).
  // The Y axis spans [axisLow, axisHigh]; the pill/line sit at avgBuyValue's
  // ratio within that range, e.g. 12 in [0,20] -> 60% up the plot.
  static const double axisHigh = 19; // top-right label
  static const double axisLow = 0; // bottom-right label
  static const double avgBuyValue = 1; // "Avg. Buy" from trade data

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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
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
                  // Avg. Buy dashed line + pill AND the high/low axis labels are
                  // all drawn by the library now (see mainData: extraLinesData +
                  // rightTitles). No manual overlay/positioning.
                  child: _chart(),
                ),
              ),
              // 'avg' toggle overlay, top-left of the chart.
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
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
                        color: showAvg
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    var random = Random().nextInt(3);

                    FlSpot spot = FlSpot(spots.last.x + 1, spots.last.x + 1,
                        isBuy: true, isSell: true);
                    if (random == 1) {
                      spot = FlSpot(spots.last.x + 1, spots.last.y - 1,
                          isSell: true);
                    } else if (random == 2) {
                      spot = FlSpot(spots.last.x + 1, spots.last.y + 1,
                          isBuy: true);
                    }
                    spots.add(spot);
                    setState(() {});
                  },
                  child: Text('Add item')),
              const SizedBox(width: 12),
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
        ],
      ),
    );
  }

  // Formats a value with thousands separators, e.g. 82428 -> "82,428".
  String _fmt(double v) {
    final digits = v.round().abs().toString();
    final buf = StringBuffer(v < 0 ? '-' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  Widget _chart() {
    return LineChart(
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

  // Built-in right-axis labels: show the trade high at the top tick (maxY) and
  // the trade low at the bottom tick (minY). fl_chart handles positioning.
  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white70,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    String text;
    if ((value - meta.max).abs() < 0.001) {
      text = _fmt(axisHigh);
    } else if ((value - meta.min).abs() < 0.001) {
      text = _fmt(axisLow);
    } else {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  LineChartData mainData() {
    double? minX, maxX, minY, maxY;
    for (var element in spots) {
      minX = minX == null ? element.x : min(minX, element.x);
      maxX = maxX == null ? element.x : max(maxX, element.x);
      minY = minY == null ? element.y : min(minY, element.y);
      maxY = maxY == null ? element.y : max(maxY, element.y);
    }
    // Chart Y domain (padded, same as minY/maxY below).
    final chartMinY = (minY ?? 0) - 1;
    final chartMaxY = (maxY ?? 0) + 1;
    // Map the external trade value onto the chart's Y domain, so the library
    // places the line at avgBuyValue's ratio within [axisLow, axisHigh].
    final valueRatio = ((avgBuyValue - axisLow) / (axisHigh - axisLow))
        .clamp(0.0, 1.0)
        .toDouble();
    final avgChartY = chartMinY + valueRatio * (chartMaxY - chartMinY);

    return LineChartData(
      // Avg. Buy dashed line + pill are a LIBRARY feature now: the line is drawn
      // by fl_chart and the pill widget is positioned on it by the chart's own
      // axis transform (labelWidgetBuilder) -> exact alignment, zero manual math.
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: avgChartY,
            color: AppColors.contentColorCyan,
            strokeWidth: 2,
            dashArray: const [8, 6],
            labelWidgetBuilder: (line) => AvgBuyPill(
              label: 'Avg. Buy',
              value: _fmt(avgBuyValue),
            ),
          ),
        ],
      ),
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
        show: true,
        // High/low labels via the built-in right axis: fl_chart positions them
        // at the top (maxY) and bottom (minY) ticks. interval == full range so
        // only those two ticks appear.
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: (chartMaxY - chartMinY) <= 0 ? 1 : (chartMaxY - chartMinY),
            getTitlesWidget: rightTitleWidgets,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
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
