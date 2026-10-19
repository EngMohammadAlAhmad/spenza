import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback? onEditPressed;

  const AddressCard({
    super.key,
    required this.address,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.upMedium,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Info Content
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

                  // Full Address Details Line
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
            InkWell(
              onTap: onEditPressed,
              child: SvgPicture.asset('assets/icons/edit_icon.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
