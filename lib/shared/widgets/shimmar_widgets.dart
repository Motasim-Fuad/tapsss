import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget {
  static Widget rectangular({
    double height = 80,
    double? width,
    double borderRadius = 12,
    EdgeInsets? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static Widget card({
    double height = 80,
    double? width,
    double borderRadius = 12,
  }) {
    return rectangular(height: height, width: width, borderRadius: borderRadius);
  }

  static Widget list({int itemCount = 7, double itemHeight = 80}) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, __) => card(height: itemHeight),
    );
  }
}
