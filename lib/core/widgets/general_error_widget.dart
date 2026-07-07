import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_button_styles.dart';
import 'package:spenza/core/themes/app_text_styles.dart';

class GeneralErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const GeneralErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 60.0,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'error'.tr(),
              style: AppTextStyles.heading3(context),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: AppTextStyles.textSecondary(context),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: AppButtonStyles.primary(context),
                icon: const Icon(Icons.refresh, size: 20),
                label: Text('retry'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}