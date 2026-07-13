import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
      ),
    );
  }
}
