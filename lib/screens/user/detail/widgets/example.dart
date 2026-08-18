
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snap_chart/snap_chart.dart';


class SnapChartExampleApp extends StatelessWidget {
  const SnapChartExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapChart Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ChartGallery(),
    );
  }
}

class ChartGallery extends StatefulWidget {
  const ChartGallery({super.key});

  @override
  State<ChartGallery> createState() => _ChartGalleryState();
}

class _ChartGalleryState extends State<ChartGallery> {
  String _touchInfo = 'Tap or drag on any chart';
  final _random = Random();

  List<SnapSpot> _lineSpots = [
    const SnapSpot(0, 3),
    const SnapSpot(1, 1),
    const SnapSpot(2, 4),
    const SnapSpot(3, 1.5),
    const SnapSpot(4, 5),
    const SnapSpot(5, 2.5),
    const SnapSpot(6, 4.5),
  ];

  List<SnapBar> _bars = const [
    SnapBar(value: 10, label: 'Mon'),
    SnapBar(value: 15, label: 'Tue'),
    SnapBar(value: 8, label: 'Wed'),
    SnapBar(value: 12, label: 'Thu'),
    SnapBar(value: 18, label: 'Fri'),
    SnapBar(value: 6, label: 'Sat'),
    SnapBar(value: 9, label: 'Sun'),
  ];

  void _randomizeLineData() {
    setState(() {
      _lineSpots = List.generate(
        7,
        (i) => SnapSpot(i.toDouble(), _random.nextDouble() * 6),
      );
    });
  }

  void _randomizeBarData() {
    setState(() {
      final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      _bars = List.generate(
        7,
        (i) => SnapBar(value: _random.nextDouble() * 20 + 2, label: labels[i]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapChart Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _touchInfo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Line Chart
            _buildSection(
              title: 'Line Chart',
              action: TextButton(
                onPressed: _randomizeLineData,
                child: const Text('Randomize'),
              ),
              child: SizedBox(
                height: 200,
                child: SnapLineChart(
                  spots: _lineSpots,
                  curved: true,
                  filled: true,
                  showDots: true,
                  lineWidth: 3,
                  fillOpacity: 0.15,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched && data.spot != null) {
                        _touchInfo =
                            'Line: x=${data.spot!.x.toStringAsFixed(1)}, y=${data.spot!.y.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Multi-line Chart
            _buildSection(
              title: 'Multi-Line Chart',
              child: SizedBox(
                height: 200,
                child: SnapLineChart(
                  multiLines: [
                    const [
                      SnapSpot(0, 2),
                      SnapSpot(1, 4),
                      SnapSpot(2, 3),
                      SnapSpot(3, 5),
                      SnapSpot(4, 4),
                    ],
                    const [
                      SnapSpot(0, 1),
                      SnapSpot(1, 2),
                      SnapSpot(2, 4),
                      SnapSpot(3, 3),
                      SnapSpot(4, 6),
                    ],
                  ],
                  curved: true,
                  lineWidth: 2.5,
                  style: const SnapChartStyle(
                    showGrid: true,
                    gridColor: Color(0xFFEEEEEE),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bar Chart
            _buildSection(
              title: 'Bar Chart',
              action: TextButton(
                onPressed: _randomizeBarData,
                child: const Text('Randomize'),
              ),
              child: SizedBox(
                height: 200,
                child: SnapBarChart(
                  bars: _bars,
                  borderRadius: 6,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched) {
                        _touchInfo =
                            'Bar: index=${data.index}, value=${data.barValue?.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Grouped Bar Chart
            _buildSection(
              title: 'Grouped Bar Chart',
              child: SizedBox(
                height: 200,
                child: SnapBarChart(
                  bars: const [
                    SnapBar(
                      label: 'Q1',
                      groupValues: [12, 8, 15],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    SnapBar(
                      label: 'Q2',
                      groupValues: [10, 14, 9],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    SnapBar(
                      label: 'Q3',
                      groupValues: [16, 11, 13],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    SnapBar(
                      label: 'Q4',
                      groupValues: [14, 17, 10],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                  ],
                  borderRadius: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Pie Chart
            _buildSection(
              title: 'Pie Chart',
              child: SizedBox(
                height: 250,
                child: SnapPieChart(
                  sections: const [
                    SnapPieSection(
                      value: 35,
                      label: 'Flutter',
                      color: Colors.blue,
                    ),
                    SnapPieSection(
                      value: 25,
                      label: 'React',
                      color: Colors.cyan,
                    ),
                    SnapPieSection(
                      value: 20,
                      label: 'Native',
                      color: Colors.orange,
                    ),
                    SnapPieSection(
                      value: 15,
                      label: 'Kotlin',
                      color: Colors.purple,
                    ),
                    SnapPieSection(
                      value: 5,
                      label: 'Other',
                      color: Colors.grey,
                    ),
                  ],
                  showPercentage: true,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched) {
                        _touchInfo =
                            'Pie: section=${data.index}, value=${data.sectionValue}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Donut Chart
            _buildSection(
              title: 'Donut Chart',
              child: SizedBox(
                height: 250,
                child: SnapPieChart(
                  sections: const [
                    SnapPieSection(
                      value: 40,
                      label: 'Dart',
                      color: Colors.teal,
                    ),
                    SnapPieSection(
                      value: 30,
                      label: 'Swift',
                      color: Colors.deepOrange,
                    ),
                    SnapPieSection(
                      value: 20,
                      label: 'Kotlin',
                      color: Colors.indigo,
                    ),
                    SnapPieSection(
                      value: 10,
                      label: 'Rust',
                      color: Colors.brown,
                    ),
                  ],
                  holeRadius: 0.55,
                  showLabels: true,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Scatter Chart
            _buildSection(
              title: 'Scatter Chart',
              child: SizedBox(
                height: 200,
                child: SnapScatterChart(
                  multiSeries: [
                    const [
                      SnapSpot(1, 2),
                      SnapSpot(2, 4.5),
                      SnapSpot(3, 1.5),
                      SnapSpot(4, 5),
                      SnapSpot(5, 3),
                      SnapSpot(6, 4),
                    ],
                    const [
                      SnapSpot(1.5, 3),
                      SnapSpot(2.5, 1),
                      SnapSpot(3.5, 4),
                      SnapSpot(4.5, 2),
                      SnapSpot(5.5, 5.5),
                    ],
                  ],
                  dotRadius: 8,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched && data.spot != null) {
                        _touchInfo =
                            'Scatter: x=${data.spot!.x.toStringAsFixed(1)}, y=${data.spot!.y.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Minimal Style Line Chart
            _buildSection(
              title: 'Minimal Style (Sparkline)',
              child: SizedBox(
                height: 80,
                child: SnapLineChart(
                  spots: const [
                    SnapSpot(0, 2),
                    SnapSpot(1, 4),
                    SnapSpot(2, 3),
                    SnapSpot(3, 5),
                    SnapSpot(4, 3.5),
                    SnapSpot(5, 6),
                    SnapSpot(6, 5),
                    SnapSpot(7, 7),
                  ],
                  curved: true,
                  filled: true,
                  fillOpacity: 0.3,
                  lineWidth: 2,
                  style: SnapChartStyle.minimal,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    Widget? action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ?action,
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

