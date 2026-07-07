import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    const Color activeTabColor = Color(0xFFE8706A);
    final inactiveColor = Colors.grey.shade600;

    final items = [
      _NavItem(icon: 'assets/icons/home_icon.svg', label: 'home'.tr()),
      _NavItem(icon: 'assets/icons/categories_icon.svg', label: 'categories'.tr()),
      _NavItem(icon: 'assets/icons/orders_icon.svg', label: 'orders'.tr()),
      _NavItem(icon: 'assets/icons/account_icon.svg', label: 'account'.tr()),
    ];

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        // Removed AnimatedSwitcher to fix the Duplicate GlobalKey error
        child: widget.navigationShell,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
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
                      padding: const EdgeInsets.symmetric(vertical: 5.0), // Fixed typo
                      decoration: BoxDecoration(
                        color: isSelected ? activeTabColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(72.0), // Fixed typo
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Fixed typo
                        mainAxisAlignment: MainAxisAlignment.center, // Fixed typo
                        spacing: 2.0,
                        children: [
                          SvgPicture.asset(
                            item.icon,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.white : inactiveColor,
                              BlendMode.srcIn, // Fixed typo
                            ),
                          ),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : inactiveColor,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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