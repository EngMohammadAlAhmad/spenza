import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/orders/presentation/widgets/animated_three_dots.dart';

class AccountHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;
  final VoidCallback? onEditPressed;

  const AccountHeader({
    super.key,
    this.user,
    this.isLoading = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final initials = user?.initials ?? '';
    final name = user?.name ?? '';
    final phone = user?.formattedPhoneNumber ?? '';
    final roleLabel = user?.roleLabel.isNotEmpty == true ? user!.roleLabel : 'حساب شخصي';

    return AppHeader(
      style: AppHeaderStyle.gradient,
      title: 'حسابي',
      showBackButton: false,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0,
        left: 20.0,
        right: 20.0,
        bottom: 24.0,
      ),
      bottomChild: Row(
        children: [
          // User Initials Avatar
          Container(
            width: 58.0,
            height: 58.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: isLoading && user == null
                ? const AnimatedThreeDots(color: AppColors.primary500)
                : Text(
                    initials.isNotEmpty ? initials : 'ح ص',
                    style: const TextStyle(
                      color: AppColors.primary500,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 16.0),
          // Name, Phone & Role Badge (Middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading && user == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: AnimatedThreeDots(color: Colors.white),
                      )
                    : Text(
                        name.isNotEmpty ? name : 'أهلاً بك',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                const SizedBox(height: 2.0),
                if (phone.isNotEmpty)
                  Text(
                    phone,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppRadius.overMedium,
                  ),
                  child: Text(
                    roleLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          // Edit Button
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onEditPressed,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppAssets.editIcon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
