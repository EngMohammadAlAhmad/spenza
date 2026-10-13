import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddressesHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const AddressesHeader({
    super.key,
    this.title = 'عناويني',
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 60.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.0,
        right: 16.0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),

          // Back Button on the right side in RTL
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: onBackPressed ?? () => context.pop(),
              child: SvgPicture.asset(
                'assets/icons/back_button_2.svg',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
