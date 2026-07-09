# Widget label on a HorizontalLine

`HorizontalLine` supports a `labelWidgetBuilder`, letting you render **any Flutter
widget** (e.g. a styled pill/badge) sitting exactly on a horizontal line in a
`LineChart`. The chart positions the widget using its own axis transform, so it
stays aligned to the line — no manual pixel math.

This complements the existing canvas-painted `label` (`HorizontalLineLabel`), which
only draws plain text.

## API (on `HorizontalLine`)

```dart
HorizontalLine(
  y: <value in the chart's Y coordinate>,     // where the line sits
  color: Colors.cyan,
  strokeWidth: 2,
  dashArray: const [8, 6],                     // optional: dashed line
  labelWidgetBuilder: (line) => MyWidget(),    // any widget, centered on the line
  labelWidgetAlignment: Alignment.centerLeft,  // horizontal anchor (default centerLeft)
)
```

- `labelWidgetBuilder` — returns the widget; its **vertical center** is placed on the
  line at `y`.
- `labelWidgetAlignment` — only the **horizontal** component is used (left / center /
  right within the plot). Vertical is always centered on the line.
- The widget is **never clipped** at chart edges — the overhang draws into the
  surrounding area.
- A line exactly at `minY` / `maxY` (top / bottom edge) is drawn (not skipped).

## Minimal example

```dart
LineChart(
  LineChartData(
    minY: 0,
    maxY: 100,
    lineBarsData: [LineChartBarData(spots: mySpots)],
    extraLinesData: ExtraLinesData(
      horizontalLines: [
        HorizontalLine(
          y: 72, // in chart Y units
          color: Colors.cyan,
          strokeWidth: 2,
          dashArray: const [8, 6],
          labelWidgetBuilder: (line) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyan),
            ),
            child: const Text(
              'Avg. Buy  72',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  ),
)
```

## The value is in the chart's Y coordinate

`y` is a **chart Y value**, mapped between `LineChartData.minY` and `maxY`. If your
value lives on a different scale (e.g. a price axis different from the plotted
spots), map it first:

```dart
final ratio = ((value - axisLow) / (axisHigh - axisLow)).clamp(0.0, 1.0);
final chartY = minY + ratio * (maxY - minY); // pass chartY as HorizontalLine.y
```

Values above `maxY` pin to the top, below `minY` pin to the bottom.

## Working reference

`example/lib/presentation/samples/line/line_chart_sample2.dart` — the "Avg. Buy"
pill (`AvgBuyPill`) uses this exact API.
