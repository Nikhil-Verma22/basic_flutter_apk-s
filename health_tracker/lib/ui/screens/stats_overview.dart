import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/database/database_helper.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/glass_container.dart';

class StatsOverview extends ConsumerStatefulWidget {
  const StatsOverview({super.key});

  @override
  ConsumerState<StatsOverview> createState() => _StatsOverviewState();
}

class _StatsOverviewState extends ConsumerState<StatsOverview> {
  List<DailyData> _weeklyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getWeeklyData();
    // Default to last 7 days if empty
    if (data.isEmpty) {
      final now = DateTime.now();
      for (int i=6; i>=0; i--) {
        data.add(DailyData(date: DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i))), steps: 0, waterMl: 0));
      }
    } else {
      data.sort((a, b) => a.date.compareTo(b.date)); // Sort chronologically
    }
    setState(() {
      _weeklyData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Stats Overview', style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.w900,
        )),
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 200, left: -50,
            child: Container(width: 300, height: 300, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x33b1feda))),
          ),
          SafeArea(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('WEEKLY STEPS', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GlassContainer(
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 10000, // Make dynamic if needed
                                minY: 0,
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                                          final dateStr = _weeklyData[value.toInt()].date;
                                          final date = DateTime.parse(dateStr);
                                          final day = DateFormat('E').format(date);
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(day, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                barGroups: _weeklyData.asMap().entries.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value.steps.toDouble(),
                                        color: AppTheme.primary,
                                        width: 16,
                                        borderRadius: BorderRadius.circular(4),
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: 10000,
                                          color: AppTheme.surfaceContainerHighest,
                                        )
                                      )
                                    ]
                                  );
                                }).toList(),
                              )
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text('WEEKLY HYDRATION', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GlassContainer(
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 4000, // 4L
                                minY: 0,
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                                          final dateStr = _weeklyData[value.toInt()].date;
                                          final date = DateTime.parse(dateStr);
                                          final day = DateFormat('E').format(date);
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(day, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                barGroups: _weeklyData.asMap().entries.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value.waterMl.toDouble(),
                                        color: AppTheme.secondary,
                                        width: 16,
                                        borderRadius: BorderRadius.circular(4),
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: 4000,
                                          color: AppTheme.surfaceContainerHighest,
                                        )
                                      )
                                    ]
                                  );
                                }).toList(),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
