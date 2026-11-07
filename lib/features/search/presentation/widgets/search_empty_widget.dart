import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class SearchEmptyWidget extends StatelessWidget {
  final String searchQuery;

  const SearchEmptyWidget({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasQuery = searchQuery.trim().isNotEmpty;
    final String title = hasQuery
        ? 'no_search_results_query'.tr(args: [searchQuery.trim()])
        : 'no_search_results'.tr();
    final String subtitle = 'no_search_results_subtitle'.tr();

    return Column(
      children: [
        // Top scrollable content
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated Search Empty State Illustration
                  SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer soft pink/red circle with pulse scale animation
                        Container(
                          width: 160.0,
                          height: 160.0,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTint,
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate(
                              key: const ValueKey('search_empty_outer_circle'),
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .scaleXY(
                              begin: 0.9,
                              end: 1.08,
                              duration: 2.seconds,
                              curve: Curves.easeInOut,
                            ),

                        // Middle white circle with subtle floating & scale animation
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppAssets.searchIcon,
                            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                            height: 44.0,
                            width: 44.0,
                          )
                              .animate(
                                key: const ValueKey('search_empty_icon'),
                                onPlay: (c) => c.repeat(reverse: true),
                              )
                              .moveY(
                                begin: -4,
                                end: 4,
                                duration: 1.5.seconds,
                                curve: Curves.easeInOut,
                              )
                              .scaleXY(
                                begin: 0.95,
                                end: 1.05,
                                duration: 1.5.seconds,
                                curve: Curves.easeInOut,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Title Text: e.g. ما لقينا «مسطرة ليزر»
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(key: const ValueKey('search_empty_title'))
                      .fadeIn(delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 10.0),

                  // Subtitle Text: e.g. جرب كلمة أقصر أو اسم الماركة، أو تصفح التصنيفات.
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(key: const ValueKey('search_empty_desc'))
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),

        // Fixed Bottom Container surrounded with white area & rounded top border
        AppBottomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: CustomButton(
            text: 'browse_categories'.tr(),
            height: 48.0,
            onPressed: () {
              context.go(RoutePaths.categories);
            },
          )
              .animate(key: const ValueKey('search_empty_btn'))
              .fadeIn(delay: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ),
      ],
    );
  }
}
