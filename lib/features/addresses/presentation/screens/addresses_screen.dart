import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_scaffold.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_dialog.dart';
import 'package:spenza/core/widgets/general_error_widget.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/features/addresses/presentation/widgets/address_card.dart';
import 'package:spenza/features/addresses/presentation/widgets/empty_addresses_widget.dart';
import 'package:spenza/injection_locator.dart' as di;

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AddressesBloc>()..add(const GetAddressesEvent()),
      child: const _AddressesView(),
    );
  }
}

class _AddressesView extends StatelessWidget {
  const _AddressesView();

  void _showDeleteDialog(BuildContext context, AddressEntity address) {
    AppCustomDialog.show(
      context: context,
      iconPath: AppAssets.removeIcon,
      iconColor: AppColors.error,
      title: 'حذف العنوان',
      description: 'هل أنت تأكد من رغبتك في حذف هذا العنوان؟',
      primaryButtonText: 'حذف',
      primaryButtonColor: AppColors.error,
      secondaryButtonText: 'cancel'.tr(),
      onPrimaryPressed: () {
        Navigator.of(context).pop();
        context.read<AddressesBloc>().add(DeleteAddressEvent(address.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressesBloc, AddressesState>(
      listenWhen: (previous, current) =>
          previous.deleteAddressStatus != current.deleteAddressStatus,
      listener: (context, state) {
        if (state.deleteAddressStatus == RequestStatus.success) {
          final msg = state.deleteAddressSuccessMessage ?? 'تم حذف العنوان بنجاح';
          SnackbarService.showSuccess(context, message: msg);
        } else if (state.deleteAddressStatus == RequestStatus.error) {
          SnackbarService.showError(
            context,
            message: state.deleteAddressFailure.errMessage,
          );
        }
      },
      child: AppScaffold(
        title: 'my_addresses'.tr(),
        body: Column(
          children: [
            // Scrollable Addresses List
            Expanded(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  if (state.getAddressesStatus == RequestStatus.loading) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: 3,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: ShimmerPlaceholder(
                          width: double.infinity,
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        ),
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

                  if (state.addresses.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<AddressesBloc>().add(const GetAddressesEvent());
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: context.height * 0.7,
                          child: const EmptyAddressesWidget(),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<AddressesBloc>().add(const GetAddressesEvent());
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return AddressCard(
                          address: address,
                          onEditPressed: () async {
                            final result = await context.push(
                              RoutePaths.addAddress,
                              extra: address,
                            );
                            if (result == true && context.mounted) {
                              context.read<AddressesBloc>().add(const GetAddressesEvent());
                            }
                          },
                          onDeletePressed: () => _showDeleteDialog(context, address),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Add Address Button
            Builder(
              builder: (blocContext) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    text: 'add_new_address'.tr(),
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final result = await context.push(RoutePaths.addAddress);
                      if (result == true && blocContext.mounted) {
                        blocContext.read<AddressesBloc>().add(const GetAddressesEvent());
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
