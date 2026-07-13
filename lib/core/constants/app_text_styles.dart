import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
