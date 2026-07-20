import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class OrderAgainItem {
  final String imagePath;
  final String title;
  final int price;

  const OrderAgainItem({
    required this.imagePath,
    required this.title,
    required this.price,
  });
}

class OrderAgainSection extends StatefulWidget {
  const OrderAgainSection({super.key});

  @override
  State<OrderAgainSection> createState() => _OrderAgainSectionState();
}

class _OrderAgainSectionState extends State<OrderAgainSection> {
  final List<OrderAgainItem> items = const [
    OrderAgainItem(
      imagePath: 'assets/images/temp/order_again_1.png',
      title: 'ورق طباعة A4 - 80 غرام (500 ورقة)',
      price: 48000,
    ),
    OrderAgainItem(
      imagePath: 'assets/images/temp/order_again_2.png',
      title: 'طقم أقلام حبر جاف ملوّن - 10 ألوان',
      price: 28000,
    ),
    OrderAgainItem(
      imagePath: 'assets/images/temp/order_again_3.png',
      title: 'دفتر مدرسي 60 ورقة - عبوة 5 دفاتر',
      price: 30000,
    ),
    OrderAgainItem(
      imagePath: 'assets/images/temp/order_again_4.png',
      title: 'دفتر سلكي A4 - 200 ورقة مسطر',
      price: 22000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          spacing: 5.0,
          children: [
            SvgPicture.asset('assets/icons/order_again_icon.svg'),
            Text(
              'اطلبها مجدداً',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل >',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 10.0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: OrderAgainCard(item: items[index]),
            ).animate(delay: (70 * index).ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
          },
        ),
      ],
    );
  }
}

class OrderAgainCard extends StatefulWidget {
  final OrderAgainItem item;

  const OrderAgainCard({super.key, required this.item});

  @override
  State<OrderAgainCard> createState() => _OrderAgainCardState();
}

class _OrderAgainCardState extends State<OrderAgainCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: 80.0,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.overMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: .center,
            spacing: 15.0,
            children: [
              ClipRRect(
                borderRadius: AppRadius.overMedium,
                child: Image.asset(
                  item.imagePath,
                  width: 56.0,
                  height: 56.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  spacing: 5.0,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.neutral900,
                        fontWeight: .w700,
                      ),
                    ),
                    Row(
                      spacing: 5.0,
                      children: [
                        Text(
                          item.price.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: .w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'ل.س',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral,
                            fontWeight: .w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}