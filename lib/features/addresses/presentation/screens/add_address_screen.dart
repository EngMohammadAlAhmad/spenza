import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/entities/city_entity.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/features/addresses/presentation/widgets/addresses_header.dart';
import 'package:spenza/injection_locator.dart' as di;

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AddressesBloc>()..add(const GetLocationsEvent()),
      child: const _AddAddressView(),
    );
  }
}

class _AddAddressView extends StatefulWidget {
  const _AddAddressView();

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
      SnackbarService.showError(context, message: 'الرجاء اختيار المحافظة والمنطقة');
      return;
    }

    final params = AddAddressParams(
      type: _selectedType,
      label: _selectedLabel,
      cityId: _selectedCity!.id,
      area: _selectedCity!.name,
      street: _streetController.text.trim(),
      building: _buildingController.text.trim(),
      floor: _floorController.text.trim(),
      phone: _phoneController.text.trim(),
      isDefault: _isDefault,
    );

    context.read<AddressesBloc>().add(AddAddressEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressesBloc, AddressesState>(
      listenWhen: (previous, current) =>
          previous.addAddressStatus != current.addAddressStatus,
      listener: (context, state) {
        if (state.addAddressStatus == RequestStatus.success) {
          final msg = state.addAddressSuccessMessage ?? 'تم حفظ العنوان بنجاح';
          SnackbarService.showSuccess(context, message: msg);
          context.pop(true);
        } else if (state.addAddressStatus == RequestStatus.error) {
          SnackbarService.showError(
            context,
            message: state.addAddressFailure.errMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        body: Column(
          children: [
            // Top Header
            const AddressesHeader(title: 'عنوان جديد'),

            // Form Scrollable Body
            Expanded(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  // Sync initial governorate and city selection when locations are loaded
                  if (state.governorates.isNotEmpty) {
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

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Address Type Selector
                          const Text(
                            'نوع العنوان',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              _TypeChip(
                                title: 'المنزل',
                                isSelected: _selectedType == 'home',
                                onTap: () => _onTypeSelected('home', 'Home'),
                              ),
                              const SizedBox(width: 10.0),
                              _TypeChip(
                                title: 'العمل',
                                isSelected: _selectedType == 'work',
                                onTap: () => _onTypeSelected('work', 'Work'),
                              ),
                              const SizedBox(width: 10.0),
                              _TypeChip(
                                title: 'غير هيك',
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
                                    const Text(
                                      'المحافظة',
                                      style: TextStyle(
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
                                              child: DropdownButton<
                                                  GovernorateEntity>(
                                                value: state.governorates
                                                        .contains(_selectedGovernorate)
                                                    ? _selectedGovernorate
                                                    : null,
                                                isExpanded: true,
                                                hint: const Text(
                                                  'اختر المحافظة',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColors.neutral,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: AppColors.neutral,
                                                ),
                                                items: state.governorates
                                                    .map((gov) {
                                                  return DropdownMenuItem<
                                                      GovernorateEntity>(
                                                    value: gov,
                                                    child: Text(
                                                      gov.name,
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.neutral900,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    setState(() {
                                                      _selectedGovernorate = val;
                                                      _selectedCity = val
                                                              .cities.isNotEmpty
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
                                    const Text(
                                      'المنطقة',
                                      style: TextStyle(
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
                                              child: DropdownButton<
                                                  CityEntity>(
                                                value: (_selectedGovernorate
                                                            ?.cities
                                                            .contains(
                                                                _selectedCity) ??
                                                        false)
                                                    ? _selectedCity
                                                    : null,
                                                isExpanded: true,
                                                hint: const Text(
                                                  'اختر المنطقة',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColors.neutral,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: AppColors.neutral,
                                                ),
                                                items: (_selectedGovernorate
                                                            ?.cities ??
                                                        [])
                                                    .map((city) {
                                                  return DropdownMenuItem<
                                                      CityEntity>(
                                                    value: city,
                                                    child: Text(
                                                      city.name,
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.neutral900,
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
                          const Text(
                            'تفاصيل العنوان',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: _streetController,
                            hintText: 'مثال: شارع الجلاء',
                            fillColor: Colors.white,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'الرجاء إدخال الشارع';
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
                                  hintText: 'مثال: بناء 12',
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: CustomTextField(
                                  controller: _floorController,
                                  hintText: 'مثال: طابق 3',
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          const Text(
                            'الشارع، البناء، الطابق، وأي علامة بتساعد المندوب',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.neutral,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // 4. Delivery Phone Field
                          const Text(
                            'رقم الموبايل للتوصيل',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: _phoneController,
                            hintText: '09xx xxx xxx',
                            fillColor: Colors.white,
                            textDirection: TextDirection.ltr,
                            forPhone: true,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'الرجاء إدخال رقم الموبايل';
                              }
                              return null;
                            },
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
                                SvgPicture.asset('assets/icons/home_icon_2.svg'),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    'خليه عنواني الافتراضي',
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
                                          'منوصل لـ ${_selectedGovernorate!.name} - ${_selectedCity!.name}',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B5E20),
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'توصيل عادي خلال 48 ساعة بـ ${_selectedCity!.deliveryPrice}، والكاش عند الاستلام متاح.',
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
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Save Button
            BlocBuilder<AddressesBloc, AddressesState>(
              builder: (context, state) {
                final isLoading =
                    state.addAddressStatus == RequestStatus.loading;
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
                    text: 'احفظ العنوان',
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
