import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_tab_selector.dart';

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
      bottomChild: AppTabSelector(
        selectedIndex: selectedTabIndex,
        onTabChanged: onTabChanged,
        backgroundColor: AppColors.neutralBackground,
        activeTextColor: const Color(0xFF91292B),
        inactiveTextColor: const Color(0xFF7D7873),
        indicatorShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        items: [
          AppTabItem(
            title: 'active_orders'.tr(),
            count: activeCount,
          ),
          AppTabItem(
            title: 'previous_orders'.tr(),
            count: completedCount,
          ),
        ],
      ),
    );
  }
}
