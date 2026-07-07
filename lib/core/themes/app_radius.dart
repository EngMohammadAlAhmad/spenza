import 'package:flutter/material.dart';

class AppRadius {
  static final BorderRadius mini = .circular(4.0);
  static final BorderRadius tine = .circular(6.0);
  static final BorderRadius small = .circular(8.0);
  static final BorderRadius ordinary = .circular(10.0);
  static final BorderRadius medium = .circular(12.0);
  static final BorderRadius overMedium = .circular(16.0);
  static final BorderRadius upMedium = .circular(18.0);
  static final BorderRadius large = .circular(20.0);
  static final BorderRadius extraLarge = .circular(24.0);
  static final BorderRadius extraLarge2 = .circular(25.0);
  static final BorderRadius extraLarge3 = .circular(28.0);
  static final BorderRadius extra2Large = .circular(32.0);

  // Or using individual radius values
  static const double smallValue = 4;
  static const double mediumValue = 8;
  static const double largeValue = 12;
  static const double extraLargeValue = 16;

  // Specific corner radius if needed
  static const BorderRadius topOnly = .only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
  );
}