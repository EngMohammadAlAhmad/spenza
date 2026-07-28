import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';
import 'package:spenza/features/categories/presentation/blocs/category_products_bloc/category_products_bloc.dart';
import 'package:spenza/injection_locator.dart' as di;

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  late int _currentCategoryId;
  
  // Cache the root category info to preserve the sub-categories list and breadcrumb path
  dynamic _rootCategory;
  List<dynamic> _rootChildren = [];

  final OverlayPortalController _sortDropdownController = OverlayPortalController();
  final LayerLink _sortLayerLink = LayerLink();

  String _selectedSort = 'الأكثر رواجاً';
  final List<String> _sortOptions = [
    'الأكثر رواجاً',
    'السعر: الأقل أولاً',
    'السعر: الأعلى أولاً',
    'الأعلى تقييماً',
    'الأحدث',
  ];

  @override
  void initState() {
    super.initState();
    _currentCategoryId = widget.categoryId;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryProductsBloc>().add(GetCategoryProductsEvent(categoryId: _currentCategoryId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      body: Column(
        spacing: 15.0,
        children: [
          BlocBuilder<CategoryProductsBloc, BaseState<CategoryProductsResultEntity>>(
            builder: (context, state) {
              // Update root cache only when the main category is loaded
              if (state.isSuccess && state.data?.category.id == widget.categoryId) {
                _rootCategory = state.data?.category;
                _rootChildren = state.data?.children ?? [];
              }
              return _buildHeader(context, state);
            },
          ),
          Expanded(
            child: BlocBuilder<CategoryProductsBloc, BaseState<CategoryProductsResultEntity>>(
              builder: (context, state) {
                final data = state.data;
                final products = data?.products ?? [];

                return _buildProductsGrid(state, products);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BaseState<CategoryProductsResultEntity> state) {
    final currentCategoryName = state.data?.category.name ?? "";
    final isRoot = _currentCategoryId == widget.categoryId;
    final rootName = _rootCategory?.name ?? (isRoot ? currentCategoryName : "");
    final displayChildren = _rootChildren;
    final totalProducts = state.data?.total ?? 0;

    return Container(
      height: 245.0,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.0,
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.0,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(Icons.arrow_back_ios, size: 20.0)),
              ),
              const Expanded(child: AppSearchField(hintText: 'ابحث عن منتج...')),
              Container(
                padding: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tune, size: 25.0, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 13.0),
          Row(
            children: [
              const Text(
                'التصنيفات',
                style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12.0, color: AppColors.neutral),
              if (!isRoot && rootName.isNotEmpty) ...[
                Text(
                  rootName,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12.0, color: AppColors.neutral),
                Text(
                  currentCategoryName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (rootName.isNotEmpty || currentCategoryName.isNotEmpty) ...[
                Text(
                  rootName.isNotEmpty ? rootName : currentCategoryName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 13.0),
          _buildSubCategoriesRow(context, displayChildren),
          const SizedBox(height: 10.0),
          _buildSortRow(context, totalProducts),
        ],
      ),
    );
  }

  Widget _buildSortRow(BuildContext context, int total) {
    return SizedBox(
      height: 37.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: total.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: .w800,
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: 'منتج',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.neutral,
                  ),
                ),
              ],
            ),
          ),
          CompositedTransformTarget(
            link: _sortLayerLink,
            child: OverlayPortal(
              controller: _sortDropdownController,
              overlayChildBuilder: (context) {
                return CompositedTransformFollower(
                  link: _sortLayerLink,
                  targetAnchor: Alignment.bottomLeft,
                  followerAnchor: Alignment.topLeft,
                  offset: const Offset(0.0, 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TapRegion(
                      onTapOutside: (event) => _sortDropdownController.hide(),
                      child: Material(
                        elevation: 15.0,
                        shadowColor: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        child: Container(
                          width: 158.0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.fillColor),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _sortOptions.map((option) {
                              final isSelected = _selectedSort == option;
                              final isLast = option == _sortOptions.last;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() => _selectedSort = option);
                                      _sortDropdownController.hide();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            option,
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              color: isSelected ? AppColors.primary : Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (isSelected)
                                            const Icon(Icons.check, color: AppColors.primary, size: 20)
                                          else
                                            const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    const Divider(height: 1, color: AppColors.fillColor),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () => _sortDropdownController.toggle(),
                child: Container(
                  width: 150.0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.fillColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.swap_vert, size: 18, color: Colors.black),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _selectedSort,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: .bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoriesRow(BuildContext context, List children) {
    return SizedBox(
      height: 40.0,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: children.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool isAll = index == 0;
          final dynamic item = isAll ? null : children[index - 1];
          final int itemId = isAll ? widget.categoryId : item.id;
          final String name = isAll ? 'الكل' : item.name;
          final bool isSelected = _currentCategoryId == itemId;

          return GestureDetector(
            onTap: () {
              if (_currentCategoryId == itemId) return;
              setState(() => _currentCategoryId = itemId);
              context.read<CategoryProductsBloc>().add(GetCategoryProductsEvent(categoryId: itemId, isRefresh: true));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.neutral200,
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.neutral,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(BaseState<CategoryProductsResultEntity> state, List products) {
    if (state.isLoading && products.isEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 174 / 250,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => const ShimmerPlaceholder(width: double.infinity, height: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16))),
      );
    }

    if (state.isError && products.isEmpty) {
      return Center(child: Text(state.errorMessage));
    }

    if (products.isEmpty) {
      return const Center(child: Text('لا يوجد منتجات في هذا التصنيف'));
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 174 / 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.hasReachedMax == true ? products.length : products.length + 2,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const ShimmerPlaceholder(width: double.infinity, height: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16)));
        }
        return ProductCard(product: products[index])
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.9, 0.9));
      },
    );
  }
}
