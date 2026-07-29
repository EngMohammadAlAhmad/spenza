import 'dart:math';
import 'package:flutter/material.dart';

class CircularRevealRoute extends PageRouteBuilder {
  final Widget page;
  final Offset center;

  CircularRevealRoute({required this.page, required this.center})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ClipPath(
              clipper: CircularRevealClipper(
                fraction: animation.value,
                center: center,
              ),
              child: child,
            );
          },
        );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    // Calculate the distance to the farthest corner
    double maxRadius = _calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: maxRadius * fraction,
        ),
      );
  }

  double _calcMaxRadius(Size size, Offset center) {
    final double w = max(center.dx, size.width - center.dx);
    final double h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}
