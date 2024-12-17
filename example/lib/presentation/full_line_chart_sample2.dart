import 'package:fl_chart_app/presentation/samples/line/line_chart_sample2.dart';
import 'package:flutter/material.dart';

class FullLineChartSample2 extends StatelessWidget {
  const FullLineChartSample2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: LineChartSample2(),
      ),
    );
  }
}
