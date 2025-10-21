import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class CandlestickChartSample3 extends StatefulWidget {
  const CandlestickChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => CandlestickChartSample3State();
}

class CandlestickChartSample3State extends State<CandlestickChartSample3> {
  final ScrollController _scrollController = ScrollController();

  // Toggle states for the new features
  bool _showOnTopOfTheChartBoxArea = true;
  bool _fitInsideHorizontally = true;
  bool _extraLinesOnTop = true;

  // Min/Max tracking
  double? _minVisibleY;
  double? _maxVisibleY;
  double? _minVisibleX;
  double? _maxVisibleX;

  final List<CandlestickSpot> candlestickSpots = [
    CandlestickSpot(x: 0, open: 100, high: 125, low: 90, close: 110),
    CandlestickSpot(x: 1, open: 110, high: 135, low: 100, close: 125),
    CandlestickSpot(x: 2, open: 125, high: 145, low: 115, close: 135),
    CandlestickSpot(x: 3, open: 135, high: 155, low: 125, close: 145),
    CandlestickSpot(x: 4, open: 145, high: 165, low: 135, close: 155),
    CandlestickSpot(x: 5, open: 155, high: 175, low: 145, close: 165),
    CandlestickSpot(x: 6, open: 165, high: 185, low: 155, close: 175),
    CandlestickSpot(x: 7, open: 175, high: 195, low: 165, close: 185),
    CandlestickSpot(x: 8, open: 185, high: 205, low: 175, close: 195),
    CandlestickSpot(x: 9, open: 195, high: 215, low: 185, close: 205),
    CandlestickSpot(x: 10, open: 205, high: 225, low: 195, close: 215),
    CandlestickSpot(x: 11, open: 215, high: 235, low: 205, close: 225),
    CandlestickSpot(x: 12, open: 225, high: 245, low: 215, close: 235),
    CandlestickSpot(x: 13, open: 235, high: 255, low: 225, close: 245),
    CandlestickSpot(x: 14, open: 245, high: 265, low: 235, close: 255),
    CandlestickSpot(x: 15, open: 255, high: 275, low: 245, close: 265),
    CandlestickSpot(x: 16, open: 265, high: 285, low: 255, close: 275),
    CandlestickSpot(x: 17, open: 275, high: 295, low: 265, close: 285),
    CandlestickSpot(x: 18, open: 285, high: 305, low: 275, close: 295),
    CandlestickSpot(x: 19, open: 295, high: 315, low: 285, close: 305),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateVisibleRange();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _calculateVisibleRange();
  }

  void _calculateVisibleRange() {
    if (!mounted) return;

    // Get the visible viewport width
    final scrollOffset =
        _scrollController.hasClients ? _scrollController.offset : 0.0;
    final viewportWidth = _scrollController.hasClients
        ? _scrollController.position.viewportDimension
        : 400.0;

    // Calculate which candles are visible
    const candleWidth = 30.0;
    final startIndex = (scrollOffset / candleWidth)
        .floor()
        .clamp(0, candlestickSpots.length - 1);
    final endIndex = ((scrollOffset + viewportWidth) / candleWidth)
        .ceil()
        .clamp(0, candlestickSpots.length);

    if (startIndex >= endIndex) return;

    final visibleSpots = candlestickSpots.sublist(startIndex, endIndex);

    if (visibleSpots.isEmpty) return;

    // Find min and max Y values in visible range
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final spot in visibleSpots) {
      if (spot.low < minY) minY = spot.low;
      if (spot.high > maxY) maxY = spot.high;
    }

    // Find the X positions of min/max
    final minSpot = visibleSpots.reduce((a, b) => a.low < b.low ? a : b);
    final maxSpot = visibleSpots.reduce((a, b) => a.high > b.high ? a : b);

    setState(() {
      _minVisibleY = minY;
      _maxVisibleY = maxY;
      _minVisibleX = minSpot.x;
      _maxVisibleX = maxSpot.x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Animated Min/Max Tracking',
            style: TextStyle(
              color: AppColors.contentColorYellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Scroll horizontally to see lines follow visible data.\nLines are always in bounds, so "Show On Top" affects z-order.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Toggle switches
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Extra Lines On Top',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Draw lines above (true) or below (false) candlesticks',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  value: _extraLinesOnTop,
                  onChanged: (value) {
                    setState(() {
                      _extraLinesOnTop = value;
                    });
                  },
                  activeThumbColor: AppColors.contentColorBlue,
                ),
                SwitchListTile(
                  title: const Text(
                    'Show On Top Of Chart Area',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Render lines even when outside viewport bounds',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  value: _showOnTopOfTheChartBoxArea,
                  onChanged: (value) {
                    setState(() {
                      _showOnTopOfTheChartBoxArea = value;
                    });
                  },
                  activeThumbColor: AppColors.contentColorGreen,
                ),
                SwitchListTile(
                  title: const Text(
                    'Fit Labels Inside Horizontally',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Clamp labels to stay within viewport',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  value: _fitInsideHorizontally,
                  onChanged: (value) {
                    setState(() {
                      _fitInsideHorizontally = value;
                    });
                  },
                  activeThumbColor: AppColors.contentColorPurple,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: candlestickSpots.length * 30.0,
                  child: CandlestickChart(
                    CandlestickChartData(
                      minX: 0,
                      maxX: candlestickSpots.length.toDouble() - 1,
                      minY: 80,
                      maxY: 320,
                      candlestickSpots: candlestickSpots,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: true,
                        horizontalInterval: 40,
                        verticalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withValues(alpha: 0.1),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white.withValues(alpha: 0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      extraLinesData: ExtraLinesData(
                        extraLinesOnTop: _extraLinesOnTop,
                        verticalLines: [
                          // Max value vertical line
                          if (_maxVisibleX != null && _maxVisibleY != null)
                            VerticalLine(
                              x: _maxVisibleX!,
                              color: AppColors.contentColorGreen,
                              strokeWidth: 2,
                              dashArray: [5, 5],
                              showOnTopOfTheChartBoxArea:
                                  _showOnTopOfTheChartBoxArea,
                              fitInsideHorizontally: _fitInsideHorizontally,
                              label: VerticalLineLabel(
                                show: true,
                                alignment: Alignment.topCenter,
                                style: const TextStyle(
                                  color: AppColors.contentColorGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                labelResolver: (line) =>
                                    'MAX\n${_maxVisibleY!.toStringAsFixed(1)}',
                              ),
                            ),
                          // Min value vertical line
                          if (_minVisibleX != null && _minVisibleY != null)
                            VerticalLine(
                              x: _minVisibleX!,
                              color: AppColors.contentColorRed,
                              strokeWidth: 2,
                              dashArray: [5, 5],
                              showOnTopOfTheChartBoxArea:
                                  _showOnTopOfTheChartBoxArea,
                              fitInsideHorizontally: _fitInsideHorizontally,
                              label: VerticalLineLabel(
                                show: true,
                                alignment: Alignment.bottomCenter,
                                style: const TextStyle(
                                  color: AppColors.contentColorRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                labelResolver: (line) =>
                                    'MIN\n${_minVisibleY!.toStringAsFixed(1)}',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: AppColors.contentColorGreen,
                  label: 'Max High',
                ),
                const SizedBox(width: 20),
                _buildLegendItem(
                  color: AppColors.contentColorRed,
                  label: 'Min Low',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
