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
                // Always show siblings from the root level
                final displayChildren = _rootChildren;
                final categoryName = _rootCategory?.name ?? data?.category.name ?? "...";

                return Column(
                  children: [
                    _buildSubCategoriesRow(context, categoryName, displayChildren),
                    Expanded(
                      child: _buildProductsGrid(state, products),
                    ),
                  ],
                );
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

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            spacing: 8.0,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const Expanded(child: AppSearchField()),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tune, size: 20, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                ' التصنيفات ',
                style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.neutral),
              if (!isRoot && rootName.isNotEmpty) ...[
                Text(
                  rootName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.neutral),
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
        ],
      ),
    );
  }

  Widget _buildSubCategoriesRow(BuildContext context, String parentName, List children) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        //reverse: true, // RTL
        itemCount: children.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.fillColor,
                  width: 1,
                ),
                boxShadow: isSelected ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
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
        itemBuilder: (_, __) => const ShimmerPlaceholder(width: double.infinity, height: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16))),
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
