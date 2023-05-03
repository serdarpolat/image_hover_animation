import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularText extends StatelessWidget {
  final String text;
  final double radius;
  final double fontSize;
  final Color color;

  const CircularText({Key? key, required this.text, required this.radius, required this.fontSize, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: CircularTextPainter(text, radius, fontSize, color),
    );
  }
}

class CircularTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final double fontSize;
  final Color color;

  CircularTextPainter(this.text, this.radius, this.fontSize, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
    final textSpan = TextSpan(text: text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final anglePerLetter = math.pi * 2 / text.length;

    for (int i = 0; i < text.length; i++) {
      final letter = text[i];

      final letterPainter = TextPainter(
        text: TextSpan(text: letter, style: textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      letterPainter.layout();

      final xPos = math.cos(i * anglePerLetter) * radius;
      final yPos = math.sin(i * anglePerLetter) * radius;

      canvas.save();
      canvas.translate(radius + xPos, radius + yPos);
      canvas.rotate(i * anglePerLetter + math.pi / 2);
      letterPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CircularTextPainter oldDelegate) {
    return text != oldDelegate.text || radius != oldDelegate.radius;
  }
}
