import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class ProductQuantitySection extends StatelessWidget {
  final int quantity;
  final int maxQty;
  final String unitTitle;
  final ValueChanged<int> onQuantityChanged;

  const ProductQuantitySection({
    super.key,
    required this.quantity,
    required this.maxQty,
    required this.unitTitle,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'quantity'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (maxQty > 0) ...[
                const SizedBox(height: 3.0),
                Text(
                  'max_qty_per_order'.tr(args: ['$maxQty', unitTitle]),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ],
          ),
          ProductQuantitySelector(
            quantity: quantity,
            maxQty: maxQty,
            onQuantityChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}

class ProductQuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQty;
  final ValueChanged<int> onQuantityChanged;

  const ProductQuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQty,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool canDecrease = quantity > 1;
    final bool canIncrease = maxQty > 0 && quantity < maxQty;

    return Container(
      height: 48.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: canDecrease ? () => onQuantityChanged(-1) : null,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.remove,
                  size: 24.0,
                  color: canDecrease ? Colors.black87 : AppColors.neutral.withValues(alpha: 0.4),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 38.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.center,
              child: AnimatedFlipCounter(
                value: quantity,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: canIncrease ? () => onQuantityChanged(1) : null,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 24.0,
                  color: canIncrease ? Colors.black87 : AppColors.neutral.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedFlipCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  const AnimatedFlipCounter({super.key, required this.value, this.style});

  @override
  State<AnimatedFlipCounter> createState() => _AnimatedFlipCounterState();
}

class _AnimatedFlipCounterState extends State<AnimatedFlipCounter> {
  int? _oldValue;

  @override
  void didUpdateWidget(covariant AnimatedFlipCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncrement = _oldValue == null || widget.value > _oldValue!;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isNew = child.key == ValueKey<int>(widget.value);

          final Offset begin = isIncrement
              ? (isNew ? const Offset(0.0, 1.2) : const Offset(0.0, -1.2))
              : (isNew ? const Offset(0.0, -1.2) : const Offset(0.0, 1.2));

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: animation.drive(
                Tween<Offset>(begin: begin, end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeOutCubic),
                ),
              ),
              child: child,
            ),
          );
        },
        child: Text(
          widget.value.toString(),
          key: ValueKey<int>(widget.value),
          style: widget.style ?? Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
