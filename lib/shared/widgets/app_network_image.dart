import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);

    if (url == null || url!.isEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(
          width: width,
          height: height,
          color: AppColors.surface,
          child: const Icon(Icons.image_outlined, color: AppColors.textHint),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 320),
        fadeOutDuration: const Duration(milliseconds: 180),
        fadeInCurve: Curves.easeOut,
        placeholder: (context, _) => _ImageShimmer(width: width, height: height),
        errorWidget: (context, _, __) => Container(
          width: width,
          height: height,
          color: AppColors.surface,
          child: const Icon(Icons.broken_image_outlined, color: AppColors.textHint),
        ),
      ),
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  final double? width;
  final double? height;

  const _ImageShimmer({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6EAF0),
      highlightColor: const Color(0xFFF7F9FC),
      period: const Duration(milliseconds: 1100),
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
