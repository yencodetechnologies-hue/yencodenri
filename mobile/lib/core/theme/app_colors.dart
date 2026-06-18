import 'package:flutter/material.dart';

class AppColors {
  static const primaryDark = Color(0xFF0D2240);
  static const primaryAccent = Color(0xFF02AFEF);
  static const background = Color(0xFFF5F7FA);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF0D2240);
  static const textSecondary = Color(0xFF6B7280);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static const brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryDark, primaryAccent],
  );
}
