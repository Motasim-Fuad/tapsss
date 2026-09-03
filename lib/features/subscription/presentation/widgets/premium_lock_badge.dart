import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PremiumLockBadge extends StatelessWidget {
  const PremiumLockBadge({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.lock, size: size, color: AppColors.primaryDark),
    );
  }
}
