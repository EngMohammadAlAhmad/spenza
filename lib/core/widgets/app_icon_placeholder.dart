import 'package:flutter/material.dart';

class AppIconPlaceholder extends StatelessWidget {
  final double size;
  final Color? color;
  final double padding;

  const AppIconPlaceholder({
    super.key,
    this.size = 40.0,
    this.color,
    this.padding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          'assets/images/app_icon.png',
          width: size,
          height: size,
          color: color ?? Colors.grey[300],
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_outlined,
            size: size,
            color: color ?? Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
