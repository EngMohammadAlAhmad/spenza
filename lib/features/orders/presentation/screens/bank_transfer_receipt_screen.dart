import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';
import 'package:spenza/features/orders/domain/usecases/upload_transfer_receipt_use_case.dart';
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: AppRadius.micro,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'ارفع صورة وصل الحوالة',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'يرجى منح الإذن للوصول للكاميرا أو الصور لإرفاق صورة الوصل (PNG, JPG, JPEG)',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 20.0),
                ListTile(
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
                  title: const Text(
                    'التقاط صورة بالكاميرا',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('التقاط صورة للوصل مباشرة',
                      style: TextStyle(fontSize: 12.0)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromCamera();
                  },
                ),
                const Divider(height: 16),
                ListTile(
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
                  title: const Text(
                    'اختيار من المعرض',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('اختيار ملف صورة (PNG, JPG, JPEG)',
                      style: TextStyle(fontSize: 12.0)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromGallery();
                  },
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      },
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
            message: 'حجم الصورة يتجاوز 5 ميغابايت. يرجى اختيار صورة بحجم أصغر.',
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
          message: 'يرجى السماح بإذن الوصول للكاميرا من إعدادات الجهاز',
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
          message: 'تم إرفاق صورة الوصل بنجاح',
        );
      }
    } catch (_) {
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'يرجى السماح بإذن الوصول للمعرض من إعدادات الجهاز',
        );
      }
    }
  }

  void _showCapturedPreviewDialog(File capturedFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
          child: Padding(
            padding: const .all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'معاينة صورة الوصل الملتقطة',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 12.0),
                ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: Image.file(
                    capturedFile,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _pickFromCamera();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFC74436)),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            color: Color(0xFFC74436),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          setState(() {
                            _receiptFile = capturedFile;
                          });
                          SnackbarService.showSuccess(
                            context,
                            message: 'تم اعتماد صورة الوصل بنجاح',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تم',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitTransferReceipt() async {
    FocusScope.of(context).unfocus();
    if (_receiptFile == null) {
      SnackbarService.showWarning(
        context,
        message: 'يرجى إرفاق صورة وصل الحوالة أولاً',
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
            message: 'تم إرسال وصل الحوالة بنجاح',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // 1. Header
          AppHeader(
            title: 'وصل الحوالة',
            subtitle: 'طلب ${widget.orderNumber}',
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28.0)),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  // Receipt Preview Card Container
                  Container(
                    width: double.infinity,
                    padding: const .all(16.0),
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
                                      borderRadius:
                                          AppRadius.overMedium,
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        const Text(
                                          'ارفع صورة وصل الحوالة',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.neutral900,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        const Text(
                                          'اضغط هنا لرفع أو التقاط صورة الوصل\n(PNG, JPG, JPEG - بحجم أقصاه 5 ميغابايت)',
                                          style: TextStyle(
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
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          borderRadius: AppRadius.medium,
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'تغيير',
                                              style: TextStyle(
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
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _showImageSourcePicker,
                              child: Text(
                                _receiptFile != null
                                    ? 'بدل الصورة'
                                    : 'ارفع الصورة',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: .bold,
                                  color: Color(0xFFC74436),
                                ),
                              ),
                            ),
                            if (_receiptFile != null)
                              Row(
                                children: const [
                                  Text(
                                    'صورة الوصل جاهزة',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: AppColors.neutral700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 6.0),
                                  Icon(
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
                  ),

                  // 1. Transfer Reference Field
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0, bottom: 8.0),
                        child: Text(
                          'رقم الحوالة (اختياري)',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: .bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _referenceController,
                        hintText: 'أدخل رقم الحوالة',
                        fillColor: Colors.white,
                        keyboardType: TextInputType.text,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 6.0, right: 4.0),
                        child: Text(
                          'بيسرع المراجعة إذا كان واضح على الوصل',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.neutral,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 2. Amount Field
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Padding(
                        padding: .only(right: 4.0, bottom: 8.0),
                        child: Text(
                          'المبلغ (اختياري)',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: .bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _amountController,
                        hintText: 'أدخل المبلغ المحول',
                        fillColor: Colors.white,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                    ],
                  ),

                  // 3. Date Field (Picker)
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0, bottom: 8.0),
                        child: Text(
                          'تم التحويل في تاريخ (اختياري)',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: .bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _transferredAtController,
                        hintText: 'اختيار تاريخ التحويل',
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
                    crossAxisAlignment: .start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0, bottom: 8.0),
                        child: Text(
                          'ملاحظة (اختياري)',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: .bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _noteController,
                        hintText: 'أضف أي ملاحظة حول الحوالة',
                        fillColor: Colors.white,
                        maxLines: 3,
                      ),
                    ],
                  ),

                  // Info Notice Banner
                  Container(
                    width: double.infinity,
                    padding: const .all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: AppRadius.upMedium,
                    ),
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.blue,
                          size: 22.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: const [
                              Text(
                                'تأكد قبل الإرسال',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: .bold,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'لازم يبين المبلغ والتاريخ واسم المستفيد. الصيغ: JPG أو PNG أو Webp (الحد الأقصى للحجم 5 ميغابايت).',
                                style: TextStyle(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Button
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: CustomButton(
              text: 'أرسل الوصل',
              height: 52.0,
              isLoading: _isUploading,
              onPressed: _isUploading ? null : _submitTransferReceipt,
            ),
          ),
        ),
      ),
    );
  }
}
