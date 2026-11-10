import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
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
      value: di.sl<AddressesBloc>(),
      child: const _AddressesView(),
    );
  }
}

class _AddressesView extends StatefulWidget {
  const _AddressesView();

  @override
  State<_AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<_AddressesView> {
  @override
  void initState() {
    super.initState();
    context.read<AddressesBloc>().add(const GetAddressesEvent());
  }

  void _showDeleteDialog(BuildContext context, AddressEntity address) {
    AppCustomDialog.show(
      context: context,
      iconPath: AppAssets.removeIcon,
      iconColor: AppColors.error,
      title: 'delete_address_title'.tr(),
      description: 'delete_address_confirm'.tr(),
      primaryButtonText: 'delete'.tr(),
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
          final msg = state.deleteAddressSuccessMessage ?? 'address_deleted_success'.tr();
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
        safeAreaBottom: false,
        body: Column(
          children: [
            // Scrollable Addresses List / Grid
            Expanded(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  final isTabletLandscape = context.isTabletLandscape;

                  if (state.getAddressesStatus == RequestStatus.loading) {
                    if (isTabletLandscape) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 110,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) => const ShimmerPlaceholder(
                          width: double.infinity,
                          height: 110,
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        ),
                      );
                    }

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

                  if (isTabletLandscape) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<AddressesBloc>().add(const GetAddressesEvent());
                      },
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 135,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: state.addresses.length,
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          return AddressCard(
                            address: address,
                            onEditPressed: () {
                              context.push(
                                RoutePaths.addAddress,
                                extra: address,
                              );
                            },
                            onDeletePressed: () => _showDeleteDialog(context, address),
                          );
                        },
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
                          onEditPressed: () {
                            context.push(
                              RoutePaths.addAddress,
                              extra: address,
                            );
                          },
                          onDeletePressed: () => _showDeleteDialog(context, address),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Add Address Button using AppBottomContainer
            AppBottomContainer(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
              child: CustomButton(
                text: 'add_new_address'.tr(),
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.push(RoutePaths.addAddress);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
