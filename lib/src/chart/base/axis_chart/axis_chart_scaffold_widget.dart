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
    this.markerStyle,
  });
  final Widget chart;
  final AxisChartData data;
  final LineChartData? lineChartData;
  final BarChartData? barChartData;
  final Widget Function(List<LineBarSpot>? lineBarSpots)?
      lineChartCustomTooltip;
  final Widget Function(BarTooltip? barTooltip)? barChartCustomTooltip;
  final BarTooltip? barTooltip;
  final MarkerStyle? markerStyle;

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
      if ((widget.markerStyle?.isShowBuyMarks ?? false) == false &&
          (widget.markerStyle?.isShowSellMarks ?? false) == false)
        ...[]
      else ...[
        Stack(
          children: List.generate(
            widget.lineChartData?.lineBarsData.first.spots.length ?? 0,
            (index) {
              final spot =
                  widget.lineChartData?.lineBarsData.first.spots[index];
              if (spot == null || spot.isBuy == false && spot.isSell == false) {
                return Container();
              }
              final x = getPixelX(
                spot.x,
                Size(
                  backgroundWidth - widget.data.titlesData.allSidesPadding.left,
                  backgroundHeight,
                ),
                widget.lineChartData?.maxX ?? 0,
                widget.lineChartData?.minX ?? 0,
              );

              final y = getPixelY(
                spot.y,
                Size(
                  backgroundWidth - widget.data.titlesData.allSidesPadding.left,
                  backgroundHeight -
                      widget.data.titlesData.allSidesPadding.bottom,
                ),
                widget.lineChartData?.maxY ?? 0,
                widget.lineChartData?.minY ?? 0,
              );

              return Stack(
                children: [
                  // sell
                  if (spot.isSell &&
                      (widget.markerStyle?.isShowSellMarks ?? false))
                    Positioned(
                      left: x + widget.data.titlesData.allSidesPadding.left,
                      top: y -
                          (widget.markerStyle?.sellMarkMargin ?? 8.0) +
                          (widget.markerStyle?.markerSize ?? 16.0),
                      child: CustomPaint(
                        painter: BubbleTailPainterSell(widget.markerStyle),
                      ),
                    ),
                  if (spot.isBuy &&
                      (widget.markerStyle?.isShowBuyMarks ?? false))
                    Positioned(
                      left: x + widget.data.titlesData.allSidesPadding.left,
                      top: y + (widget.markerStyle?.buyMarkMargin ?? 8.0),
                      child: CustomPaint(
                        painter: BubbleTailPainterBuy(widget.markerStyle),
                      ),
                    ),
                  // buy
                ],
              );
            },
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

class BubbleTailPainterSell extends CustomPainter {
  BubbleTailPainterSell(this.markerStyle);
  final MarkerStyle? markerStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final sellMarkerPaint = Paint()
      ..color = markerStyle?.sellMarkColor ?? Colors.red
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: markerStyle?.markerSellTextStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 16 * 0.7,
              fontWeight: FontWeight.bold,
            ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offsetInCanvas = Offset(
      size.width / 2,
      size.height - (markerStyle?.sellMarkMargin ?? 8),
    );

    final markerRect = Rect.fromCenter(
      center: offsetInCanvas,
      width: markerStyle?.markerSize ?? 16.0,
      height: markerStyle?.markerSize ?? 16.0,
    );

    // Draw shadow behind the marker

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        markerRect.shift(const Offset(-1, 3)), // Offset the shadow
        const Radius.circular(4),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.53) // Shadow color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..style = PaintingStyle.fill,
    );

    final trianglePath = Path()
      ..moveTo(markerRect.center.dx, markerRect.bottom + 4)
      ..lineTo(markerRect.left, markerRect.bottom - 5)
      ..lineTo(markerRect.right, markerRect.bottom - 5)
      ..close();

    canvas
      ..drawPath(trianglePath, sellMarkerPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(markerRect, const Radius.circular(4)),
        sellMarkerPaint,
      );

    textPainter.paint(
      canvas,
      Offset(
        markerRect.left + (markerRect.width - textPainter.width) / 2,
        markerRect.top + (markerRect.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BubbleTailPainterBuy extends CustomPainter {
  BubbleTailPainterBuy(this.markerStyle);
  final MarkerStyle? markerStyle;
  @override
  void paint(Canvas canvas, Size size) {
    final buyMarkerPaint = Paint()
      ..color = markerStyle?.buyMarkColor ?? Colors.green
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'B',
        style: markerStyle?.markerBuyTextStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 16 * 0.7,
              fontWeight: FontWeight.bold,
            ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offsetInCanvas = Offset(size.width / 2, size.height - (0 ?? 8));

    // Draw shadow behind the marker
    final markerRect = Rect.fromCenter(
      center: offsetInCanvas,
      width: markerStyle?.markerSize ?? 16,
      height: markerStyle?.markerSize ?? 16,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        markerRect.shift(const Offset(-1, 3)), // Offset the shadow
        const Radius.circular(4),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.53) // Shadow color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..style = PaintingStyle.fill,
    );

    final trianglePath = Path();
    trianglePath.moveTo(markerRect.center.dx, markerRect.top - 4);
    trianglePath.lineTo(markerRect.left, markerRect.top + 5);
    trianglePath.lineTo(markerRect.right, markerRect.top + 5);
    trianglePath.close();
    canvas.drawPath(trianglePath, buyMarkerPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(markerRect, Radius.circular(4)),
      buyMarkerPaint,
    );

    textPainter.paint(
      canvas,
      Offset(
        markerRect.left + (markerRect.width - textPainter.width) / 2,
        markerRect.top + (markerRect.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
