import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_bloc.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_event.dart';
import 'package:spenza/features/account/presentation/widgets/account_header.dart';
import 'package:spenza/features/account/presentation/widgets/account_menu_item.dart';
import 'package:spenza/features/account/presentation/widgets/account_menu_section.dart';
import 'package:spenza/features/account/presentation/widgets/business_account_card.dart';
import 'package:spenza/features/account/presentation/widgets/logout_button.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/home/presentation/widgets/points_card.dart';
import 'package:spenza/injection_locator.dart' as di;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('هل أنت تأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.neutral),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await di.sl<CacheHelper>().deleteAuthToken();
              if (context.mounted) {
                context.read<AuthStatusBloc>().add(UpdateAuthStatus(false));
                context.go(RoutePaths.home);
              }
            },
            child: const Text(
              'تأكيد',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AccountBloc>()..add(const GetUserProfileEvent()),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          StatefulNavigationShell.of(context).goBranch(0);
        },
        child: Scaffold(
          backgroundColor: AppColors.neutral200,
          body: BlocBuilder<AccountBloc, BaseState<UserEntity>>(
            builder: (context, state) {
              final user = state.data;
              final isLoading = state.isLoading;

              return Column(
                children: [
                  // Top Header
                  AccountHeader(
                    user: user,
                    isLoading: isLoading,
                    onEditPressed: () {
                      // Profile edit handler
                    },
                  ),

                  // Scrollable Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<AccountBloc>().add(const GetUserProfileEvent());
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                        child: Column(
                          children: [
                            // 1. Points Card (Same as in Home Screen)
                            const PointsCard(),
                            const SizedBox(height: 16.0),

                            // 2. Business Account Banner
                            BusinessAccountCard(
                              onTap: () {
                                // Business account action
                              },
                            ),
                            const SizedBox(height: 20.0),

                            // 3. Account Section ("الحساب")
                            AccountMenuSection(
                              title: 'الحساب',
                              items: [
                                AccountMenuItem(
                                  iconPath: 'assets/icons/my_info_icon.svg',
                                  title: 'معلوماتي',
                                  onTap: () {},
                                ),
                                AccountMenuItem(
                                  iconPath: 'assets/icons/my_addresses_icon.svg',
                                  title: 'عناويني',
                                  onTap: () {
                                    context.push(RoutePaths.addresses);
                                  },
                                ),
                                AccountMenuItem(
                                  iconPath: 'assets/icons/notifications_icon_2.svg',
                                  title: 'الإشعارات',
                                  //badgeText: '2 جديد',
                                  onTap: () {
                                    context.push(RoutePaths.notifications);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),

                            // 4. App Section ("التطبيق")
                            AccountMenuSection(
                              title: 'التطبيق',
                              items: [
                                AccountMenuItem(
                                  iconPath: 'assets/icons/settings_icon.svg',
                                  title: 'الإعدادات',
                                  onTap: () {},
                                ),
                                AccountMenuItem(
                                  iconPath: 'assets/icons/support_icon.svg',
                                  title: 'المساعدة والدعم',
                                  onTap: () {},
                                ),
                                AccountMenuItem(
                                  iconPath: 'assets/icons/terms_icon.svg',
                                  title: 'الشروط والخصوصية',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),

                            // 5. Logout Button
                            LogoutButton(
                              onTap: () => _showLogoutDialog(context),
                            ),
                            const SizedBox(height: 90.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
