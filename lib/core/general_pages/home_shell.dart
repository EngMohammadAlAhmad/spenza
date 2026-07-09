import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    widget.navigationShell.goBranch(index);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    int newIndex = widget.navigationShell.currentIndex;
    const totalBranches = 4;
    bool shouldNavigate = false;

    if (velocity.abs() > 300) {
      if (velocity < 0) {
        // Swiping LEFT -> Go to PREVIOUS tab
        newIndex--;
      } else if (velocity > 0) {
        // Swiping RIGHT -> Go to NEXT tab
        newIndex++;
      }
      shouldNavigate = true;
    } else if (_dragDistance.abs() > 100) {
      if (_dragDistance < 0) {
        // Dragged LEFT -> Go to PREVIOUS tab
        newIndex--;
      } else if (_dragDistance > 0) {
        // Dragged RIGHT -> Go to NEXT tab
        newIndex++;
      }
      shouldNavigate = true;
    }

    _dragDistance = 0;

    if (shouldNavigate && newIndex >= 0 && newIndex < totalBranches) {
      widget.navigationShell.goBranch(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color activeTabColor = AppColors.primary;
    final inactiveColor = AppColors.neutral;

    final items = [
      _NavItem(icon: 'assets/icons/home_icon.svg', label: 'home'.tr()),
      _NavItem(icon: 'assets/icons/categories_icon.svg', label: 'categories'.tr()),
      _NavItem(icon: 'assets/icons/orders_icon.svg', label: 'orders'.tr()),
      _NavItem(icon: 'assets/icons/account_icon.svg', label: 'account'.tr()),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundLight,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        // Removed AnimatedSwitcher to fix the Duplicate GlobalKey error
        child: widget.navigationShell,
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isSelected = index == widget.navigationShell.currentIndex;
                final item = items[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const .symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: isSelected ? activeTabColor : Colors.transparent,
                        borderRadius: AppRadius.extra4Large,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2.0,
                        children: [
                          SvgPicture.asset(
                            item.icon,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.white : inactiveColor,
                              BlendMode.srcIn,
                            ),
                            width: 25.0,
                          ),
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: isSelected ? Colors.white : inactiveColor,
                              fontWeight: isSelected ? .w700 : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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

class _NavItem {
  final String icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}