import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/image_source_bottom_sheet.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';
import 'package:spenza/features/orders/domain/usecases/upload_transfer_receipt_use_case.dart';
import 'package:spenza/features/orders/presentation/widgets/captured_receipt_preview_dialog.dart';
import 'package:spenza/injection_locator.dart';

class BankTransferReceiptScreen extends StatefulWidget {
  final String orderNumber;
  final num? totalAmount;

  const BankTransferReceiptScreen({
    super.key,
    this.orderNumber = '',
    this.totalAmount,
  });

  @override
  State<BankTransferReceiptScreen> createState() =>
      _BankTransferReceiptScreenState();
}

class _BankTransferReceiptScreenState
    extends State<BankTransferReceiptScreen> {
  late TextEditingController _referenceController;
  late TextEditingController _amountController;
  late TextEditingController _transferredAtController;
  late TextEditingController _noteController;

  File? _receiptFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _referenceController = TextEditingController(text: '');
    _amountController = TextEditingController(
      //text: widget.totalAmount != null ? widget.totalAmount.toString() : '',
    );
    _transferredAtController = TextEditingController(text: '');
    _noteController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    _transferredAtController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectTransferredDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC74436),
              onPrimary: Colors.white,
              onSurface: AppColors.neutral900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        _transferredAtController.text = formatted;
      });
    }
  }

  Future<void> _showImageSourcePicker() async {
    ImageSourceBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  Future<bool> _validateFileSize(File file) async {
    try {
      final bytes = await file.length();
      final sizeInMB = bytes / (1024 * 1024);
      if (sizeInMB > 5.0) {
        if (mounted) {
          SnackbarService.showError(
            context,
            message: 'image_size_exceeds_5mb'.tr(),
          );
        }
        return false;
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? captured = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (captured != null && mounted) {
        final file = File(captured.path);
        if (!await _validateFileSize(file)) return;
        _showCapturedPreviewDialog(file);
      }
    } catch (_) {
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'allow_camera_permission'.tr(),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        final file = File(picked.path);
        if (!await _validateFileSize(file)) return;

        setState(() {
          _receiptFile = file;
        });
        SnackbarService.showSuccess(
          context,
          message: 'receipt_attached_success'.tr(),
        );
      }
    } catch (_) {
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'allow_gallery_permission'.tr(),
        );
      }
    }
  }

  void _showCapturedPreviewDialog(File capturedFile) {
    CapturedReceiptPreviewDialog.show(
      context: context,
      capturedFile: capturedFile,
      onRetry: _pickFromCamera,
      onDone: () {
        setState(() {
          _receiptFile = capturedFile;
        });
        SnackbarService.showSuccess(
          context,
          message: 'receipt_accepted_success'.tr(),
        );
      },
    );
  }

  Future<void> _submitTransferReceipt() async {
    FocusScope.of(context).unfocus();
    if (_receiptFile == null) {
      SnackbarService.showWarning(
        context,
        message: 'please_attach_receipt_first'.tr(),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final params = UploadTransferReceiptParams(
      orderNumber: widget.orderNumber,
      image: _receiptFile!,
      reference: _referenceController.text.trim(),
      amount: _amountController.text.trim(),
      transferredAt: _transferredAtController.text.trim(),
      note: _noteController.text.trim(),
    );

    final result = await sl<UploadTransferReceiptUseCase>()(params);

    if (mounted) {
      setState(() {
        _isUploading = false;
      });

      result.fold(
        (failure) {
          SnackbarService.showError(
            context,
            message: failure.errMessage,
          );
        },
        (_) {
          SnackbarService.showSuccess(
            context,
            message: 'receipt_submitted_success'.tr(),
          );
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.orders);
          }
        },
      );
    }
  }

  Widget _buildReceiptPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Upload / Image Container
          _receiptFile == null
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showImageSourcePicker,
                    borderRadius: AppRadius.overMedium,
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: AppRadius.overMedium,
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: AppColors.blueAccent.withValues(alpha: 0.5),
                              borderRadius: AppRadius.overMedium,
                            ),
                            child: const Icon(
                              Icons.file_upload_outlined,
                              size: 32.0,
                              color: Color(0xFF4338CA),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'upload_transfer_receipt'.tr(),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'tap_to_upload_receipt_desc'.tr(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: AppColors.neutral,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.overMedium,
                      child: Image.file(
                        _receiptFile!,
                        width: double.infinity,
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: _showImageSourcePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: AppRadius.medium,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.refresh_rounded,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'change'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 14.0),

          // Bottom Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _showImageSourcePicker,
                child: Text(
                  _receiptFile != null
                      ? 'replace_image'.tr()
                      : 'upload_image'.tr(),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC74436),
                  ),
                ),
              ),
              if (_receiptFile != null)
                Row(
                  children: [
                    Text(
                      'receipt_ready'.tr(),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.neutral700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 20.0,
                      color: Color(0xFF16A34A),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        // 1. Transfer Reference Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
              child: Text(
                'transfer_number_optional'.tr(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            CustomTextField(
              controller: _referenceController,
              hintText: 'enter_transfer_number'.tr(),
              fillColor: Colors.white,
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, right: 4.0),
              child: Text(
                'speeds_up_review'.tr(),
                style: const TextStyle(
                  fontSize: 12.0,
                  color: AppColors.neutral,
                ),
              ),
            ),
          ],
        ),

        // 2. Amount Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
              child: Text(
                'amount_optional'.tr(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            CustomTextField(
              controller: _amountController,
              hintText: 'enter_transferred_amount'.tr(),
              fillColor: Colors.white,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
            ),
          ],
        ),

        // 3. Date Field (Picker)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
              child: Text(
                'transferred_date_optional'.tr(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            CustomTextField(
              controller: _transferredAtController,
              hintText: 'select_transfer_date'.tr(),
              fillColor: Colors.white,
              readOnly: true,
              onTap: _selectTransferredDate,
              suffixIcon: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primary,
                size: 20.0,
              ),
            ),
          ],
        ),

        // 4. Note Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
              child: Text(
                'note_optional'.tr(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            CustomTextField(
              controller: _noteController,
              hintText: 'add_note_about_transfer'.tr(),
              fillColor: Colors.white,
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoNoticeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: AppRadius.upMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 22.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'confirm_before_sending'.tr(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'receipt_requirements_notice'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textBody,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    Widget contentBody;

    if (isTabletLandscape) {
      contentBody = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Child: Receipt Preview Card Container + Info Notice Banner (Right side in RTL)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                _buildReceiptPreviewCard(),
                _buildInfoNoticeBanner(),
              ],
            ),
          ),
          const SizedBox(width: 20.0),

          // Second Child: Remaining Form Fields (Left side in RTL)
          Expanded(
            flex: 1,
            child: _buildFormFields(),
          ),
        ],
      );
    } else {
      contentBody = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _buildReceiptPreviewCard(),
          _buildFormFields(),
          _buildInfoNoticeBanner(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // 1. Header
          AppHeader(
            title: 'transfer_receipt'.tr(),
            subtitle: 'order_hash'.tr(args: [widget.orderNumber]),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(28.0)),
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RoutePaths.home);
              }
            },
          ),

          // 2. Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isTabletLandscape ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: contentBody,
            ),
          ),
        ],
      ),

      // 3. Fixed Bottom Button using AppBottomContainer
      bottomNavigationBar: AppBottomContainer(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: CustomButton(
          text: 'send_receipt'.tr(),
          height: 52.0,
          isLoading: _isUploading,
          onPressed: _isUploading ? null : _submitTransferReceipt,
        ),
      ),
    );
  }
  
}
