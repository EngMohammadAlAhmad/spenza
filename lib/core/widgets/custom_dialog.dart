import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class AppCustomDialog extends StatefulWidget {
  final Widget? icon;
  final IconData? iconData;
  final Color iconColor;
  final Color? iconBackgroundColor;
  final String title;
  final String? description;
  final Widget? content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final Color primaryButtonColor;
  final Color primaryTextColor;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final Color secondaryButtonColor;
  final Color secondaryTextColor;
  final bool isLoading;

  const AppCustomDialog({
    super.key,
    this.icon,
    this.iconData,
    this.iconColor = AppColors.primary500,
    this.iconBackgroundColor,
    required this.title,
    this.description,
    this.content,
    this.primaryButtonText = 'تأكيد',
    this.onPrimaryPressed,
    this.primaryButtonColor = AppColors.primary500,
    this.primaryTextColor = Colors.white,
    this.secondaryButtonText = 'إلغاء',
    this.onSecondaryPressed,
    this.secondaryButtonColor = const Color(0xFFF3F4F6),
    this.secondaryTextColor = AppColors.neutral900,
    this.isLoading = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? icon,
    IconData? iconData,
    Color iconColor = AppColors.primary500,
    Color? iconBackgroundColor,
    required String title,
    String? description,
    Widget? content,
    String primaryButtonText = 'تأكيد',
    VoidCallback? onPrimaryPressed,
    Color primaryButtonColor = AppColors.primary500,
    Color primaryTextColor = Colors.white,
    String? secondaryButtonText = 'إلغاء',
    VoidCallback? onSecondaryPressed,
    Color secondaryButtonColor = const Color(0xFFF3F4F6),
    Color secondaryTextColor = AppColors.neutral900,
    bool isLoading = false,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppCustomDialog(
          icon: icon,
          iconData: iconData,
          iconColor: iconColor,
          iconBackgroundColor: iconBackgroundColor,
          title: title,
          description: description,
          content: content,
          primaryButtonText: primaryButtonText,
          onPrimaryPressed: onPrimaryPressed,
          primaryButtonColor: primaryButtonColor,
          primaryTextColor: primaryTextColor,
          secondaryButtonText: secondaryButtonText,
          onSecondaryPressed: onSecondaryPressed,
          secondaryButtonColor: secondaryButtonColor,
          secondaryTextColor: secondaryTextColor,
          isLoading: isLoading,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0 * animation.value,
            sigmaY: 3.0 * animation.value,
          ),
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<AppCustomDialog> createState() => _AppCustomDialogState();
}

class _AppCustomDialogState extends State<AppCustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
      ),
    );

    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasIcon = widget.icon != null || widget.iconData != null;
    final bgColor = widget.iconBackgroundColor ?? widget.iconColor.withValues(alpha: 0.12);
    const double iconDiameter = 76.0;
    const double iconRadius = iconDiameter / 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.fromLTRB(24.0, 52.0, 24.0, 24.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Main Dialog Body Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              22.0,
              hasIcon ? (iconRadius + 22.0) : 26.0,
              22.0,
              22.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 30.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Description
                if (widget.description != null &&
                    widget.description!.isNotEmpty) ...[
                  const SizedBox(height: 10.0),
                  Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Extra Custom Content Widget
                if (widget.content != null) ...[
                  const SizedBox(height: 16.0),
                  widget.content!,
                ],

                const SizedBox(height: 24.0),

                // Action Buttons Row
                Row(
                  children: [
                    // Secondary Button
                    if (widget.secondaryButtonText != null &&
                        widget.secondaryButtonText!.isNotEmpty) ...[
                      Expanded(
                        child: CustomButton(
                          text: widget.secondaryButtonText!,
                          onPressed: widget.onSecondaryPressed ??
                              () => Navigator.of(context).pop(false),
                          height: 48.0,
                          fontSize: 14.0,
                          isOutlined: true,
                          textColor: widget.secondaryTextColor,
                          borderColor: Colors.transparent,
                          underlayerColor: widget.secondaryButtonColor,
                          borderRadius: AppRadius.large,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],

                    // Primary Button
                    Expanded(
                      child: CustomButton(
                        text: widget.primaryButtonText,
                        onPressed: widget.isLoading
                            ? null
                            : (widget.onPrimaryPressed ??
                                () => Navigator.of(context).pop(true)),
                        height: 48.0,
                        fontSize: 14.0,
                        isLoading: widget.isLoading,
                        textColor: widget.primaryTextColor,
                        borderRadius: AppRadius.large,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Floating Badge Icon (Half Outside, Half Inside)
          if (hasIcon)
            Positioned(
              top: -iconRadius,
              child: ScaleTransition(
                scale: _iconScale,
                child: Container(
                  width: iconDiameter,
                  height: iconDiameter,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.iconColor.withValues(alpha: 0.28),
                        blurRadius: 18.0,
                        spreadRadius: -1.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: widget.icon ??
                        Icon(
                          widget.iconData,
                          color: widget.iconColor,
                          size: 50.0,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.confirmColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCustomDialog(
      iconData: icon,
      iconColor: confirmColor ?? AppColors.primary500,
      title: title,
      description: message,
      primaryButtonText: confirmText,
      primaryButtonColor: confirmColor ?? AppColors.primary500,
      secondaryButtonText: cancelText,
      onPrimaryPressed: () => Navigator.of(context).pop(true),
      onSecondaryPressed: () => Navigator.of(context).pop(false),
    );
  }
}
