import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

/// Representation of an individual tab item in [AppTabSelector].
class AppTabItem {
  final String title;
  final int? count;

  const AppTabItem({
    required this.title,
    this.count,
  });
}

/// A reusable, highly customizable segmented tab selector widget with sliding indicator pill.
///
/// Defaults to using [AppRadius.brandRadius] for both the outer container
/// and the inner selected item container.
class AppTabSelector extends StatelessWidget {
  /// List of tab items to render.
  final List<AppTabItem> items;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTabChanged;

  /// Border radius of the outer container. Defaults to [AppRadius.brandRadius].
  final BorderRadiusGeometry borderRadius;

  /// Border radius of the sliding indicator container.
  /// If null, defaults to [borderRadius] (which is [AppRadius.brandRadius]).
  final BorderRadiusGeometry? indicatorRadius;

  /// Background color of the outer container. Defaults to [AppColors.containerBoxBackground].
  final Color? backgroundColor;

  /// Color of the sliding selected item container (pill). Defaults to [AppColors.primaryTint].
  final Color? indicatorColor;

  /// Box shadow list applied to the sliding indicator pill.
  final List<BoxShadow>? indicatorShadow;

  /// Total height of the selector container. Defaults to `48.0`.
  final double height;

  /// Padding inside the outer container around the sliding pill and tabs. Defaults to `EdgeInsets.all(4.0)`.
  final EdgeInsetsGeometry padding;

  /// Duration of the sliding pill animation. Defaults to `280ms`.
  final Duration animationDuration;

  /// Curve of the sliding pill animation. Defaults to [Curves.fastOutSlowIn].
  final Curve animationCurve;

  /// Text color when tab is selected. Defaults to [AppColors.primaryBold].
  final Color? activeTextColor;

  /// Text color when tab is unselected. Defaults to [AppColors.neutral].
  final Color? inactiveTextColor;

  /// Background color of the count badge when tab is selected. Defaults to [Colors.white].
  final Color? activeBadgeBackgroundColor;

  /// Background color of the count badge when tab is unselected. Defaults to `Color(0xFFE2DDD7)`.
  final Color? inactiveBadgeBackgroundColor;

  /// Text color of the count badge when selected. If null, uses [activeTextColor].
  final Color? activeBadgeTextColor;

  /// Text color of the count badge when unselected. If null, uses [inactiveTextColor].
  final Color? inactiveBadgeTextColor;

  /// Text style applied to tab titles.
  final TextStyle? titleTextStyle;

  const AppTabSelector({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTabChanged,
    this.borderRadius = AppRadius.brandRadius,
    this.indicatorRadius,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorShadow,
    this.height = 44.0,
    this.padding = const EdgeInsets.all(4.0),
    this.animationDuration = const Duration(milliseconds: 280),
    this.animationCurve = Curves.fastOutSlowIn,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeBadgeBackgroundColor,
    this.inactiveBadgeBackgroundColor,
    this.activeBadgeTextColor,
    this.inactiveBadgeTextColor,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIndicatorRadius = indicatorRadius ?? borderRadius;
    final isDark = AppColors.isDarkMode(context);

    final effectiveBackgroundColor = backgroundColor ?? AppColors.containerBoxBackgroundColor(context);
    final effectiveIndicatorColor = indicatorColor ??
        (isDark ? const Color(0xFF42201D) : AppColors.primaryTint);
    final effectiveActiveTextColor = activeTextColor ??
        (isDark ? AppColors.primaryLight : AppColors.primaryBold);
    final effectiveInactiveTextColor = inactiveTextColor ?? AppColors.secondaryTextColor(context);
    final effectiveActiveBadgeBackgroundColor = activeBadgeBackgroundColor ??
        (isDark ? AppColors.cardDark : Colors.white);
    final effectiveInactiveBadgeBackgroundColor = inactiveBadgeBackgroundColor ??
        (isDark ? const Color(0xFF383634) : const Color(0xFFE2DDD7));

    final AlignmentDirectional alignment = items.length <= 1
        ? AlignmentDirectional.center
        : AlignmentDirectional(
            -1.0 + (2.0 * selectedIndex / (items.length - 1)),
            0.0,
          );

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          // Sliding Indicator Pill
          AnimatedAlign(
            duration: animationDuration,
            curve: animationCurve,
            alignment: alignment,
            child: FractionallySizedBox(
              widthFactor: items.isNotEmpty ? 1.0 / items.length : 1.0,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  borderRadius: effectiveIndicatorRadius,
                  boxShadow: indicatorShadow,
                ),
              ),
            ),
          ),

          // Tab Option Items
          Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(index),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: (titleTextStyle ?? Theme.of(context).textTheme.bodyLarge!).copyWith(
                            color: isSelected ? effectiveActiveTextColor : effectiveInactiveTextColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          child: Text(item.title),
                        ),
                        if (item.count != null) ...[
                          const SizedBox(width: 8.0),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20.0,
                            height: 20.0,
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? effectiveActiveBadgeBackgroundColor
                                  : effectiveInactiveBadgeBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? (activeBadgeTextColor ?? effectiveActiveTextColor)
                                      : (inactiveBadgeTextColor ?? effectiveInactiveTextColor),
                                ),
                                child: Text(
                                  item.count! > 99 ? '+99' : '${item.count}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
