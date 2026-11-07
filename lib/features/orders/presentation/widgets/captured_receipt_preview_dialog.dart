import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class CapturedReceiptPreviewDialog extends StatelessWidget {
  final File capturedFile;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  const CapturedReceiptPreviewDialog({
    super.key,
    required this.capturedFile,
    required this.onRetry,
    required this.onDone,
  });

  /// Displays the captured receipt preview dialog.
  static Future<bool?> show({
    required BuildContext context,
    required File capturedFile,
    required VoidCallback onRetry,
    required VoidCallback onDone,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return CapturedReceiptPreviewDialog(
          capturedFile: capturedFile,
          onRetry: () {
            Navigator.pop(dialogContext, false);
            onRetry();
          },
          onDone: () {
            Navigator.pop(dialogContext, true);
            onDone();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTabletLandscape ? 0.0 : 24.0,
        vertical: 24.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTabletLandscape ? 460.0 : 400.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'preview_captured_receipt'.tr(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: isTabletLandscape ? 300.0 : 260.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: AppRadius.medium,
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: Image.file(
                    capturedFile,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'retry'.tr(),
                      isOutlined: true,
                      height: 46.0,
                      fontSize: 14.0,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 18.0,
                        color: Color(0xFFC74436),
                      ),
                      onPressed: onRetry,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: CustomButton(
                      text: 'done'.tr(),
                      height: 46.0,
                      fontSize: 14.0,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18.0,
                        color: Colors.white,
                      ),
                      onPressed: onDone,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
