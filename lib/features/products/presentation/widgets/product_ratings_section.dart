import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class ProductRatingsSection extends StatelessWidget {
  final num rate;
  final int ratingsCount;

  const ProductRatingsSection({
    super.key,
    required this.rate,
    required this.ratingsCount,
  });

  @override
  Widget build(BuildContext context) {
    final formattedRate =
        rate % 1 == 0 ? rate.toInt().toString() : rate.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Title
        Text(
          'ratings'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12.0),
        // Rating Details
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedRate,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final double starRating = rate.toDouble();
                    final int fullStars = starRating.floor();
                    final bool hasHalfStar = (starRating - fullStars) >= 0.3 &&
                        (starRating - fullStars) <= 0.7;

                    IconData icon = Icons.star_rounded;
                    Color color;

                    if (starRating <= 0) {
                      color = AppColors.grey;
                    } else if (index < fullStars) {
                      color = AppColors.secondary;
                    } else if (index == fullStars &&
                        (starRating - fullStars) > 0.7) {
                      color = AppColors.secondary;
                    } else if (index == fullStars && hasHalfStar) {
                      icon = Icons.star_half_rounded;
                      color = AppColors.secondary;
                    } else if (index == fullStars &&
                        (starRating - fullStars) > 0) {
                      color = AppColors.secondary;
                    } else {
                      color = AppColors.grey;
                    }

                    return Icon(
                      icon,
                      color: color,
                      size: 14.0,
                    );
                  }),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'ratings_from_count'.tr(args: [ratingsCount.toString()]),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.neutral,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
