import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

/// Reusable pure UI widget for the image source picker bottom sheet.
/// Contains design and UI layout only with callbacks for interactions.
class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback? onCameraTap;
  final VoidCallback? onGalleryTap;
  final VoidCallback? onCloseTap;
  final String? title;
  final String? subtitle;

  const ImageSourceBottomSheet({
    super.key,
    this.onCameraTap,
    this.onGalleryTap,
    this.onCloseTap,
    this.title,
    this.subtitle,
  });

  /// Helper to present the modal bottom sheet UI.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ImageSourceBottomSheet(
        title: title,
        subtitle: subtitle,
        onCloseTap: () => Navigator.pop(ctx),
        onCameraTap: () {
          Navigator.pop(ctx);
          onCameraTap();
        },
        onGalleryTap: () {
          Navigator.pop(ctx);
          onGalleryTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Bar
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: AppRadius.micro,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Title Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title ?? 'upload_transfer_receipt'.tr(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onCloseTap ?? () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 22.0,
                      color: AppColors.neutral700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle ?? 'grant_camera_gallery_permission'.tr(),
                style: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.neutral,
                ),
              ),
              const SizedBox(height: 20.0),

              // Option 1: Camera
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.thirdAccent,
                    borderRadius: AppRadius.medium,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.blue,
                  ),
                ),
                title: Text(
                  'take_photo_camera'.tr(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                subtitle: Text(
                  'take_photo_directly'.tr(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.neutral,
                  ),
                ),
                onTap: onCameraTap,
              ),
              const Divider(height: 16, indent: 8, endIndent: 8),

              // Option 2: Gallery
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.thirdAccent,
                    borderRadius: AppRadius.medium,
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.blue,
                  ),
                ),
                title: Text(
                  'choose_from_gallery'.tr(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                subtitle: Text(
                  'choose_image_file'.tr(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.neutral,
                  ),
                ),
                onTap: onGalleryTap,
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
