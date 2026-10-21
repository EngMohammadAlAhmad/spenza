import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

enum OrderHelpType {
  cancel,
  products,
  payment,
  chat,
}

class OrderHelpOption {
  final OrderHelpType type;
  final String title;
  final String subtitle;
  final String iconPath;

  const OrderHelpOption({
    required this.type,
    required this.title,
    required this.subtitle,
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
      title: 'بدي ألغي الطلب',
      subtitle: 'فريق الدعم بيشوف حالة الطلب ويرد عليك',
      iconPath: AppAssets.cancelIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.products,
      title: 'مشكلة بمنتج أو إرجاع',
      subtitle: 'منتج تالف، ناقص، أو مو مثل الوصف',
      iconPath: AppAssets.productIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.payment,
      title: 'سؤال عن الدفع',
      subtitle: 'حوالة، بيميرا، أو استرداد',
      iconPath: AppAssets.payIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.chat,
      title: 'شي تاني',
      subtitle: 'احكيلنا شو صار',
      iconPath: AppAssets.chatIcon,
    ),
  ];

  Future<void> _launchWhatsApp(OrderHelpType type, String orderNumber) async {
    final String message = switch (type) {
      OrderHelpType.cancel =>
        'مرحبا سبينزا 🌷\nبدي ألغي طلبي رقم $orderNumber، بتشوفولي إذا لسا بيتلغى؟ يعطيكن العافية.\nسبب الإلغاء: ',
      OrderHelpType.products =>
        'مرحبا سبينزا 🌷\nعندي مشكلة بطلبي رقم $orderNumber، وبقدر أبعتلكن صورة إذا بدكن. يعطيكن العافية.\nالمنتج والمشكلة: ',
      OrderHelpType.payment =>
        'مرحبا سبينزا 🌷\nبدي أسأل عن الدفع بطلبي رقم $orderNumber. يعطيكن العافية.\nسؤالي: ',
      OrderHelpType.chat =>
        'مرحبا سبينزا 🌷\nبخصوص طلبي رقم $orderNumber. يعطيكن العافية.\nبدي احكيلكن عن: ',
    };

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
    final String displayOrderStatus = widget.orderStatus ?? 'مع المندوب';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutralBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
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
                  'كيف فينا نساعدك؟',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: .w800,
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
              mainAxisAlignment: .start,
              children: [
                Text(
                  'الطلب $displayOrderNumber · $displayOrderStatus',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: .bold,
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
                    colorFilter: .mode(AppColors.successForeground, .srcIn),
                  ),
                  Expanded(
                    child: Text(
                      'كل خيار بيفتحلك واتساب، ورقم الطلب جاهز بالرسالة. المرتجعات والإلغاء بيرتبهن فريق الدعم معك.',
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
            // Icon Container (Right side in RTL)
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
                    option.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Text(
                    option.subtitle,
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
