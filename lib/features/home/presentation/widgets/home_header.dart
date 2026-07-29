import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/dimens.dart';
import 'package:spenza/core/widgets/app_search_field.dart';

import 'package:spenza/core/utils/animations/circular_reveal_route.dart';
import 'package:spenza/features/search/presentation/screens/search_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 186.44,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.0,
        right: 16.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.0),
          bottomRight: Radius.circular(34.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              SvgPicture.asset('assets/icons/location_icon.svg'),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'التوصيل إلى',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.neutral),
                  ),
                  Text(
                    'المنزل - دمشق',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/temp.svg'),
              ),
            ],
          ),
          GestureDetector(
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
            child: const AbsorbPointer(
              child: AppSearchField(
                readOnly: true,
              ),
            ),
          ),
          SizedBox(height: AppDimens.spaceS),
        ],
      ),
    ).animate().fadeIn(duration: 1000.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut);
  }
}
