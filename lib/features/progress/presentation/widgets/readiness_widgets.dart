import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadinessIndicator extends StatelessWidget {
  final double percentage;

  const ReadinessIndicator({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(
        painter: _ReadinessPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${percentage.toInt()}%",
                  style: const TextStyle(
                   fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff23395B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Readiness".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7B8794),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadinessPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = size.width / 2 - 10;

    final yellowPaint = Paint()
      ..color = const Color(0xffF5C542)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    final bluePaint = Paint()
      ..color = const Color(0xff0057D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, yellowPaint);

    const double arcLength = 0.70;

    final starts = [
      -pi / 2
      -0.3, // Top
      -0.30, // Right
      1.20, // Bottom
      2.70, // Left
    ];

    for (final start in starts) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        arcLength,
        false,
        bluePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
