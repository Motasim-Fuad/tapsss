import 'package:arashmati_app/features/progress/presentation/widgets/readiness_widgets.dart';
import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../data/models/progress_models.dart';
import '../controllers/progress_controller.dart';

class ProgressPage extends GetView<ProgressController> {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Progress Tracker', style: AppTextStyles.h2),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.overview.value == null) {
          return  ShimmerWidget.list();
        }

        if (controller.errorMessage.value != null && controller.overview.value == null) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry',
            onAction: controller.fetchAll,
          );
        }

        final overview = controller.overview.value;
        if (overview == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.fetchAll,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
             const  Text('Track your readiness for the citizenship test', style: AppTextStyles.bodySecondary),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: -2,
                            offset: Offset(4, 4), // x, y
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const  Text('Overall Readiness', style: AppTextStyles.caption),
                          Text('${overview.readinessScore}%', style: AppTextStyles.h1),
                          Card(
                            color: AppColors.infoBg,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('+${overview.weekChange} this week',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ReadinessIndicator(
                    percentage: overview.readinessScore.toDouble(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                      child: _MiniStat(
                          icon: Icons.description_outlined,
                          value: '${overview.testsDone}/${overview.totalTests}',
                          label: 'Test Done')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _MiniStat(
                          icon: Icons.check_circle_outline,
                          value: '${overview.accuracy}%',
                          label: 'Accuracy')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _MiniStat(
                          icon: Icons.local_fire_department_outlined,
                          value: '${overview.streak}d',
                          label: 'Streak')),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score History', style: AppTextStyles.h3),
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: -2,
                              offset: Offset(4, 4), // x, y
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          children: ['week', 'month'].map((period) {
                            final isSelected = controller.selectedPeriod.value == period;
                            return GestureDetector(
                              onTap: () => controller.changePeriod(period),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  period[0].toUpperCase() + period.substring(1),
                                  style: AppTextStyles.caption.copyWith(
                                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: Obx(() {
                  final points = controller.scoreHistory;
                  if (points.isEmpty) {
                    return Center(child: Text('No score data yet', style: AppTextStyles.bodySecondary));
                  }
                  return LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 100,

                      borderData: FlBorderData(show: false),

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.shade200,
                          strokeWidth: 1,
                        ),
                      ),

                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),

                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,

                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => AppColors.primary,
                          tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          tooltipMargin: 10,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,

                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                "${spot.y.toInt()}%",
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }).toList();
                          },
                        ),

                        getTouchedSpotIndicator: (barData, indexes) {
                          return indexes.map((index) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: AppColors.primary.withOpacity(.4),
                                strokeWidth: 2,
                                dashArray: [5, 5],
                              ),
                              FlDotData(
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: AppColors.primary,
                                    strokeWidth: 3,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            );
                          }).toList();
                        },
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: points
                              .asMap()
                              .entries
                              .map((e) => FlSpot(
                            e.key.toDouble(),
                            e.value.score.toDouble(),
                          ))
                              .toList(),

                          isCurved: true,
                          curveSmoothness: .35,

                          color: AppColors.primary,
                          barWidth: 4,

                          isStrokeCapRound: true,

                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) {
                              return FlDotCirclePainter(
                                radius: 4.5,
                                color: AppColors.primary,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),

                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withOpacity(.25),
                                AppColors.primary.withOpacity(.02),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Test History', style: AppTextStyles.h3),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.testHistory.isEmpty) {
                  return Text('No tests completed yet', style: AppTextStyles.bodySecondary);
                }
                return Column(
                  children: controller.testHistory
                      .map((item) => _TestHistoryTile(item: item))
                      .toList(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius: -2,
            offset: Offset(4, 4), // x, y
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.label),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _TestHistoryTile extends StatelessWidget {
  final TestHistoryItemModel item;

  const _TestHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.statusColor == 'green' ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.testName, style: AppTextStyles.label),
                Text(item.date, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.score / item.totalMarks,
                    minHeight: 5,
                    backgroundColor: AppColors.border,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text('${item.score}%', style: AppTextStyles.label.copyWith(color: color)),
        ],
      ),
    );
  }
}
