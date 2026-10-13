import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/images/cart_empty.svg',
            width: 220,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32.0),
          const Text(
            'سلتك لسا فاضية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'دور على يلي بدك ياه، ومنوصله لعندك.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          CustomButton(
            text: 'ابداً التسوق',
            height: 52.0,
            onPressed: () {
              context.go(RoutePaths.home);
            },
          ),
        ],
      ),
    );
  }
}
