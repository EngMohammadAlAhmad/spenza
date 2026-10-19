import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_search_field.dart';

class ProductDetailsHeader extends StatelessWidget {
  final String categoryName;
  final String brandName;

  const ProductDetailsHeader({
    super.key,
    required this.categoryName,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      style: AppHeaderStyle.light,
      showBackButton: false,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      titleWidget: Row(
        spacing: 8.0,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const Expanded(child: AppSearchField()),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_outlined, size: 20, color: AppColors.primary),
          ),
        ],
      ),
      bottomChild: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            brandName,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.neutral),
          Text(
            categoryName,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.neutral),
          const Text(
            ' التصنيفات ',
            style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
