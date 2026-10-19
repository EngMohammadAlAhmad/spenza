import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class CheckoutAddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEditSuccess;

  const CheckoutAddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onEditSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFDF2F2) : Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: isSelected ? AppColors.primary500 : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              if (!isSelected)
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selection Radio Indicator
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary500 : AppColors.disabledLight,
                  size: 22.0,
                ),
              ),
              const SizedBox(width: 12.0),

              // Main Address Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Default Badge
                    Row(
                      children: [
                        Text(
                          address.fullTitle,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE8E8),
                              borderRadius: AppRadius.medium,
                            ),
                            child: const Text(
                              'افتراضي',
                              style: TextStyle(
                                color: AppColors.primary500,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6.0),

                    // Full Address Line
                    if (address.fullAddressLine.isNotEmpty)
                      Text(
                        address.fullAddressLine,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.neutral,
                              height: 1.3,
                            ),
                      ),
                    const SizedBox(height: 6.0),

                    // Phone Number
                    if (address.phone.isNotEmpty)
                      Text(
                        address.formattedPhone,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.neutral,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),

              // Pencil Edit Icon
              InkWell(
                onTap: () async {
                  final result = await context.push(RoutePaths.addAddress);
                  if (result == true) {
                    onEditSuccess();
                  }
                },
                child: SvgPicture.asset('assets/icons/edit_icon.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
