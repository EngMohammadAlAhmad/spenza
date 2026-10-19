import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/account/presentation/widgets/selection_bottom_sheet.dart';
import 'package:spenza/features/account/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _orderUpdatesEnabled = true;
  bool _offersEnabled = false;

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SelectionBottomSheet<String>(
          title: 'اللغة',
          selectedValue: 'ar',
          options: const [
            SelectionOption(
              id: 'ar',
              title: 'العربية',
              subtitle: 'من اليمين لليسار',
              iconPath: 'assets/icons/languages_icon.svg',
            ),
            SelectionOption(
              id: 'en',
              title: 'English',
              subtitle: 'Left to right',
              iconPath: 'assets/icons/globe_icon.svg',
            ),
          ],
          onOptionSelected: (lang) {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SelectionBottomSheet<String>(
          title: 'المظهر',
          selectedValue: 'system',
          options: const [
            SelectionOption(
              id: 'light',
              title: 'فاتح',
              subtitle: 'خلفية فاتحة مثل البراند',
              iconPath: 'assets/icons/sun_icon.svg',
            ),
            SelectionOption(
              id: 'dark',
              title: 'داكن',
              subtitle: 'مريح بالليل',
              iconPath: 'assets/icons/moon_icon.svg',
            ),
            SelectionOption(
              id: 'system',
              title: 'حسب الجهاز',
              subtitle: 'بيتغير مع إعداد موبايلك',
              iconPath: 'assets/icons/phoneDevice_icon.svg',
            ),
          ],
          onOptionSelected: (theme) {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // Top Header
          Container(
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
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons/back_button_2.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  'الإعدادات',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
          ),

          // Scrollable Settings Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: التنبيهات
                  const Padding(
                    padding: EdgeInsets.only(right: 4.0, bottom: 8.0),
                    child: Text(
                      'التنبيهات',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral700,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.large,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.large,
                      child: Column(
                        children: [
                          // Item 1: تحديثات الطلبات والدفع
                          SettingsTile(
                            iconPath: 'assets/icons/document_icon.svg',
                            title: 'تحديثات الطلبات والدفع',
                            trailing: Switch.adaptive(
                              value: _orderUpdatesEnabled,
                              activeThumbColor: const Color(0xFFC74436),
                              activeTrackColor: const Color(0xFFFDE8E8),
                              onChanged: (val) {
                                setState(() {
                                  _orderUpdatesEnabled = val;
                                });
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              height: 1.0,
                              thickness: 0.8,
                              color: AppColors.neutral200,
                            ),
                          ),
                          // Item 2: العروض والخصومات
                          SettingsTile(
                            iconPath: 'assets/icons/offers_and_discounts_icon.svg',
                            title: 'العروض والخصومات',
                            trailing: Switch.adaptive(
                              value: _offersEnabled,
                              activeThumbColor: const Color(0xFFC74436),
                              activeTrackColor: const Color(0xFFFDE8E8),
                              onChanged: (val) {
                                setState(() {
                                  _offersEnabled = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 4.0, bottom: 20.0),
                    child: Text(
                      'تنبيهات الطلبات بتوصلك لأنها بتخص طلب عم تستناه.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Section 2: التطبيق
                  const Padding(
                    padding: EdgeInsets.only(right: 4.0, bottom: 8.0),
                    child: Text(
                      'التطبيق',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral700,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.large,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.large,
                      child: Column(
                        children: [
                          // Item 1: اللغة
                          SettingsTile(
                            iconPath: 'assets/icons/globe_icon.svg',
                            title: 'اللغة',
                            value: 'العربية',
                            showChevron: true,
                            onTap: () => _showLanguageBottomSheet(context),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              height: 1.0,
                              thickness: 0.8,
                              color: AppColors.neutral200,
                            ),
                          ),

                          // Item 2: المظهر
                          SettingsTile(
                            iconPath: 'assets/icons/moon_icon.svg',
                            title: 'المظهر',
                            value: 'حسب الجهاز',
                            showChevron: true,
                            onTap: () => _showThemeBottomSheet(context),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              height: 1.0,
                              thickness: 0.8,
                              color: AppColors.neutral200,
                            ),
                          ),

                          // Item 3: عن سبينزا
                          SettingsTile(
                            iconPath: 'assets/icons/info_icon.svg',
                            title: 'عن سبينزا',
                            value: 'الإصدار 1.0',
                            showChevron: true,
                            onTap: () {},
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              height: 1.0,
                              thickness: 0.8,
                              color: AppColors.neutral200,
                            ),
                          ),

                          // Item 4: قيم التطبيق
                          SettingsTile(
                            iconPath: 'assets/icons/rate_icon.svg',
                            title: 'قيم التطبيق',
                            showChevron: true,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
