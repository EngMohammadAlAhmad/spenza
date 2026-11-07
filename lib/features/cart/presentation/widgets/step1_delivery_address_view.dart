import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/general_error_widget.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_address_card.dart';
import 'package:spenza/features/cart/presentation/widgets/dashed_add_address_button.dart';
import 'package:spenza/features/cart/presentation/widgets/delivery_notice_banner.dart';

class Step1DeliveryAddressView extends StatelessWidget {
  final int? selectedAddressId;
  final ValueChanged<int> onAddressSelected;

  const Step1DeliveryAddressView({
    super.key,
    required this.selectedAddressId,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressesBloc, AddressesState>(
      listener: (context, state) {
        if (state.getAddressesStatus == RequestStatus.success &&
            state.addresses.isNotEmpty) {
          if (selectedAddressId == null) {
            final defaultMatches = state.addresses.where((a) => a.isDefault);
            final defaultAddr = defaultMatches.isNotEmpty
                ? defaultMatches.first
                : state.addresses.first;
            onAddressSelected(defaultAddr.id);
            final cityId = defaultAddr.cityId > 0 ? defaultAddr.cityId : 1;
            context.read<CartBloc>().add(GetCheckoutOptionsEvent(cityId: cityId));
          }
        }
      },
      builder: (context, state) {
        if (state.getAddressesStatus == RequestStatus.loading) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 12.0),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                SizedBox(height: 12.0),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ],
            ),
          );
        }

        if (state.getAddressesStatus == RequestStatus.error) {
          return Center(
            child: GeneralErrorWidget(
              message: state.getAddressesFailure.errMessage,
              onRetry: () {
                context.read<AddressesBloc>().add(const GetAddressesEvent());
              },
            ),
          );
        }

        AddressEntity? selectedAddress;
        if (selectedAddressId != null && state.addresses.isNotEmpty) {
          final matches = state.addresses.where((a) => a.id == selectedAddressId);
          selectedAddress = matches.isNotEmpty ? matches.first : state.addresses.first;
        }

        final isTabletLandscape = context.isTabletLandscape;

        Widget buildAddressListSection() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'where_to_deliver_question'.tr(),
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              if (state.addresses.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      'no_addresses_add_new_note'.tr(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.neutral,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: state.addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12.0),
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    final isSelected = address.id == selectedAddressId;
                    return CheckoutAddressCard(
                      address: address,
                      isSelected: isSelected,
                      onTap: () {
                        onAddressSelected(address.id);
                        final cityId = address.cityId > 0 ? address.cityId : 1;
                        context
                            .read<CartBloc>()
                            .add(GetCheckoutOptionsEvent(cityId: cityId));
                      },
                    );
                  },
                ),
            ],
          );
        }

        Widget buildAddAndNoticeSection() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashedAddAddressButton(
                onTap: () {
                  context.push(RoutePaths.addAddress);
                },
              ),
              const SizedBox(height: 16.0),
              DeliveryNoticeBanner(selectedAddress: selectedAddress),
            ],
          );
        }

        Widget bodyContent;

        if (isTabletLandscape) {
          bodyContent = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Item: List of Addresses
              Expanded(
                flex: 1,
                child: buildAddressListSection(),
              ),
              const SizedBox(width: 20.0),

              // Second Item: Dashed Add Address Button under it Delivery Info Notice Banner
              Expanded(
                flex: 1,
                child: buildAddAndNoticeSection(),
              ),
            ],
          );
        } else {
          bodyContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAddressListSection(),
              const SizedBox(height: 14.0),
              buildAddAndNoticeSection(),
              const SizedBox(height: 20.0),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<AddressesBloc>().add(const GetAddressesEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
            child: bodyContent,
          ),
        );
      },
    );
  }
}
