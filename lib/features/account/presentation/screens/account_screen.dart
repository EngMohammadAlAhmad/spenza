import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/utils/tab_index_notifier.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_dialog.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_bloc.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_event.dart';
import 'package:spenza/features/account/presentation/widgets/account_header.dart';
import 'package:spenza/features/account/presentation/widgets/account_menu_item.dart';
import 'package:spenza/features/account/presentation/widgets/account_menu_section.dart';
import 'package:spenza/features/account/presentation/widgets/business_account_card.dart';
import 'package:spenza/features/account/presentation/widgets/logout_button.dart';
import 'package:spenza/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/home/presentation/widgets/points_card.dart';
import 'package:spenza/injection_locator.dart' as di;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  /// Index of the Account branch in the bottom navigation bar.
  static const int _tabIndex = 4;

  /// Changing this value changes the animation keys, which restarts them.
  int _animTrigger = 0;
  int _lastIndex = navTabIndex.value;

  @override
  void initState() {
    super.initState();
    navTabIndex.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final index = navTabIndex.value;
    if (index == _tabIndex && _lastIndex != _tabIndex && mounted) {
      setState(() => _animTrigger++);
    }
    _lastIndex = index;
  }

  @override
  void dispose() {
    navTabIndex.removeListener(_onTabChanged);
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    AppCustomDialog.show(
      context: context,
      iconPath: AppAssets.logoutIcon,
      iconColor: AppColors.primary500,
      title: 'logout_confirmation_title'.tr(),
      description: 'logout_confirmation_message'.tr(),
      primaryButtonText: 'logout'.tr(),
      primaryButtonColor: AppColors.primary500,
      secondaryButtonText: 'cancel'.tr(),
      onPrimaryPressed: () async {
        final navigator = Navigator.of(context, rootNavigator: true);
        navigator.pop();

        await di.sl<LogoutUseCase>().call();
        await di.sl<CacheHelper>().deleteAuthToken();

        if (context.mounted) {
          context.read<AuthStatusBloc>().add(UpdateAuthStatus(false));
          context.go(RoutePaths.home);
        }
      },
    );
  }

  Widget _buildGuestView(BuildContext context) {
    final keyPrefix = 'guest_anim_$_animTrigger';

    return Column(
      children: [
        // Top Header for Guest
        Container(
          height: context.screenPadding.top + 60.0,
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
            top: context.screenPadding.top,
            left: 20.0,
            right: 20.0,
          ),
          alignment: Alignment.centerRight,
          child: Text(
            'account'.tr(),
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
            .animate(key: ValueKey('${keyPrefix}_header'))
            .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.06, end: 0, curve: Curves.easeOutCubic),

        // Content Body
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: Column(
              children: [
                // Login Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.extraLarge,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.personalData,
                      ).animate(key: ValueKey('${keyPrefix}_img')).scale(
                        delay: 150.ms,
                        duration: 450.ms,
                        curve: Curves.easeOutBack,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'welcome_title'.tr(),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'welcome_subtitle'.tr(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withValues(alpha: 0.6),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      CustomButton(
                        text: 'login'.tr(),
                        onPressed: () => context.push(RoutePaths.login),
                        height: 50.0,
                      ),
                    ],
                  ),
                )
                    .animate(key: ValueKey('${keyPrefix}_login_card'))
                    .fadeIn(delay: 60.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 16.0),

                // Options Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.extraLarge,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.extraLarge,
                    child: Column(
                      children: [
                        AccountMenuItem(
                          iconPath: AppAssets.settingsIcon,
                          title: 'settings'.tr(),
                          onTap: () => context.push(RoutePaths.settings),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            height: 1.0,
                            thickness: 0.8,
                            color: AppColors.neutral200,
                          ),
                        ),
                        AccountMenuItem(
                          iconPath: AppAssets.supportIcon,
                          title: 'help_and_support'.tr(),
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
                        AccountMenuItem(
                          iconPath: AppAssets.termsIcon,
                          title: 'terms_and_privacy'.tr(),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(key: ValueKey('${keyPrefix}_options'))
                    .fadeIn(delay: 150.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 90.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToMyInfo(BuildContext context, UserEntity? user) {
    context.push(RoutePaths.myInfo, extra: user).then((result) {
      if (result != null && context.mounted) {
        context.read<AccountBloc>().add(const GetUserProfileEvent());
      }
    });
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
          body: BlocBuilder<AuthStatusBloc, AuthStatusState>(
            builder: (context, authState) {
              if (!authState.isLoggedIn) {
                return _buildGuestView(context);
              }

              return BlocBuilder<AccountBloc, BaseState<UserEntity>>(
                builder: (context, state) {
                  final user = state.data;
                  final isLoading = state.isLoading;
                  final keyPrefix = 'user_anim_$_animTrigger';

                  return Column(
                    children: [
                      // Top Header
                      AccountHeader(
                        user: user,
                        isLoading: isLoading,
                        onEditPressed: () => _navigateToMyInfo(context, user),
                      )
                          .animate(key: ValueKey('${keyPrefix}_header'))
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .slideY(begin: -0.06, end: 0, curve: Curves.easeOutCubic),

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
                                // 1. Points Card
                                const PointsCard()
                                    .animate(key: ValueKey('${keyPrefix}_points'))
                                    .fadeIn(delay: 40.ms, duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic)
                                    .scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0)),

                                const SizedBox(height: 16.0),

                                // 2. Business Account Banner
                                BusinessAccountCard(
                                  onTap: () {
                                    context.push(RoutePaths.businessAccount);
                                  },
                                )
                                    .animate(key: ValueKey('${keyPrefix}_business'))
                                    .fadeIn(delay: 80.ms, duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic)
                                    .scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0)),

                                const SizedBox(height: 20.0),

                                // 3. Account Section ("الحساب")
                                AccountMenuSection(
                                  title: 'account'.tr(),
                                  items: [
                                    AccountMenuItem(
                                      iconPath: AppAssets.myInfoIcon,
                                      title: 'my_info'.tr(),
                                      onTap: () => _navigateToMyInfo(context, user),
                                    ),
                                    AccountMenuItem(
                                      iconPath: AppAssets.myAddressesIcon,
                                      title: 'my_addresses'.tr(),
                                      onTap: () {
                                        context.push(RoutePaths.addresses);
                                      },
                                    ),
                                    AccountMenuItem(
                                      iconPath: AppAssets.notificationsIcon2,
                                      title: 'notifications'.tr(),
                                      onTap: () {
                                        context.push(RoutePaths.notifications);
                                      },
                                    ),
                                  ],
                                )
                                    .animate(key: ValueKey('${keyPrefix}_acc_section'))
                                    .fadeIn(delay: 120.ms, duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                                const SizedBox(height: 20.0),

                                // 4. App Section ("التطبيق")
                                AccountMenuSection(
                                  title: 'app'.tr(),
                                  items: [
                                    AccountMenuItem(
                                      iconPath: AppAssets.settingsIcon,
                                      title: 'settings'.tr(),
                                      onTap: () => context.push(RoutePaths.settings),
                                    ),
                                    AccountMenuItem(
                                      iconPath: AppAssets.supportIcon,
                                      title: 'help_and_support'.tr(),
                                      onTap: () {},
                                    ),
                                    AccountMenuItem(
                                      iconPath: AppAssets.termsIcon,
                                      title: 'terms_and_privacy'.tr(),
                                      onTap: () {},
                                    ),
                                  ],
                                )
                                    .animate(key: ValueKey('${keyPrefix}_app_section'))
                                    .fadeIn(delay: 160.ms, duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                                const SizedBox(height: 20.0),

                                // 5. Logout Button
                                LogoutButton(
                                  onTap: () => _showLogoutDialog(context),
                                )
                                    .animate(key: ValueKey('${keyPrefix}_logout'))
                                    .fadeIn(delay: 200.ms, duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                                const SizedBox(height: 90.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}