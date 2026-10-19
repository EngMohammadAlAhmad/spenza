import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';

enum AppHeaderStyle {
  light,
  gradient,
  transparent,
}

class AppHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? backButtonIcon;
  final List<Widget>? trailingActions;
  final Widget? trailingWidget;
  final Widget? bottomChild;
  final AppHeaderStyle style;
  final Color? backgroundColor;
  final Gradient? gradient;
  final String? patternAsset;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final AlignmentGeometry? titleAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.backButtonIcon,
    this.trailingActions,
    this.trailingWidget,
    this.bottomChild,
    this.style = AppHeaderStyle.light,
    this.backgroundColor,
    this.gradient,
    this.patternAsset = 'assets/images/pattern.png',
    this.height,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.titleAlignment,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    BoxDecoration decoration;
    switch (style) {
      case AppHeaderStyle.gradient:
        decoration = BoxDecoration(
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  Color(0xFF91292B),
                  Color(0xFFC74436),
                  Color(0xFFD46B60),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
          borderRadius: borderRadius ??
              const BorderRadius.vertical(
                bottom: Radius.circular(32.0),
              ),
        );
        break;
      case AppHeaderStyle.transparent:
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius,
        );
        break;
      case AppHeaderStyle.light:
        decoration = BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: borderRadius ??
              const BorderRadius.vertical(
                bottom: Radius.circular(28.0),
              ),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0.0, 5.0),
                ),
              ],
        );
        break;
    }

    final defaultTitleStyle = style == AppHeaderStyle.gradient
        ? const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          )
        : Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          );

    final defaultSubtitleStyle = style == AppHeaderStyle.gradient
        ? TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 13.0,
          )
        : const TextStyle(
            fontSize: 13.0,
            color: AppColors.neutral,
          );

    final effectivePadding = padding ??
        EdgeInsets.only(
          top: topPadding + (style == AppHeaderStyle.gradient ? 10.0 : 8.0),
          left: 16.0,
          right: 16.0,
          bottom: bottomChild != null ? 18.0 : 12.0,
        );

    final defaultBackButton = style == AppHeaderStyle.gradient
        ? IconButton(
            onPressed: onBackPressed ??
                () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 28.0,
            ),
          )
        : GestureDetector(
            onTap: onBackPressed ??
                () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
            child: SvgPicture.asset(
              'assets/icons/back_button_2.svg',
              width: 40,
              height: 40,
            ),
          );

    Widget headerContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Header Row
        Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (showBackButton) ...[
              backButtonIcon ?? defaultBackButton,
              const SizedBox(width: 10.0),
            ],
            // Title & Subtitle or Title Widget
            if (titleWidget != null)
              Expanded(child: titleWidget!)
            else if (title != null)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: titleTextStyle ?? defaultTitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitleWidget != null) ...[
                      const SizedBox(height: 2.0),
                      subtitleWidget!,
                    ] else if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle!,
                        style: subtitleTextStyle ?? defaultSubtitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            if (trailingWidget != null) ...[
              trailingWidget!,
            ] else if (trailingActions != null && trailingActions!.isNotEmpty) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: trailingActions!,
              ),
            ],
          ],
        ),
        if (bottomChild != null) ...[
          const SizedBox(height: 12.0),
          bottomChild!,
        ],
      ],
    );

    if (titleAlignment != null) {
      headerContent = Container(
        alignment: titleAlignment,
        child: headerContent,
      );
    }

    return Container(
      height: height ??
          (bottomChild == null && style == AppHeaderStyle.light
              ? topPadding + 60.0
              : null),
      width: double.infinity,
      decoration: decoration,
      child: Stack(
        children: [
          if (style == AppHeaderStyle.gradient && patternAsset != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius ??
                    const BorderRadius.vertical(
                      bottom: Radius.circular(32.0),
                    ),
                child: Image.asset(
                  patternAsset!,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.08),
                ),
              ),
            ),
          Padding(
            padding: effectivePadding,
            child: headerContent,
          ),
        ],
      ),
    );
  }
}
