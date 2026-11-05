import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/animations/circular_reveal_route.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/cart_header_icon_button.dart';
import 'package:spenza/features/search/presentation/screens/search_screen.dart';

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
        bottom: 24.0,
      ),
      titleWidget: Row(
        spacing: 16.0,
        children: [
          Text(
            'sections'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.2, end: 0.0),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                Navigator.push(
                  context,
                  CircularRevealRoute(
                    page: const SearchScreen(),
                    center: details.globalPosition,
                  ),
                );
              },
              child: AbsorbPointer(
                child: AppSearchField(
                  readOnly: true,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
          const CartHeaderIconButton(),
        ],
      ),
      bottomChild: Container(
        height: 48.0,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: AppRadius.extra4Large,
        ),
        child: Stack(
          children: [
            // Sliding Indicator Pill
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.fastOutSlowIn,
              alignment: currentPage == 0
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: AppRadius.extra4Large,
                  ),
                ),
              ),
            ),

            // Tab Buttons
            Row(
              children: [
                // Categories Tab
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTabTapped(0),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: currentPage == 0
                              ? AppColors.primaryBold
                              : AppColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text('categories'.tr()),
                      ),
                    ),
                  ),
                ),
                // Brands Tab
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTabTapped(1),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: currentPage == 1
                              ? AppColors.primaryBold
                              : AppColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text('brands'.tr()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic);
  }
}
