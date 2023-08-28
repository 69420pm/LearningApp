// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UICircularProgressIndicator extends StatelessWidget {
  double value;
  UICircularProgressIndicator({
    super.key,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return CustomCircularProgressIndicator(
      radius: 24,
      strokeWidth: 6,
      value: value,
      color: UIColors.primary,
      backgroundColor: UIColors.overlay,
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  CustomCircularProgressIndicator({
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });
  final double radius;
  final double strokeWidth;
  final double value;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final progressAngle = value * 2 * math.pi;

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        foregroundPainter: _CustomProgressPainter(
          progressAngle: progressAngle,
          strokeWidth: strokeWidth,
          color: color,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}

class _CustomProgressPainter extends CustomPainter {
  _CustomProgressPainter({
    required this.progressAngle,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });
  final double progressAngle;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    final arcPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()..color = color;

    // angle of start rounding
    final startAngle =
        math.asin((strokeWidth * 0.5) / (size.width / 2 - strokeWidth / 2));
    // y of start rounding
    final startY = size.width / 2 -
        math.cos(startAngle) * (size.width / 2 - strokeWidth / 2);
    // x of end rounding
    final endX =
        math.sin(progressAngle) * (size.width / 2 - strokeWidth / 2);
    // y of end rounding
    final endY = size.width / 2 -
        math.cos(progressAngle) * (size.width / 2 - strokeWidth / 2);
    canvas
    // background arc
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (-math.pi / 2) + startAngle, // Start angle (top)
        360,
        false,
        backgroundPaint,
      )
    // "progress" arc
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (-math.pi / 2) + startAngle, // Start angle (top)
        progressAngle - startAngle,
        false,
        arcPaint,
      )
    // start rounding
      ..drawCircle(
        Offset(size.width / 2 + strokeWidth / 2, startY),
        strokeWidth / 2,
        circlePaint,
      )
    // end rounding
      ..drawCircle(
        Offset(size.width / 2 + endX, endY),
        strokeWidth / 2,
        circlePaint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
