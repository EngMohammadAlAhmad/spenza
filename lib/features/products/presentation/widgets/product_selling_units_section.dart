import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';

class ProductSellingUnitsSection extends StatefulWidget {
  final List<ProductUnitEntity> units;
  final int selectedUnitId;
  final num defaultDiscountedPrice;
  final num defaultPrice;
  final NumberFormat formatter;
  final ValueChanged<int> onUnitSelected;

  const ProductSellingUnitsSection({
    super.key,
    required this.units,
    required this.selectedUnitId,
    required this.defaultDiscountedPrice,
    required this.defaultPrice,
    required this.formatter,
    required this.onUnitSelected,
  });

  @override
  State<ProductSellingUnitsSection> createState() => _ProductSellingUnitsSectionState();
}

class _ProductSellingUnitsSectionState extends State<ProductSellingUnitsSection> {
  late final ScrollController _scrollController;
  int _currentIndex = 0;
  double _scrollProgress = 0.0;

  static const double _itemWidth = 180.0;
  static const double _itemSpacing = 12.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final initialIndex = widget.units.indexWhere((u) => u.id == widget.selectedUnitId);
    if (initialIndex > 0) {
      _currentIndex = initialIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(initialIndex, animate: false);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ProductSellingUnitsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUnitId != widget.selectedUnitId) {
      final index = widget.units.indexWhere((u) => u.id == widget.selectedUnitId);
      if (index != -1 && index != _currentIndex) {
        _scrollToIndex(index);
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset.clamp(0.0, maxScroll > 0 ? maxScroll : 1.0);
    final progress = maxScroll > 0 ? (currentOffset / maxScroll) : 0.0;

    int calculatedIndex = 0;
    if (widget.units.length > 1 && maxScroll > 0) {
      if (currentOffset >= maxScroll - 5.0) {
        calculatedIndex = widget.units.length - 1;
      } else {
        final step = maxScroll / (widget.units.length - 1);
        calculatedIndex = (currentOffset / step).round();
      }
    }
    calculatedIndex = calculatedIndex.clamp(0, widget.units.length - 1);

    if ((progress - _scrollProgress).abs() > 0.001 || calculatedIndex != _currentIndex) {
      setState(() {
        _scrollProgress = progress.clamp(0.0, 1.0);
        _currentIndex = calculatedIndex;
      });
    }
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    double targetOffset;
    if (index == widget.units.length - 1) {
      targetOffset = maxScroll;
    } else if (index == 0) {
      targetOffset = 0.0;
    } else {
      final step = maxScroll / (widget.units.length - 1);
      targetOffset = index * step;
    }

    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'selling_unit'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (widget.units.length > 1) ...[
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: AppRadius.extra2Large,
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.units.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                          ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              'price_varies_by_unit'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.neutral,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),

        // Scrollable Horizontal Units Cards
        SizedBox(
          height: 114.0,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.units.length,
            separatorBuilder: (_, _) => const SizedBox(width: _itemSpacing),
            itemBuilder: (context, index) {
              final u = widget.units[index];
              final isSelected = u.id == widget.selectedUnitId;

              final num uPrice = u.discountedPrice > 0
                  ? u.discountedPrice
                  : (u.price > 0 ? u.price : widget.defaultDiscountedPrice);
              final num uOriginalPrice = u.price > 0 ? u.price : widget.defaultPrice;
              final bool hasDiscount = uOriginalPrice > uPrice;

              return GestureDetector(
                onTap: () {
                  widget.onUnitSelected(u.id);
                  _scrollToIndex(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _itemWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryTint : Colors.white,
                    borderRadius: AppRadius.overMedium,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.fillColor,
                      width: isSelected ? 2.0 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Unit Title + Selection Checkmark Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              u.title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.primaryDark : null,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : AppColors.neutral200.withValues(alpha: 0.6),
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 13.0,
                              color: isSelected ? Colors.white : Colors.transparent,
                            ),
                          ),
                        ],
                      ),

                      // Capacity / Subtitle
                      Text(
                        u.baseMultiplies > 1
                            ? '${widget.formatter.format(u.baseMultiplies)} ${'piece_unit'.tr()}'
                            : '1 ${'piece_unit'.tr()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected ? AppColors.primary600 : AppColors.tertiary,
                              fontSize: 12.0,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${widget.formatter.format(uPrice)} ${'sp_currency'.tr()}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 6.0),
                            Text(
                              widget.formatter.format(uOriginalPrice),
                              style: const TextStyle(
                                color: AppColors.neutral,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Creative Horizontal Scroll Index & Progress Indicator
        if (widget.units.length > 1) ...[
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Scroll track with sliding thumb
              Container(
                width: 64.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: AppRadius.extra2Large,
                ),
                child: Align(
                  alignment: AlignmentDirectional(
                    -1.0 + (2.0 * _scrollProgress),
                    0.0,
                  ),
                  child: Container(
                    width: (64.0 / widget.units.length).clamp(16.0, 32.0),
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.extra2Large,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
            ],
          ),
        ],
      ],
    );
  }
}
