import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/app_header.dart';

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
      title: 'طلباتي',
      showBackButton: false,
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
        top: MediaQuery.of(context).padding.top + 12.0,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isRtl = Directionality.of(context) == TextDirection.rtl;
            final alignment = selectedTabIndex == 0
                ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                : (isRtl ? Alignment.centerLeft : Alignment.centerRight);

            return Stack(
              children: [
                // Sliding Indicator Pill
                AnimatedAlign(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.fastOutSlowIn,
                  alignment: alignment,
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
                        title: 'الحالية',
                        count: activeCount,
                        isSelected: selectedTabIndex == 0,
                        onTap: () => onTabChanged(0),
                      ),
                    ),
                    Expanded(
                      child: _buildTabItem(
                        context,
                        title: 'السابقة',
                        count: completedCount,
                        isSelected: selectedTabIndex == 1,
                        onTap: () => onTabChanged(1),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
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

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
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
