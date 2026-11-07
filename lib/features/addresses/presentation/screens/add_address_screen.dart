import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/app_scaffold.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/domain/entities/city_entity.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';
import 'package:spenza/features/addresses/domain/entities/update_address_params.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/injection_locator.dart' as di;

class AddAddressScreen extends StatelessWidget {
  final AddressEntity? addressToEdit;

  const AddAddressScreen({super.key, this.addressToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AddressesBloc>(),
      child: _AddAddressView(addressToEdit: addressToEdit),
    );
  }
}

class _AddAddressView extends StatefulWidget {
  final AddressEntity? addressToEdit;

  const _AddAddressView({this.addressToEdit});

  @override
  State<_AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<_AddAddressView> {
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'home'; // 'home', 'work', 'other'
  String _selectedLabel = 'Home';

  GovernorateEntity? _selectedGovernorate;
  CityEntity? _selectedCity;

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isDefault = true;

  bool get isEditing => widget.addressToEdit != null;

  @override
  void initState() {
    super.initState();
    context.read<AddressesBloc>().add(const GetLocationsEvent());
    if (isEditing) {
      final addr = widget.addressToEdit!;
      _selectedType = addr.type.isNotEmpty ? addr.type : 'home';
      _selectedLabel = addr.label.isNotEmpty ? addr.label : 'Home';
      _streetController.text = addr.street;
      _buildingController.text = addr.building;
      _floorController.text = addr.floor;
      _phoneController.text = _formatInitialPhone(addr.phone);
      _isDefault = addr.isDefault;
    }
  }

  static String _formatInitialPhone(String raw) {
    var clean = raw.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('963')) {
      clean = clean.substring(3);
    } else if (clean.startsWith('0') && clean.length == 10) {
      clean = clean.substring(1);
    }
    if (clean.length > 9) {
      clean = clean.substring(0, 9);
    }
    var formatted = '';
    for (var i = 0; i < clean.length; i++) {
      formatted += clean[i];
      if ((i == 2 || i == 5) && i != clean.length - 1) {
        formatted += ' ';
      }
    }
    return formatted;
  }

