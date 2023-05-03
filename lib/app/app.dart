import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_hover/app/circular_text.dart';

import 'grayscale_image.dart';

List<String> images = [
  'assets/images/img1.jpg',
  'assets/images/img2.jpg',
  'assets/images/img3.jpg',
];

List<String> titles = [
  'Lorem ipsum dolor sit amet, consectetur. ',
  'Proin sodales le odio, ac nisi interdum. ',
  'Quisque turpis volutpat, faucibus metus. ',
];

double normalize({
  required double min,
  required double max,
  required double data,
}) {
  return (data - min) / (max - min) > 1
      ? 1
      : (data - min) / (max - min) < 0
          ? 0
          : (data - min) / (max - min);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Offset offset = const Offset(0, 0);

  Size get _size => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = _size.width / 3;
    final cardHeight = _size.height;
    const minPadding = 12.0;
    final maxPadding = _size.width * 0.02;

    return Scaffold(
      body: ColoredBox(
        color: Colors.black87,
        child: SizedBox(
          width: _size.width,
          height: _size.height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: images.length,
              childAspectRatio: cardWidth / cardHeight,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];

              final onHover = (offset.dx > (cardWidth * index + minPadding) && offset.dx < cardWidth * (index + 1) - minPadding) &&
                  (offset.dy > minPadding && offset.dy < _size.height - minPadding);

              return MouseRegion(
                onHover: (PointerEvent? details) {
                  setState(() {
                    offset = Offset(details!.position.dx, details.position.dy);
                  });
                },
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 480),
                  width: cardWidth,
                  height: cardHeight,
                  padding: EdgeInsets.all(onHover ? minPadding : maxPadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Center(
                          child: Opacity(
                            opacity: 0.25,
                            child: SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: GrayscaleImage(
                                imagePath: image,
                              ),
                            ),
                          ),
                        ),
                        if (onHover)
                          Center(
                            child: ClipPath(
                              clipper: CustomCircleClipper(
                                offset: Offset(offset.dx - (cardWidth * index), offset.dy),
                              ),
                              child: SizedBox(
                                width: cardWidth,
                                height: cardHeight,
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        if (onHover)
                          Positioned(
                            top: offset.dy - 240,
                            left: (offset.dx - (cardWidth * index)) - 240,
                            child: Transform.rotate(
                              angle: pi * 2 * controller.value,
                              child: Opacity(
                                opacity: 0.5,
                                child: CircularText(
                                  text: titles[index].toUpperCase(),
                                  radius: 240,
                                  fontSize: 44,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomCircleClipper extends CustomClipper<Path> {
  final Offset offset;

  CustomCircleClipper({required this.offset});
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: offset,
          width: 360,
          height: 360,
        ),
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
