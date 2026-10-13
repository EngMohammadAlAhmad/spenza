import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Text(
                    'طلباتي',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ),
              ),

              // Segmented Tab Selector
              Container(
                height: 48.0,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: AppColors.neutralBackground,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    // Active Tab (الحالية)
                    Expanded(
                      child: _buildTabItem(
                        context,
                        title: 'الحالية',
                        count: activeCount,
                        isSelected: selectedTabIndex == 0,
                        onTap: () => onTabChanged(0),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    // Completed Tab (السابقة)
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
              ),
            ],
          ),
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
    final activeBgColor = AppColors.primaryTint;
    final activeTextColor = const Color(0xFF91292B);
    final inactiveTextColor = const Color(0xFF7D7873);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
              constraints: const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFFE2DDD7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeTextColor : inactiveTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
