import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

enum OrderHelpType {
  payment,
  products,
  cancel,
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

  const OrderHelpBottomSheet({
    super.key,
    this.initialSelectedType,
    this.onOptionSelected,
  });

  static Future<OrderHelpType?> show(
    BuildContext context, {
    OrderHelpType? initialSelectedType,
    ValueChanged<OrderHelpType>? onOptionSelected,
  }) {
    return showModalBottomSheet<OrderHelpType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderHelpBottomSheet(
        initialSelectedType: initialSelectedType,
        onOptionSelected: onOptionSelected,
      ),
    );
  }

  @override
  State<OrderHelpBottomSheet> createState() => _OrderHelpBottomSheetState();
}

class _OrderHelpBottomSheetState extends State<OrderHelpBottomSheet> {

  final List<OrderHelpOption> _options = const [
    OrderHelpOption(
      type: OrderHelpType.payment,
      title: 'الدفع أو الفاتورة',
      subtitle: 'استفسارات حول طرق الدفع، الفاتورة، أو المبالغ المستردة',
      iconPath: AppAssets.payIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.products,
      title: 'مشكلة في المنتجات',
      subtitle: 'عناصر مفقودة، تالفة، أو غير مطابقة للمواصفات',
      iconPath: AppAssets.productIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.cancel,
      title: 'إلغاء الطلب',
      subtitle: 'طلب إلغاء هذا الطلب وإرجاع المبلغ للمحفظة',
      iconPath: AppAssets.cancelIcon,
    ),
    OrderHelpOption(
      type: OrderHelpType.chat,
      title: 'المحادثة المباشرة مع الدعم',
      subtitle: 'التحدث فوراً مع فريق خدمة العملاء للمساعدة',
      iconPath: AppAssets.chatIcon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 32.0),
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

          // Title Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  size: 24.0,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'مساعدة بهالطلب',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 24.0),
            ],
          ),
          const SizedBox(height: 24.0),

          // Options List
          for (int i = 0; i < _options.length; i++) ...[
            _OrderHelpOptionCard(
              option: _options[i],
              onTap: () {},
            ),
            if (i < _options.length - 1) const SizedBox(height: 12.0),
          ],
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
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color:  Colors.white,
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container ON THE RIGHT SIDE
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: AppColors.neutralBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                option.iconPath,
                width: 22.0,
                height: 22.0,
              ),
            ),
            const SizedBox(width: 14.0),

            // Title & Subtitle IN THE MIDDLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                      height: 1.3,
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
