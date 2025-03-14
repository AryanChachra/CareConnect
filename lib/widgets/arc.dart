import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final Color color;

  ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 70, size.width, 30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}