import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/price_change_chip.dart';
import '../../data/models/chart_point.dart';

class PriceChart extends StatelessWidget {
  const PriceChart({super.key, required this.points, required this.days});

  final List<ChartPoint> points;
  final int days;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    if (points.length < 2) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text('No chart data',
              style: TextStyle(color: colors.textSecondary)),
        ),
      );
    }

    final first = points.first.p;
    final last = points.last.p;
    final up = last >= first;
    final color = up ? colors.gain : colors.loss;
    final change = first == 0 ? null : (last / first - 1) * 100;

    var minY = first, maxY = first;
    for (final p in points) {
      if (p.p < minY) minY = p.p;
      if (p.p > maxY) maxY = p.p;
    }
    final range = maxY - minY;
    final pad = range == 0 ? (maxY.abs() * 0.01 + 0.0001) : range * 0.1;

    final spots = [
      for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].p),
    ];
    final dateFmt =
        days <= 7 ? DateFormat('d MMM, HH:mm') : DateFormat('d MMM yyyy');

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (points.length - 1).toDouble(),
              minY: minY - pad,
              maxY: maxY + pad,
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  getTooltipColor: (_) => scheme.inverseSurface,
                  getTooltipItems: (touched) => touched.map((s) {
                    final i = s.x.toInt().clamp(0, points.length - 1);
                    final date = DateTime.fromMillisecondsSinceEpoch(
                      points[i].t,
                    );
                    return LineTooltipItem(
                      '${Fmt.price(s.y)}\n',
                      TextStyle(
                        color: scheme.onInverseSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: dateFmt.format(date),
                          style: TextStyle(
                            color: scheme.onInverseSurface,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: color,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.25),
                        color.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Mini(label: 'Low', child: _MiniText(Fmt.price(minY))),
            _Mini(label: 'High', child: _MiniText(Fmt.price(maxY))),
            _Mini(label: 'Change', child: PriceChangeChip(value: change)),
          ],
        ),
      ],
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: context.appColors.textSecondary),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _MiniText extends StatelessWidget {
  const _MiniText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.w600)
          .tabular,
    );
  }
}