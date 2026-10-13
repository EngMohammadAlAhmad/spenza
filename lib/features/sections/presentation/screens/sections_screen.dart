import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/brands/presentation/blocs/brands_bloc/brands_bloc.dart';
import 'package:spenza/features/brands/presentation/widgets/brands_grid_view.dart';
import 'package:spenza/features/categories/presentation/blocs/categories_bloc/categories_bloc.dart';
import 'package:spenza/features/categories/presentation/widgets/categories_grid_view.dart';
import 'package:spenza/features/sections/presentation/widgets/sections_header.dart';
import 'package:spenza/injection_locator.dart' as di;

class SectionsScreen extends StatefulWidget {
  final int initialTab;
  const SectionsScreen({super.key, this.initialTab = 0});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialTab;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(SectionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _onTabTapped(widget.initialTab);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentPage == index) return;
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        StatefulNavigationShell.of(context).goBranch(0);
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<CategoriesBloc>()..add(const GetCategoriesEvent(isRefresh: true)),
          ),
          BlocProvider(
            create: (context) => di.sl<BrandsBloc>()..add(const GetBrandsEvent(isRefresh: true)),
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          body: Column(
            children: [
              SectionsHeader(
                currentPage: _currentPage,
                onTabTapped: _onTabTapped,
              ),
              const SizedBox(height: 16.0),
              // Animated Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      CategoriesGridView(),
                      BrandsGridView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
