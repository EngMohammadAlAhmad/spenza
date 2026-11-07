import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/app_tab_selector.dart';

class SectionsHeader extends StatelessWidget {
  final int currentPage;
  final Function(int) onTabTapped;

  const SectionsHeader({
    super.key,
    required this.currentPage,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      style: AppHeaderStyle.light,
      backgroundColor: AppColors.backgroundLight,
      showBackButton: false,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(34.0),
        bottomRight: Radius.circular(34.0),
      ),
      padding: EdgeInsets.only(
        top: context.screenPadding.top + 8,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      titleWidget: Row(
        spacing: 16.0,
        children: [
          Text(
            'sections'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.2, end: 0.0),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.push(RoutePaths.search);
              },
              child: AbsorbPointer(
                child: AppSearchField(
                  readOnly: true,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
      bottomChild: AppTabSelector(
        selectedIndex: currentPage,
        onTabChanged: onTabTapped,
        items: [
          AppTabItem(title: 'categories'.tr()),
          AppTabItem(title: 'brands'.tr()),
        ],
      ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic);
  }
}
