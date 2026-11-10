import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/api/language_interpretation.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/selection_bottom_sheet.dart';
import 'package:spenza/features/account/presentation/widgets/settings_tile.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/injection_locator.dart';

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
      builder: (bottomSheetContext) {
        return SelectionBottomSheet<String>(
          title: 'language'.tr(),
          selectedValue: context.locale.languageCode,
          options: [
            SelectionOption(
              id: 'ar',
              title: 'arabic'.tr(),
              subtitle: 'rtl_subtitle'.tr(),
              iconPath: AppAssets.languagesIcon,
            ),
            SelectionOption(
              id: 'en',
              title: 'english'.tr(),
              subtitle: 'ltr_subtitle'.tr(),
              iconPath: AppAssets.globeIcon,
            ),
          ],
          onOptionSelected: (lang) {
            Navigator.pop(bottomSheetContext);
            if (lang != context.locale.languageCode) {
              final newLocale = Locale(lang);
              if (sl.isRegistered<LanguageInterceptor>()) {
                sl<LanguageInterceptor>().setLanguage(lang);
              }
              context.setLocale(newLocale);
              context.read<LanguageBloc>().add(ChangeLanguageEvent(languageCode: lang));
            }
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
      builder: (bottomSheetContext) {
        return SelectionBottomSheet<String>(
          title: 'theme'.tr(),
          selectedValue: 'system',
          options: [
            SelectionOption(
              id: 'light',
              title: 'light_theme'.tr(),
              subtitle: 'light_theme_subtitle'.tr(),
              iconPath: AppAssets.sunIcon,
            ),
            SelectionOption(
              id: 'dark',
              title: 'dark_theme'.tr(),
              subtitle: 'dark_theme_subtitle'.tr(),
              iconPath: AppAssets.moonIcon,
            ),
            SelectionOption(
              id: 'system',
              title: 'system_theme'.tr(),
              subtitle: 'system_theme_subtitle'.tr(),
              iconPath: AppAssets.phoneDeviceIcon,
            ),
          ],
          onOptionSelected: (theme) {
            Navigator.pop(bottomSheetContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    // Section 1: Notifications
    final notificationsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
          child: Text(
            'notifications'.tr(),
            style: const TextStyle(
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
                // Item 1: Order & Payment Updates
                SettingsTile(
                  iconPath: AppAssets.documentIcon,
                  title: 'order_and_payment_updates'.tr(),
                  trailing: Switch.adaptive(
                    value: _orderUpdatesEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primary,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.neutralBorderStrong,
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    trackOutlineWidth: WidgetStateProperty.all(0),
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
                // Item 2: Offers & Discounts
                SettingsTile(
                  iconPath: AppAssets.offersAndDiscountsIcon,
                  title: 'offers_and_discounts'.tr(),
                  trailing: Switch.adaptive(
                    value: _offersEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primary,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.neutralBorderStrong,
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    trackOutlineWidth: WidgetStateProperty.all(0),
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 4.0, bottom: 20.0),
          child: Text(
            'order_notifications_info'.tr(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.tertiary,
            ),
          ),
        ),
      ],
    );

    // Section 2: App Settings
    final appSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
          child: Text(
            'app'.tr(),
            style: const TextStyle(
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
                // Item 1: Language
                SettingsTile(
                  iconPath: AppAssets.globeIcon,
                  title: 'language'.tr(),
                  value: context.locale.languageCode == 'ar'
                      ? 'arabic'.tr()
                      : 'english'.tr(),
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

                // Item 2: Theme
                SettingsTile(
                  iconPath: AppAssets.moonIcon,
                  title: 'theme'.tr(),
                  value: 'system_theme'.tr(),
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

                // Item 3: About Spenza
                SettingsTile(
                  iconPath: AppAssets.infoIcon,
                  title: 'about_spenza'.tr(),
                  value: 'version'.tr(),
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

                // Item 4: Rate App
                SettingsTile(
                  iconPath: AppAssets.rateIcon,
                  title: 'rate_app'.tr(),
                  showChevron: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );

    Widget contentBody;
    if (isTabletLandscape) {
      contentBody = Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Physical LEFT side: Section 2 (App Settings)
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: appSection,
              ),
            ),
            const SizedBox(width: 16.0),

            // Physical RIGHT side: Section 1 (Notifications)
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: notificationsSection,
              ),
            ),
          ],
        ),
      );
    } else {
      contentBody = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notificationsSection,
          appSection,
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          AppHeader(
            title: 'settings'.tr(),
            style: AppHeaderStyle.light,
            showBackButton: true,
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),

          // Scrollable Settings Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: contentBody,
            ),
          ),
        ],
      ),
    );
  }
}
