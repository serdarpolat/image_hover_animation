
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedCircularText extends StatelessWidget {
  const AnimatedCircularText({
    Key? key,
    required this.name,
    required this.email,
    required this.radius,
  }) : super(key: key);

  final String name;
  final String email;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder(
      tween: Tween(begin: 0.0, end: 2 * pi),
      duration: const Duration(seconds: 10),
      builder: (context, double value, child) {
        return Transform.rotate(
          angle: value,
          child: Opacity(
            opacity: 0.5,
            child: CircularText(
              position: CircularTextPosition.outside,
              children: [
                TextItem(
                  startAngle: 0,
                  space: 7.5,
                  startAngleAlignment: StartAngleAlignment.center,
                  text: Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextItem(
                  startAngle: 180,
                  space: 7.5,
                  startAngleAlignment: StartAngleAlignment.center,
                  direction: CircularTextDirection.clockwise,
                  text: Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              radius: radius,
            ),
          ),
        );
      },
    );
  }
}