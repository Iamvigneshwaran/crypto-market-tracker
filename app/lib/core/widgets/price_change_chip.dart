import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class PriceChangeChip extends StatelessWidget {
  const PriceChangeChip({super.key, required this.value});
  final double? value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final v = value;
    if (v == null) {
      return Text('--', style: TextStyle(color: colors.textSecondary));
    }
    final up = v >= 0;
    final color = up ? colors.gain : colors.loss;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color, size: 18),
          Text(
            Fmt.percent(v),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ).tabular,
          ),
        ],
      ),
    );
  }
}