import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class FreeDeliveryCard extends StatelessWidget {
  const FreeDeliveryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: AppRadius.brandRadius,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // News Ticker Background
          Positioned.fill(
            left: -100.0,
            right: -100.0,
            child: SvgPicture.asset(
              AppAssets.containerBackground,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.1), BlendMode.srcIn),
            ).animate(onPlay: (controller) => controller.repeat())
             .moveX(begin: -20, end: 20, duration: 3.seconds, curve: Curves.linear)
             .then()
             .moveX(begin: 20, end: -20, duration: 3.seconds, curve: Curves.linear),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.75),
            child: Row(
              spacing: 16.0,
              children: [
                // Highway driving bounce animation
                Image.asset(AppAssets.deliveryImage)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .moveY(begin: -2.5, end: 2.5, duration: 600.ms, curve: Curves.easeInOut),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.neutralBackgroundInverse,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RichTyperAnimatedText(
                                boldText: 'free_delivery_damascus'.tr(),
                                normalText: 'for_orders_above_1500'.tr(),
                                speed: const Duration(milliseconds: 60),
                              ),
                            ],
                            repeatForever: true,
                            pause: const Duration(seconds: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RichTyperAnimatedText extends TyperAnimatedText {
  final String boldText;
  final String normalText;
  late Animation<double> _animation;

  RichTyperAnimatedText({
    required this.boldText,
    required this.normalText,
    super.speed = const Duration(milliseconds: 60),
    super.textStyle,
    super.textAlign,
    super.curve,
  }) : super('$boldText$normalText');

  @override
  void initAnimation(AnimationController controller) {
    _animation = CurveTween(curve: curve).animate(controller);
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final count = (text.length * _animation.value).round();
    final boldLen = boldText.length;

    final currentBold = count <= boldLen ? boldText.substring(0, count) : boldText;
    final currentNormal = count > boldLen ? normalText.substring(0, count - boldLen) : '';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: currentBold,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.neutralBackgroundInverse,
            ),
          ),
          TextSpan(
            text: currentNormal,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.neutralBackgroundInverse,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
      style: textStyle,
    );
  }

  @override
  Widget completeText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.neutralBackgroundInverse,
            ),
          ),
          TextSpan(
            text: normalText,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: AppColors.neutralBackgroundInverse,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
      style: textStyle,
    );
  }
}
