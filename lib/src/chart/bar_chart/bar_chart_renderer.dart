import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';

// coverage:ignore-start

/// Low level BarChart Widget.
class BarChartLeaf extends LeafRenderObjectWidget {
  const BarChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
    this.useCustomTooltip = false,
    this.barTooltip,
  });

  final BarChartData data;
  final BarChartData targetData;
  final bool useCustomTooltip;
  final void Function(BarTooltip? barTooltip)? barTooltip;

  @override
  RenderBarChart createRenderObject(BuildContext context) => RenderBarChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
        useCustomTooltip,
        barTooltip,
      );

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context
      ..useCustomTooltip = useCustomTooltip;
  }
}
// coverage:ignore-end

/// Renders our BarChart, also handles hitTest.
class RenderBarChart extends RenderBaseChart<BarTouchResponse> {
  RenderBarChart(
    BuildContext context,
    BarChartData data,
    BarChartData targetData,
    TextScaler textScaler,
    bool useCustomTooltip,
    this.barTooltip,
  )   : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        _useCustomTooltip = useCustomTooltip,
        super(targetData.barTouchData, context);

  final void Function(BarTooltip? barTooltip)? barTooltip;

  BarChartData get data => _data;
  BarChartData _data;

  bool _useCustomTooltip;
  bool get useCustomTooltip => _useCustomTooltip;
  set useCustomTooltip(bool value) {
    if (_useCustomTooltip == value) return;
    _useCustomTooltip = value;
    markNeedsPaint();
  }

  set data(BarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  BarChartData get targetData => _targetData;
  BarChartData _targetData;

  set targetData(BarChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.barTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  late BarChartPainter painter;

  PaintHolder<BarChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler);

  var points = <Offset>[];
  Paint? linePaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    linePaint ??= Paint()
      ..color = _data.lineBarChartData.color
      ..strokeWidth = _data.lineBarChartData.strokeWidth
      ..strokeCap = _data.lineBarChartData.strokeCap;
    painter = BarChartPainter(
      useCustomTooltip: useCustomTooltip,
      points: points,
      lineBarPaint: linePaint,
      barTooltip: barTooltip,
    );
    calculateLine(CanvasWrapper(canvas, mockTestSize ?? size), paintHolder);

    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  void calculateLine(
      CanvasWrapper canvasWrapper, PaintHolder<BarChartData> holder) {
    final viewSize = canvasWrapper.size;
    final data = holder.data;

    if (data.barGroups.isEmpty) {
      return;
    }
    final groupsX = data.calculateGroupsX(canvasWrapper.size.width);
    final groupBarsPosition = painter.calculateGroupAndBarsPosition(
      canvasWrapper.size,
      groupsX,
      data.barGroups,
    );

    if (points.length < data.lineCharts.length) {
      for (var j = 0; j < data.barGroups.length; j++) {
        for (var i = 0; i < data.lineCharts.length; i++) {
          if (data.barGroups[j].x == data.lineCharts[i].x) {
            points.add(
              Offset(
                groupBarsPosition[j].barsX.first,
                painter.getPixelY(
                  data.lineCharts[i].y,
                  viewSize,
                  holder,
                ),
              ),
            );
          }
        }
      }
    }
  }

  @override
  BarTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpot = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return BarTouchResponse(touchedSpot);
  }
}
