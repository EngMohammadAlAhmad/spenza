import 'dart:io';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_dashed_container.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class BusinessAccountStep2Widget extends StatefulWidget {
  final File? projectImage;
  final void Function(ImageSource source) onPickImage;
  final VoidCallback onDeleteImage;

  const BusinessAccountStep2Widget({
    super.key,
    required this.projectImage,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  @override
  State<BusinessAccountStep2Widget> createState() =>
      _BusinessAccountStep2WidgetState();
}

class _BusinessAccountStep2WidgetState
    extends State<BusinessAccountStep2Widget> {
  bool _isChangingImage = false;

  @override
  void didUpdateWidget(covariant BusinessAccountStep2Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.projectImage != oldWidget.projectImage) {
      _isChangingImage = false;
    }
  }

  void _handlePickImage(ImageSource source) {
    setState(() {
      _isChangingImage = false;
    });
    widget.onPickImage(source);
  }

  void _handleDeleteImage() {
    setState(() {
      _isChangingImage = false;
    });
    widget.onDeleteImage();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'upload_project_photo_title'.tr(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6.0),
        Text(
          'upload_project_photo_subtitle'.tr(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.tertiary,
              ),
        ),
      ],
    );

    final uploadCard = _buildDashedUploadBox(context);

    final privacyBanner = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.thirdAccent,
        borderRadius: AppRadius.overMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 22.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'photo_privacy_title'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'photo_privacy_desc'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textBody,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isTabletLandscape) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Physical LEFT side: Subtitle, Upload Box, and Privacy Banner
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'upload_project_photo_subtitle'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.tertiary,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    uploadCard,
                    const SizedBox(height: 16.0),
                    privacyBanner,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20.0),

            // Physical RIGHT side: Only Title
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: Text(
                  'upload_project_photo_title'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleSection,
        const SizedBox(height: 16.0),
        uploadCard,
        const SizedBox(height: 16.0),
        privacyBanner,
      ],
    );
  }

  Widget _buildDashedUploadBox(BuildContext context) {
    return AppDashedContainer(
      borderColor: AppColors.primary,
      borderRadius: 20.0,
      fillColor: AppColors.primaryTint,
      padding: const EdgeInsets.all(20.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          );
        },
        child: widget.projectImage == null
            ? Column(
                key: const ValueKey('empty_upload_box'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(AppAssets.uploadIcon),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'choose_photo'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'png_or_jpg'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.tertiary,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                    child: Row(
                      spacing: 12.0,
                      children: [
                        _buildUploadOptionButton(
                          iconPath: AppAssets.galleryIcon,
                          label: 'from_gallery'.tr(),
                          onTap: () => _handlePickImage(ImageSource.gallery),
                          buttonColor: Colors.white,
                        ),
                        _buildUploadOptionButton(
                          iconPath: AppAssets.cameraIcon,
                          label: 'take_photo_now'.tr(),
                          onTap: () => _handlePickImage(ImageSource.camera),
                          buttonColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                key: const ValueKey('selected_image_preview'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: Image.file(
                      widget.projectImage!,
                      height: 180.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        ),
                      );
                    },
                    child: !_isChangingImage
                        ? KeyedSubtree(
                            key: const ValueKey('image_action_buttons'),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                              child: Row(
                                spacing: 12.0,
                                children: [
                                  _buildUploadOptionButton(
                                    icon: SvgPicture.asset(AppAssets.refreshIcon),
                                    label: 'change_photo'.tr(),
                                    onTap: () {
                                      setState(() {
                                        _isChangingImage = true;
                                      });
                                    },
                                    buttonColor: Colors.white,
                                  ),
                                  _buildUploadOptionButton(
                                    icon: SvgPicture.asset(
                                      AppAssets.removeIcon,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: 'delete'.tr(),
                                    textColor: Colors.white,
                                    borderColor: AppColors.primary,
                                    buttonColor: AppColors.primary,
                                    onTap: _handleDeleteImage,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : KeyedSubtree(
                            key: const ValueKey('image_picker_options'),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                              child: Row(
                                spacing: 12.0,
                                children: [
                                  _buildUploadOptionButton(
                                    iconPath: AppAssets.galleryIcon,
                                    label: 'from_gallery'.tr(),
                                    onTap: () => _handlePickImage(ImageSource.gallery),
                                    buttonColor: Colors.white,
                                  ),
                                  _buildUploadOptionButton(
                                    iconPath: AppAssets.cameraIcon,
                                    label: 'take_photo_now'.tr(),
                                    onTap: () => _handlePickImage(ImageSource.camera),
                                    buttonColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUploadOptionButton({
    Widget? icon,
    String? iconPath,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? borderColor,
    Color? buttonColor,
  }) {
    return Expanded(
      child: CustomButton(
        text: label,
        onPressed: onTap,
        isOutlined: true,
        height: 40.0,
        borderRadius: AppRadius.brandRadius2,
        textColor: textColor,
        borderColor: borderColor,
        icon: icon ??
            (iconPath != null
                ? SvgPicture.asset(
                    iconPath,
                  )
                : null),
        underlayerColor: buttonColor,
      ),
    );
  }
}
