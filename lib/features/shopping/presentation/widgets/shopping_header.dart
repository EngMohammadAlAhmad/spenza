import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/app_search_field.dart';

class ShoppingHeader extends StatelessWidget {
  final int currentPage;
  final Function(int) onTabTapped;

  const ShoppingHeader({
    super.key,
    required this.currentPage,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16.0,
        right: 16.0,
        bottom: 24.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.0),
          bottomRight: Radius.circular(34.0),
        ),
      ),
      child: Column(
        children: [
          // Header with Search and Title
          Row(
            spacing: 16.0,
            children: [
              Text(
                'تسوّق',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const Expanded(
                child: AppSearchField(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Selector (Tabs)
          Container(
            height: 54.0,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: AppRadius.extra4Large,
            ),
            child: Row(
              children: [
                // Categories Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabTapped(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: currentPage == 0
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: AppRadius.extra4Large,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'التصنيفات',
                        style: TextStyle(
                          color: currentPage == 0
                              ? Colors.white
                              : AppColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Brands Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabTapped(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: currentPage == 1
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: AppRadius.extra4Large,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'الماركات',
                        style: TextStyle(
                          color: currentPage == 1
                              ? Colors.white
                              : AppColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1000.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut);
  }
}
