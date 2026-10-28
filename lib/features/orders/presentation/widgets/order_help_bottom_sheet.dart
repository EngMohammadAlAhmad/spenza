import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/orders/presentation/utils/order_localization_helper.dart';

enum OrderHelpType {
  cancel,
  products,
  payment,
  chat,
}

class OrderHelpOption {
  final OrderHelpType type;
  final String titleKey;
  final String subtitleKey;
  final String iconPath;

  const OrderHelpOption({
    required this.type,
    required this.titleKey,
    required this.subtitleKey,
    required this.iconPath,
  });
}

class OrderHelpBottomSheet extends StatefulWidget {
  final OrderHelpType? initialSelectedType;
  final ValueChanged<OrderHelpType>? onOptionSelected;
  final String? orderNumber;
  final String? orderStatus;

  const OrderHelpBottomSheet({
    super.key,
    this.initialSelectedType,
    this.onOptionSelected,
    this.orderNumber,
    this.orderStatus,
  });

  static Future<OrderHelpType?> show(
    BuildContext context, {
    OrderHelpType? initialSelectedType,
    ValueChanged<OrderHelpType>? onOptionSelected,
    String? orderNumber,
    String? orderStatus,
  }) {
    return showModalBottomSheet<OrderHelpType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderHelpBottomSheet(
        initialSelectedType: initialSelectedType,
        onOptionSelected: onOptionSelected,
        orderNumber: orderNumber,
        orderStatus: orderStatus,
      ),
    );
  }

  @override
  State<OrderHelpBottomSheet> createState() => _OrderHelpBottomSheetState();
}

class _OrderHelpBottomSheetState extends State<OrderHelpBottomSheet> {
  final List<OrderHelpOption> _options = const [
    OrderHelpOption(
      type: OrderHelpType.cancel,
      titleKey: 'help_cancel_title',
      subtitleKey: 'help_cancel_sub',
      iconPath: AppAssets.cancelIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.products,
      titleKey: 'help_products_title',
      subtitleKey: 'help_products_sub',
      iconPath: AppAssets.productIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.payment,
      titleKey: 'help_payment_title',
      subtitleKey: 'help_payment_sub',
      iconPath: AppAssets.payIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.chat,
      titleKey: 'help_other_title',
      subtitleKey: 'help_other_sub',
      iconPath: AppAssets.chatIcon,
    ),
  ];

  Future<void> _launchWhatsApp(OrderHelpType type, String orderNumber) async {
    final isArabic = context.locale.languageCode == 'ar';
    final String message = OrderLocalizationHelper.getWhatsAppHelpMessage(
      type,
      orderNumber,
      isArabic: isArabic,
    );

    const String phoneNumber = '963934351075';
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching WhatsApp URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayOrderNumber = widget.orderNumber ?? 'SPZ-80329';
    final String displayOrderStatus = widget.orderStatus ?? 'stage_with_courier'.tr();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Drag Handle
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: AppRadius.micro,
            ),
          ),
          const SizedBox(height: 16.0),

          // Header Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'how_can_we_help_you'.tr(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  size: 22.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Order Number & Status Row
          Row(
            spacing: 6.0,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${'order_number'.tr()} $displayOrderNumber · $displayOrderStatus',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SvgPicture.asset(AppAssets.documentIcon),
            ],
          ),
          const SizedBox(height: 20.0),

          // Options List
          for (int i = 0; i < _options.length; i++) ...[
            _OrderHelpOptionCard(
              option: _options[i],
              onTap: () {
                final selectedType = _options[i].type;
                widget.onOptionSelected?.call(selectedType);
                _launchWhatsApp(selectedType, displayOrderNumber);
                Navigator.pop(context, selectedType);
              },
            ),
            if (i < _options.length - 1) const SizedBox(height: 10.0),
          ],
          const SizedBox(height: 14.0),

          // Bottom WhatsApp Notice Banner
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: AppColors.successDark.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              spacing: 10.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.chatIcon,
                  colorFilter: const ColorFilter.mode(AppColors.successForeground, BlendMode.srcIn),
                ),
                Expanded(
                  child: Text(
                    'whatsapp_help_notice'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.successForeground,
                    ),
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

class _OrderHelpOptionCard extends StatelessWidget {
  final OrderHelpOption option;
  final VoidCallback onTap;

  const _OrderHelpOptionCard({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          spacing: 12.0,
          children: [
            // Icon Container
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: AppColors.neutralBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(option.iconPath),
            ),
            // Title & Subtitle
            Expanded(
              child: Column(
                spacing: 3.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.titleKey.tr(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    option.subtitleKey.tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
