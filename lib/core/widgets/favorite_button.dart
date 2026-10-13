import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';

class FavoriteButton extends StatefulWidget {
  final double size;
  final Color? color;
  final bool initialFavorite;
  final void Function(bool isFavorite)? onFavoriteChanged;

  const FavoriteButton({
    super.key,
    this.size = 22.0,
    this.color,
    this.initialFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialFavorite;
  }

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFavorite != widget.initialFavorite) {
      _isFavorite = widget.initialFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isFavorite = !_isFavorite);
        if (widget.onFavoriteChanged != null) {
          widget.onFavoriteChanged!(_isFavorite);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          size: widget.size,
          color: _isFavorite ? Colors.red : (widget.color ?? AppColors.neutral),
        ).animate(target: _isFavorite ? 1 : 0)
            .scaleXY(begin: 1.0, end: 1.3, duration: 150.ms)
            .then()
            .scaleXY(begin: 1.3, end: 1.0, duration: 150.ms),
      ),
    );
  }
}
