import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Placeholder used wherever a local asset image (from Figma) needs to be
/// dropped in later. Replace this widget with Image.asset('assets/images/...')
/// once the exported asset is added to the project.
class AssetPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final String label;
  final BorderRadius? borderRadius;

  const AssetPlaceholder({
    super.key,
    this.width,
    this.height,
    this.label = 'here need to use assest image',
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        color: AppColors.surface,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
