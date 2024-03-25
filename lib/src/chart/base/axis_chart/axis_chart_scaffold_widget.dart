import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A scaffold to show an axis-based chart
///
/// It contains some placeholders to represent an axis-based chart.
///
/// It's something like the below graph:
/// |----------------------|
/// |      |  top  |       |
/// |------|-------|-------|
/// | left | chart | right |
/// |------|-------|-------|
/// |      | bottom|       |
/// |----------------------|
///
/// `left`, `top`, `right`, `bottom` are some place holders to show titles
/// provided by [AxisChartData.titlesData] around the chart
/// `chart` is a centered place holder to show a raw chart.
class AxisChartScaffoldWidget extends StatefulWidget {
  const AxisChartScaffoldWidget({
    super.key,
    required this.chart,
    required this.data,
    this.chartData,
    this.customTooltip,
  });
  final Widget chart;
  final AxisChartData data;
  final LineChartData? chartData;
  final Widget Function(List<LineBarSpot>? lineBarSpots)? customTooltip;

  @override
  State<AxisChartScaffoldWidget> createState() =>
      _AxisChartScaffoldWidgetState();
}

class _AxisChartScaffoldWidgetState extends State<AxisChartScaffoldWidget> {
  bool get showLeftTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  final _contentKey = GlobalKey();
  Offset position = Offset.zero;
  double backgroundHeight = 0;
  double backgroundWidth = 0;
  double tooltipHeight = 0;
  double tooltipWidth = 0;

  List<Widget> stackWidgets(BoxConstraints constraints, BuildContext context) {
    final leftPosition =
        position.dx - widget.data.titlesData.allSidesPadding.left;
    final topPosition =
        position.dy - widget.data.titlesData.allSidesPadding.top;

    final left = leftPosition + tooltipWidth > backgroundWidth
        ? leftPosition -
            tooltipWidth +
            widget.data.titlesData.allSidesPadding.left
        : leftPosition;

    final top = topPosition + tooltipHeight > backgroundHeight
        ? backgroundHeight - tooltipHeight
        : topPosition < 0.0
            ? 0.0
            : topPosition;

    final widgets = <Widget>[
      Container(
        margin: widget.data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: widget.data.borderData.isVisible()
              ? widget.data.borderData.border
              : null,
        ),
        child: widget.chart,
      ),
      if ((widget.chartData?.showingTooltipIndicators ?? []).isNotEmpty &&
          widget.customTooltip != null) ...[
        Positioned(
          left: left,
          top: top,
          child: Container(
            key: _contentKey,
            margin: widget.data.titlesData.allSidesPadding,
            child: widget.customTooltip!(
              widget.chartData!.showingTooltipIndicators.first.showingSpots
                  .map((e) => e)
                  .toList(),
            ),
          ),
        ),
      ]
    ];

    int insertIndex(bool drawBelow) => drawBelow ? 0 : widgets.length;

    if (showLeftTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.leftTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.left,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showTopTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.topTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.top,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.rightTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.right,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.bottomTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.bottom,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
        ),
      );
    }
    return widgets;
  }

  void onPointerHover(PointerHoverEvent event) {
    setState(
      () {
        final box = context.findRenderObject()! as RenderBox;
        final localPosition = box.globalToLocal(event.position);
        position = localPosition;
        getContentSize();
      },
    );
  }

  void onPointerMove(PointerMoveEvent event) {
    setState(
      () {
        final box = context.findRenderObject()! as RenderBox;
        final localPosition = box.globalToLocal(event.position);
        position = localPosition;
        getContentSize();
      },
    );
  }

  void onPointerDown(PointerDownEvent event) {
    setState(
      () {
        final box = context.findRenderObject()! as RenderBox;
        final localPosition = box.globalToLocal(event.position);
        position = localPosition;
        getContentSize();
      },
    );
  }

  void getContentSize() {
    RenderBox? renderBox;
    if (_contentKey.currentContext?.findRenderObject() != null) {
      renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
      tooltipWidth = renderBox?.size.width ?? 0;
      tooltipHeight = renderBox?.size.height ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        backgroundWidth = constraints.maxWidth;
        backgroundHeight = constraints.maxHeight;
        return widget.customTooltip == null
            ? Stack(children: stackWidgets(constraints, context))
            : Listener(
                onPointerHover: onPointerHover,
                onPointerMove: onPointerMove,
                onPointerDown: onPointerDown,
                child: Stack(children: stackWidgets(constraints, context)),
              );
      },
    );
  }
}
