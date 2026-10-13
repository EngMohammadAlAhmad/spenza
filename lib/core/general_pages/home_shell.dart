import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  double _dragDistance = 0;

  void _onTabTapped(int index) {
    if (index == widget.navigationShell.currentIndex) return;
    HapticFeedback.selectionClick();
    widget.navigationShell.goBranch(index);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    int newIndex = widget.navigationShell.currentIndex;
    const totalBranches = 5;
    bool shouldNavigate = false;

    if (velocity.abs() > 300) {
      if (velocity < 0) {
        newIndex--;
      } else if (velocity > 0) {
        newIndex++;
      }
      shouldNavigate = true;
    } else if (_dragDistance.abs() > 100) {
      if (_dragDistance < 0) {
        newIndex--;
      } else if (_dragDistance > 0) {
        newIndex++;
      }
      shouldNavigate = true;
    }

    _dragDistance = 0;

    if (shouldNavigate && newIndex >= 0 && newIndex < totalBranches) {
      HapticFeedback.selectionClick();
      widget.navigationShell.goBranch(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor = AppColors.neutral;

    final items = [
      _NavItem(
        icon: 'assets/icons/home_icon.svg',
        selectedIcon: 'assets/icons/home_selected.svg',
        label: 'home'.tr(),
      ),
      _NavItem(
        icon: 'assets/icons/sections_icon.svg',
        selectedIcon: 'assets/icons/sections_selected.svg',
        label: 'sections'.tr(),
      ),
      _NavItem(
        icon: 'assets/icons/favorites_icon.svg',
        selectedIcon: 'assets/icons/favorites_selected.svg',
        label: 'favorites'.tr(),
      ),
      _NavItem(
        icon: 'assets/icons/orders_icon.svg',
        selectedIcon: 'assets/icons/orders_selected.svg',
        label: 'orders'.tr(),
      ),
      _NavItem(
        icon: 'assets/icons/account_icon.svg',
        selectedIcon: 'assets/icons/account_selected.svg',
        label: 'account'.tr(),
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundLight,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20.0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isSelected = index == widget.navigationShell.currentIndex;
                final item = items[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: _NavTabItem(
                      item: item,
                      isSelected: isSelected,
                      inactiveColor: inactiveColor,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final Color inactiveColor;

  const _NavTabItem({
    required this.item,
    required this.isSelected,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryTint : Colors.transparent,
            borderRadius: AppRadius.extra4Large,
          ),
          child: SvgPicture.asset(
            isSelected ? item.selectedIcon : item.icon,
            colorFilter: isSelected
                ? null
                : ColorFilter.mode(inactiveColor, BlendMode.srcIn),
            width: 22.0,
            height: 22.0,
          )
              .animate(target: isSelected ? 1 : 0)
              .scaleXY(
                begin: 1.0,
                end: 1.15,
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
        ),
        const SizedBox(height: 3.0),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isSelected ? AppColors.primary : inactiveColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
          child: Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final String icon;
  final String selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
