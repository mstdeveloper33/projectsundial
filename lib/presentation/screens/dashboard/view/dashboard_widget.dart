import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Gün bilgisi için

import '../../journaling/viewmodel/journal_viewmodel.dart';

class MoodLineChart extends StatefulWidget {
  final JournalingViewModel viewModel;

  const MoodLineChart({required this.viewModel});

  @override
  State<MoodLineChart> createState() => _MoodLineChartState();
}

class _MoodLineChartState extends State<MoodLineChart> {
  List<DateTime> getWeekDates() {
    final DateTime now = DateTime.now();
    // Bugünden başlayarak son 7 günü hesapla
    return List.generate(
      7,
      (index) => now.subtract(Duration(
          days:
              5 - index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekDates = getWeekDates();

    // Grafiklerin dinamik olabilmesi için en yüksek değeri hesaplıyoruz
    int maxMoodCount = 0;
    final moodCounts = widget.viewModel.getMoodCountsForCurrentWeek();
    moodCounts.values.expand((countMap) => countMap.values).fold<int>(
        0, (previous, current) => current > previous ? current : previous);

    double dynamicMaxY = (maxMoodCount + 5).toDouble();

    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 20),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            _createMoodBar("😊", moodCounts["😊"] ?? {},
                const LinearGradient(colors: [Colors.lime, Colors.green])),
            _createMoodBar("😞", moodCounts["😞"] ?? {},
                const LinearGradient(colors: [Colors.lightBlue, Colors.blue])),
            _createMoodBar("😠", moodCounts["😠"] ?? {},
                const LinearGradient(colors: [Colors.redAccent, Colors.red])),
          ],
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          minX: 0,
          maxX: 6,
          maxY: dynamicMaxY,
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 65,
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta, weekDates),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
                reservedSize: 40,
                interval: 1,
              ),
            ),
          ),
          gridData: const FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 1,
          ),
          lineTouchData: lineTouchData,
        ),
      ),
    );
  }

  LineChartBarData _createMoodBar(
      String mood, Map<int, int> moodCounts, Gradient gradient) {
    return LineChartBarData(
      spots: generateSpots(moodCounts),
      isCurved: true,
      gradient: gradient,
      preventCurveOverShooting: true,
      barWidth: 4,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  List<FlSpot> generateSpots(Map<int, int> moodCounts) {
    return List.generate(
      7,
      (index) {
        int dayIndex = index + 1;
        double count =
            moodCounts[dayIndex] != null ? moodCounts[dayIndex]!.toDouble() : 0;
        return FlSpot(index.toDouble(), count.clamp(0, double.infinity));
      },
    );
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, List<DateTime> weekDates) {
    int dayIndex = value.toInt();
    if (dayIndex < 0 || dayIndex >= weekDates.length) return const Text('');
    final DateTime date = weekDates[dayIndex];

    final String formattedDate = DateFormat('d').format(date);
    final String weekDayName = DateFormat('EEE').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        children: [
          Text(
            formattedDate,
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
          Text(
            '/$weekDayName',
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              String emoji;
              switch (spot.barIndex) {
                case 0:
                  emoji = '😊';
                  break;
                case 1:
                  emoji = '😞';
                  break;
                case 2:
                  emoji = '😠';
                  break;
                default:
                  emoji = '';
              }
              return LineTooltipItem(
                '$emoji: ${spot.y.toInt()}',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      );
}
