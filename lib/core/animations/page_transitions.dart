import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransition { fadeThrough, sharedAxisScale, slideUp }

CustomTransitionPage<T> buildPage<T>({
  required Widget child,
  required GoRouterState state,
  AppTransition type = AppTransition.fadeThrough,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case AppTransition.slideUp:
          return SlideTransition(
            position: Tween(begin: const Offset(0, 0.08), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        case AppTransition.sharedAxisScale:
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween(begin: 0.94, end: 1.0).animate(animation),
              child: child,
            ),
          );
        case AppTransition.fadeThrough:
          return FadeTransition(opacity: animation, child: child);
      }
    },
  );
}