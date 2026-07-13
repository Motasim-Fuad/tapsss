import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class InlineErrorWidget extends StatelessWidget {
  final String? message;

  const InlineErrorWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
