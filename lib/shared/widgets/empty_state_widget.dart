import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
            if (actionText != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
