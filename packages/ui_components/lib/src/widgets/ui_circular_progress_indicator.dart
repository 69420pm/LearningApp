import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class UICircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomCircularProgressIndicator(
        radius: 160, strokeWidth: 80, value: 0.4, color: Colors.green);
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double value;
  final Color color;

  CustomCircularProgressIndicator({
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double progressAngle = value * 2 * math.pi;

    return Container(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        foregroundPainter: _CustomProgressPainter(
          progressAngle: progressAngle,
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}

class _CustomProgressPainter extends CustomPainter {
  final double progressAngle;
  final double strokeWidth;
  final Color color;

  _CustomProgressPainter({
    required this.progressAngle,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    final arcPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = Colors.red;

    final debugPaint = Paint()..color = Colors.blue;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (-math.pi / 2), // Start angle (top)
      progressAngle,
      false,
      arcPaint,
    );
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2,size.height), debugPaint);
    canvas.drawCircle(Offset(size.width/2,0+strokeWidth/2), strokeWidth/2, circlePaint);
    canvas.rotate(10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
