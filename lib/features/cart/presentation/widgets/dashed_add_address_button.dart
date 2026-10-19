import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class DashedAddAddressButton extends StatelessWidget {
  final VoidCallback onTap;

  const DashedAddAddressButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: DashedBorderPainter(
        color: AppColors.primary500,
        strokeWidth: 1.5,
        dashWidth: 6.0,
        dashSpace: 4.0,
        borderRadius: 18.0,
      ),
      child: Material(
        color: const Color(0xFFFDF2F2),
        borderRadius: AppRadius.upMedium,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.upMedium,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: AppColors.primary500,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'ضيف عنوان جديد',
                  style: TextStyle(
                    color: AppColors.primary500,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.borderRadius = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path, dashWidth, dashSpace);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = dashWidth.clamp(0.0, metric.length - distance);
        dest.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
