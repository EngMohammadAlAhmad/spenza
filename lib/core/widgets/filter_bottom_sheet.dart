import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

export 'filter_button.dart';

class FilterResult {
  final double? minPrice;
  final double? maxPrice;
  final int? inStock;

  const FilterResult({
    this.minPrice,
    this.maxPrice,
    this.inStock,
  });
}

class FilterBottomSheet extends StatefulWidget {
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final int? initialInStock;

  const FilterBottomSheet({
    super.key,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialInStock,
  });

  static Future<FilterResult?> show({
    required BuildContext context,
    double? minPrice,
    double? maxPrice,
    int? inStock,
  }) {
    return showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialMinPrice: minPrice,
        initialMaxPrice: maxPrice,
        initialInStock: inStock,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late bool _inStock;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialMinPrice != null ? widget.initialMinPrice!.toInt().toString() : '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialMaxPrice != null ? widget.initialMaxPrice!.toInt().toString() : '',
    );
    _inStock = widget.initialInStock == 1;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onClearAll() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _inStock = false;
    });
  }

  void _onApply() {
    final double? minPrice = double.tryParse(_minPriceController.text.trim());
    final double? maxPrice = double.tryParse(_maxPriceController.text.trim());
    final int inStockValue = _inStock ? 1 : 0;

    Navigator.pop(
      context,
      FilterResult(
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStockValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Bar
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.5),
                    borderRadius: AppRadius.micro,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'filter'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 24.0,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Section: Price in Lira
              Text(
                'price_in_lira'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 12.0),

              Row(
                spacing: 12.0,
                children: [
                  // From (من)
                  Expanded(
                    child: CustomTextField(
                      controller: _minPriceController,
                      label: 'from'.tr(),
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textBody,
                            fontWeight: FontWeight.bold,
                          ),
                      hintText: '10,000',
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                      keyboardType: TextInputType.number,
                      forPrice: true,
                      fillColor: Colors.white,
                      borderColor: AppColors.neutralBorderDefault,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // To (لحد)
                  Expanded(
                    child: CustomTextField(
                      controller: _maxPriceController,
                      label: 'to'.tr(),
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textBody,
                            fontWeight: FontWeight.bold,
                          ),
                      hintText: '50,000',
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                      keyboardType: TextInputType.number,
                      forPrice: true,
                      fillColor: Colors.white,
                      borderColor: AppColors.neutralBorderDefault,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Section: In stock only switcher
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.large,
                  border: Border.all(color: AppColors.neutralBorderDefault),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        color: AppColors.neutralBackground,
                        borderRadius: AppRadius.medium,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.productIcon,
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const .mode(
                          AppColors.textBody,
                          .srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'in_stock_only'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      value: _inStock,
                      activeThumbColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.neutralBorderStrong,
                      trackOutlineWidth: WidgetStateProperty.all(0),
                      onChanged: (val) {
                        setState(() => _inStock = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Bottom Actions Row: Clear All & Show Products
              Row(
                spacing: 12.0,
                children: [
                  // Show Products Button (عرض المنتجات)
                  Expanded(
                    child: CustomButton(
                      text: 'show_products'.tr(),
                      height: 50.0,
                      onPressed: _onApply,
                    ),
                  ),

                  // Clear All Button (مسح الكل)
                  Expanded(
                    child: CustomButton(
                      text: 'clear_all'.tr(),
                      isOutlined: true,
                      height: 50.0,
                      onPressed: _onClearAll,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
