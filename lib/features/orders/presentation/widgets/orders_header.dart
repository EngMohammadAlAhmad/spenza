import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/cart_header_icon_button.dart';

class OrdersHeader extends StatelessWidget {
  final int selectedTabIndex;
  final int activeCount;
  final int completedCount;
  final ValueChanged<int> onTabChanged;

  const OrdersHeader({
    super.key,
    required this.selectedTabIndex,
    required this.activeCount,
    required this.completedCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      style: AppHeaderStyle.light,
      title: 'my_orders'.tr(),
      showBackButton: false,
      trailingActions: const [CartHeaderIconButton()],
      titleTextStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColors.neutral900,
      ),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28.0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0.0, 4.0),
        ),
      ],
      padding: EdgeInsets.only(
        top: context.screenPadding.top + 12.0,
        left: 20.0,
        right: 20.0,
        bottom: 18.0,
      ),
      bottomChild: Container(
        height: 48.0,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.neutralBackground,
          borderRadius: AppRadius.extraLarge,
        ),
        child: Stack(
          children: [
            // Sliding Indicator Pill
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.fastOutSlowIn,
              alignment: selectedTabIndex == 0
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: AppRadius.large,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tab Option Items
            Row(
              children: [
                Expanded(
                  child: _buildTabItem(
                    context,
                    title: 'active_orders'.tr(),
                    count: activeCount,
                    isSelected: selectedTabIndex == 0,
                    onTap: () => onTabChanged(0),
                  ),
                ),
                Expanded(
                  child: _buildTabItem(
                    context,
                    title: 'previous_orders'.tr(),
                    count: completedCount,
                    isSelected: selectedTabIndex == 1,
                    onTap: () => onTabChanged(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required String title,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const activeTextColor = Color(0xFF91292B);
    const inactiveTextColor = Color(0xFF7D7873);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
              child: Text(title),
            ),
            const SizedBox(width: 8.0),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
              constraints: const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFE2DDD7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11.0,
                  fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeTextColor : inactiveTextColor,
                ),
                child: Text('$count'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