  String get _formattedPhoneToSubmit {
    final clean = _phoneController.text.replaceAll(' ', '').trim();
    if (clean.startsWith('9') && clean.length == 9) {
      return '0$clean';
    }
    return clean;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onTypeSelected(String type, String label) {
    setState(() {
      _selectedType = type;
      _selectedLabel = label;
    });
  }

  void _submitAddress(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCity == null) {
      SnackbarService.showError(context, message: 'select_governorate_and_area_error'.tr());
      return;
    }

    if (isEditing) {
      final params = UpdateAddressParams(
        addressId: widget.addressToEdit!.id,
        type: _selectedType,
        label: _selectedLabel,
        cityId: _selectedCity!.id,
        area: _selectedCity!.name,
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        floor: _floorController.text.trim(),
        phone: _formattedPhoneToSubmit,
        isDefault: _isDefault,
      );

      context.read<AddressesBloc>().add(UpdateAddressEvent(params));
    } else {
      final params = AddAddressParams(
        type: _selectedType,
        label: _selectedLabel,
        cityId: _selectedCity!.id,
        area: _selectedCity!.name,
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        floor: _floorController.text.trim(),
        phone: _formattedPhoneToSubmit,
        isDefault: _isDefault,
      );

      context.read<AddressesBloc>().add(AddAddressEvent(params));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddressesBloc, AddressesState>(
          listenWhen: (previous, current) =>
              previous.addAddressStatus != current.addAddressStatus,
          listener: (context, state) {
            if (state.addAddressStatus == RequestStatus.success) {
              final msg = state.addAddressSuccessMessage ?? 'address_saved_success'.tr();
              SnackbarService.showSuccess(context, message: msg);
              context.pop(true);
            } else if (state.addAddressStatus == RequestStatus.error) {
              SnackbarService.showError(
                context,
                message: state.addAddressFailure.errMessage,
              );
            }
          },
        ),
        BlocListener<AddressesBloc, AddressesState>(
          listenWhen: (previous, current) =>
              previous.updateAddressStatus != current.updateAddressStatus,
          listener: (context, state) {
            if (state.updateAddressStatus == RequestStatus.success) {
              final msg = state.updateAddressSuccessMessage ?? 'تم تعديل العنوان بنجاح';
              SnackbarService.showSuccess(context, message: msg);
              context.pop(true);
            } else if (state.updateAddressStatus == RequestStatus.error) {
              SnackbarService.showError(
                context,
                message: state.updateAddressFailure.errMessage,
              );
            }
          },
        ),
      ],
      child: AppScaffold(
        title: isEditing ? 'تعديل العنوان' : 'new_address'.tr(),
        body: Column(
          children: [
            // Form Scrollable Body
            Expanded(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  // Sync initial governorate and city selection when locations are loaded
                  if (state.governorates.isNotEmpty && _selectedGovernorate == null) {
                    if (isEditing) {
                      final targetCityId = widget.addressToEdit!.cityId;
                      final targetArea = widget.addressToEdit!.area;

                      for (final gov in state.governorates) {
                        final matchedCity = gov.cities.cast<CityEntity?>().firstWhere(
                          (c) => c != null && (c.id == targetCityId || c.name == targetArea),
                          orElse: () => null,
                        );
                        if (matchedCity != null) {
                          _selectedGovernorate = gov;
                          _selectedCity = matchedCity;
                          break;
                        }
                      }
                    }

                    if (_selectedGovernorate == null ||
                        !state.governorates.contains(_selectedGovernorate)) {
                      _selectedGovernorate = state.governorates.first;
                      _selectedCity = _selectedGovernorate!.cities.isNotEmpty
                          ? _selectedGovernorate!.cities.first
                          : null;
                    }
                  }

                  final isLoadingLocations =
                      state.locationsStatus == RequestStatus.loading;
                  final isTabletLandscape = context.isTabletLandscape;

                  Widget buildFirstColumn() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Address Type Selector
                        Text(
                          'address_type'.tr(),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            _TypeChip(
                              title: 'home_label'.tr(),
                              isSelected: _selectedType == 'home',
                              onTap: () => _onTypeSelected('home', 'Home'),
                            ),
                            const SizedBox(width: 10.0),
                            _TypeChip(
                              title: 'work_label'.tr(),
                              isSelected: _selectedType == 'work',
                              onTap: () => _onTypeSelected('work', 'Work'),
                            ),
                            const SizedBox(width: 10.0),
                            _TypeChip(
                              title: 'other_label'.tr(),
                              isSelected: _selectedType == 'other',
                              onTap: () => _onTypeSelected('other', 'Other'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        // 2. Governorates and Cities Dropdowns
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Governorate Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'governorate'.tr(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.neutral900,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: AppRadius.overMedium,
                                    ),
                                    child: isLoadingLocations
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : DropdownButtonHideUnderline(
                                            child: DropdownButton<GovernorateEntity>(
                                              value: state.governorates.contains(_selectedGovernorate)
                                                  ? _selectedGovernorate
                                                  : null,
                                              isExpanded: true,
                                              hint: Text(
                                                'select_governorate'.tr(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.neutral,
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: AppColors.neutral,
                                              ),
                                              items: state.governorates.map((gov) {
                                                return DropdownMenuItem<GovernorateEntity>(
                                                  value: gov,
                                                  child: Text(
                                                    gov.name,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.neutral900,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _selectedGovernorate = val;
                                                    _selectedCity = val.cities.isNotEmpty
                                                        ? val.cities.first
                                                        : null;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12.0),

                            // Area / City Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'area'.tr(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.neutral900,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: AppRadius.overMedium,
                                    ),
                                    child: isLoadingLocations
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : DropdownButtonHideUnderline(
                                            child: DropdownButton<CityEntity>(
                                              value: (_selectedGovernorate?.cities.contains(_selectedCity) ?? false)
                                                  ? _selectedCity
                                                  : null,
                                              isExpanded: true,
                                              hint: Text(
                                                'select_area'.tr(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.neutral,
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: AppColors.neutral,
                                              ),
                                              items: (_selectedGovernorate?.cities ?? [])
                                                  .map((city) {
                                                return DropdownMenuItem<CityEntity>(
                                                  value: city,
                                                  child: Text(
                                                    city.name,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.neutral900,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _selectedCity = val;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        // 3. Address Details Fields (Street, Building, Floor)
                        Text(
                          'address_details'.tr(),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CustomTextField(
                          controller: _streetController,
                          hintText: 'street_example'.tr(),
                          fillColor: Colors.white,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'street_validation'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _buildingController,
                                hintText: 'building_example'.tr(),
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: CustomTextField(
                                controller: _floorController,
                                hintText: 'floor_example'.tr(),
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'address_helper_text'.tr(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.neutral,
                          ),
                        ),
                      ],
                    );
                  }

                  Widget buildSecondColumn() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. Delivery Phone Field
                        Text(
                          'delivery_phone_number'.tr(),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomTextField(
                            controller: _phoneController,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.neutral900,
                                ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _PhoneInputFormatter(),
                            ],
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 20.0),
                                SvgPicture.asset(AppAssets.syFlag, width: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  '+963',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.neutral700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(
                                  width: 25.0,
                                  height: 52.0,
                                  child: VerticalDivider(
                                    color: AppColors.primaryLight
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            textDirection: TextDirection.ltr,
                            forPhone: true,
                            borderColor: AppColors.primaryLight
                                .withValues(alpha: 0.5),
                            hintText: '9xx xxx xxx',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.neutral,
                                ),
                            fillColor: Colors.white,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'phone_validation'.tr();
                              }
                              final clean = val.replaceAll(' ', '');
                              if (!clean.startsWith('9') || clean.length != 9) {
                                return 'valid_phone_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // 5. Default Address Switch Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.upMedium,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppAssets.homeIcon2),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  'set_as_default_checkbox'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CupertinoSwitch(
                                value: _isDefault,
                                activeTrackColor: AppColors.primary500,
                                onChanged: (val) {
                                  setState(() => _isDefault = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // 6. Delivery Availability Banner
                        if (_selectedGovernorate != null &&
                            _selectedCity != null)
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: AppRadius.upMedium,
                              border: Border.all(
                                color: const Color(0xFFC8E6C9),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF2E7D32),
                                  size: 22.0,
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'we_deliver_to'.tr(args: [_selectedGovernorate!.name, _selectedCity!.name]),
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B5E20),
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        'delivery_info_text'.tr(args: ['${_selectedCity!.deliveryPrice}']),
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF2E7D32),
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }

                  Widget formBody;

                  if (isTabletLandscape) {
                    formBody = Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Child: Address Type + Dropdowns + Details
                        Expanded(
                          flex: 1,
                          child: buildFirstColumn(),
                        ),
                        const SizedBox(width: 20.0),

                        // Second Child: Delivery Phone + Default Switch + Availability Banner
                        Expanded(
                          flex: 1,
                          child: buildSecondColumn(),
                        ),
                      ],
                    );
                  } else {
                    formBody = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFirstColumn(),
                        const SizedBox(height: 20.0),
                        buildSecondColumn(),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                    child: Form(
                      key: _formKey,
                      child: formBody,
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Save / Edit Button
            BlocBuilder<AddressesBloc, AddressesState>(
              builder: (context, state) {
                final isLoading = isEditing
                    ? state.updateAddressStatus == RequestStatus.loading
                    : state.addAddressStatus == RequestStatus.loading;
                return AppBottomContainer(
                  child: CustomButton(
                    text: isEditing ? 'تعديل العنوان' : 'save_address'.tr(),
                    height: 48.0,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submitAddress(context),
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

class _TypeChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.extra4Large,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.neutralBackgroundInverse : Colors.white,
          borderRadius: AppRadius.extra4Large,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.neutralBorderDefault,
            width: 1.0,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.neutral900,
          ),
        ),
      ),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 9) return oldValue;

    var newText = '';
    for (var i = 0; i < text.length; i++) {
      newText += text[i];
      if ((i == 2 || i == 5) && i != text.length - 1) {
        newText += ' ';
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
