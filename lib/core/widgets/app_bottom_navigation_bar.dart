/*
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.receipt_long_rounded,
    Icons.person_outline_rounded,
  ];

  static const _labelKeys = [
    'nav.home',
    'nav.categories',
    'nav.orders',
    'nav.account',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isActive = index == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: isActive ? 56 : 40,
                          height: isActive ? 56 : 40,
                          decoration: BoxDecoration(
                            color: isActive
                                ? colorScheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : null,
                          ),
                          child: Icon(
                            _icons[index],
                            color: isActive
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: isActive ? 26 : 24,
                          ),
                        ),
                        if (!isActive) ...[
                          const SizedBox(height: 4),
                          Text(
                            _labelKeys[index].tr(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}*/
