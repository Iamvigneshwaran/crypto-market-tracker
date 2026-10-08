import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.gain,
    required this.loss,
    required this.card,
    required this.border,
    required this.textSecondary,
  });

  final Color gain;
  final Color loss;
  final Color card;
  final Color border;
  final Color textSecondary;

  static const light = AppColors(
    gain: Color(0xFF16A34A),
    loss: Color(0xFFDC2626),
    card: Color(0xFFF5F7FA),
    border: Color(0xFFE5E8EC),
    textSecondary: Color(0xFF6B7280),
  );

  static const dark = AppColors(
    gain: Color(0xFF22C55E),
    loss: Color(0xFFEF4444),
    card: Color(0xFF181C23),
    border: Color(0xFF2A2F38),
    textSecondary: Color(0xFF9AA3B2),
  );

  @override
  AppColors copyWith({
    Color? gain,
    Color? loss,
    Color? card,
    Color? border,
    Color? textSecondary,
  }) {
    return AppColors(
      gain: gain ?? this.gain,
      loss: loss ?? this.loss,
      card: card ?? this.card,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      gain: Color.lerp(gain, other.gain, t)!,
      loss: Color.lerp(loss, other.loss, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}