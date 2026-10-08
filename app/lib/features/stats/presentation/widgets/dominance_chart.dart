import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class DominanceChart extends StatelessWidget {
  const DominanceChart({super.key, required this.btc, required this.eth});

  final double? btc;
  final double? eth;

  static const _btcColor = Color(0xFFF7931A);
  static const _ethColor = Color(0xFF627EEA);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tt = Theme.of(context).textTheme;

    final b = (btc ?? 0).clamp(0, 100).toDouble();
    final e = (eth ?? 0).clamp(0, 100).toDouble();
    if (b + e <= 0) return const SizedBox.shrink();
    final others = (100 - b - e).clamp(0, 100).toDouble();
    final othersColor = colors.textSecondary.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: PieChart(
              PieChartData(
                startDegreeOffset: -90,
                sectionsSpace: 2,
                centerSpaceRadius: 34,
                sections: [
                  _section(b, _btcColor),
                  _section(e, _ethColor),
                  if (others > 0) _section(others, othersColor),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Market dominance',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _LegendRow(color: _btcColor, label: 'Bitcoin', value: b),
                const SizedBox(height: 8),
                _LegendRow(color: _ethColor, label: 'Ethereum', value: e),
                const SizedBox(height: 8),
                _LegendRow(color: othersColor, label: 'Others', value: others),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(double value, Color color) =>
      PieChartSectionData(
        value: value,
        color: color,
        radius: 22,
        showTitle: false,
      );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: tt.bodyMedium)),
        Text(
          Fmt.plainPercent(value),
          style: tt.bodyMedium!.copyWith(fontWeight: FontWeight.w600).tabular,
        ),
      ],
    );
  }
}