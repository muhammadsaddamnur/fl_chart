import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
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
    this.lineChartData,
    this.barChartData,
    this.lineChartCustomTooltip,
    this.barChartCustomTooltip,
    this.barTooltip,
  });
  final Widget chart;
  final AxisChartData data;
  final LineChartData? lineChartData;
  final BarChartData? barChartData;
  final Widget Function(List<LineBarSpot>? lineBarSpots)?
      lineChartCustomTooltip;
  final Widget Function(BarTooltip? barTooltip)? barChartCustomTooltip;
  final BarTooltip? barTooltip;

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

  double getPixelX(double spotX, Size viewSize, double maxX, double minX) {
    // final data = holder.data;
    final deltaX = maxX - minX;
    if (deltaX == 0.0) {
      return 0;
    }
    return ((spotX - minX) / deltaX) * viewSize.width;
  }

  double getPixelY(double spotY, Size viewSize, double maxY, double minY) {
    final deltaY = maxY - minY;
    if (deltaY == 0.0) {
      return viewSize.height;
    }
    return viewSize.height - (((spotY - minY) / deltaY) * viewSize.height);
  }

  List<Widget> stackWidgets(
      BoxConstraints constraints, BuildContext context, bool show) {
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

    // final leftMark =

    final widgets = <Widget>[
      // Align(
      //   alignment: Alignment(0, 0),
      //   child: Container(
      //     height: 20,
      //     width: 20,
      //     color: Colors.red,
      //   ),
      // ),
      // Expanded(
      //     child: Container(
      //   color: Colors.blue,
      // )),

      Container(
        margin: widget.data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: widget.data.borderData.isVisible()
              ? widget.data.borderData.border
              : null,
        ),
        child: widget.chart,
      ),
      if ((widget.lineChartData?.showingTooltipIndicators ?? []).isNotEmpty &&
          widget.lineChartCustomTooltip != null) ...[
        Positioned(
          left: left,
          top: top,
          child: Container(
            key: _contentKey,
            margin: widget.data.titlesData.allSidesPadding,
            child: widget.lineChartCustomTooltip!(
              widget.lineChartData!.showingTooltipIndicators.first.showingSpots
                  .map((e) => e)
                  .toList(),
            ),
          ),
        ),
      ],
      if (show)
        if (widget.barTooltip != null &&
            widget.barChartCustomTooltip != null) ...[
          Positioned(
            left: left,
            top: top,
            child: Container(
              key: _contentKey,
              margin: widget.data.titlesData.allSidesPadding,
              child: widget.barChartCustomTooltip!(
                widget.barTooltip,
              ),
            ),
          ),
        ],
      Stack(
        children: List.generate(
          widget.lineChartData?.lineBarsData.first.spots.length ?? 0,
          (index) {
            print(
                'Xs : ${widget.lineChartData?.lineBarsData.first.spots[index].x}');
            final spot = widget.lineChartData?.lineBarsData.first.spots[index];

            var x = getPixelX(
                spot?.x ?? 0,
                Size(
                    backgroundWidth -
                        widget.data.titlesData.allSidesPadding.left,
                    backgroundHeight),
                widget.lineChartData?.maxX ?? 0,
                widget.lineChartData?.minX ?? 0);

            var y = getPixelY(
                spot?.y ?? 0,
                Size(
                  backgroundWidth - widget.data.titlesData.allSidesPadding.left,
                  backgroundHeight -
                      widget.data.titlesData.allSidesPadding.bottom,
                ),
                widget.lineChartData?.maxY ?? 0,
                widget.lineChartData?.minY ?? 0);

            return Positioned(
              left: x + widget.data.titlesData.allSidesPadding.left - 10,
              top: y + (spot?.isSell ?? false ? 10 : -30),
              // alignment: Alignment(x, y),
              child: Container(
                height: 20,
                width: 20,
                color: spot?.isSell ?? false ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      ),
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
        show = true;

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
        show = true;

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
        show = true;
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

  bool show = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        backgroundWidth = constraints.maxWidth;
        backgroundHeight = constraints.maxHeight;
        return widget.lineChartCustomTooltip == null &&
                widget.barChartCustomTooltip == null
            ? Stack(children: stackWidgets(constraints, context, show))
            : Listener(
                onPointerHover: onPointerHover,
                onPointerMove: onPointerMove,
                onPointerDown: onPointerDown,
                onPointerUp: (event) {
                  setState(() {
                    show = !show;
                  });
                },
                child:
                    Stack(children: stackWidgets(constraints, context, show)),
              );
      },
    );
  }
}
