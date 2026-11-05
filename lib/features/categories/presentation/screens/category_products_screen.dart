import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_back_button.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/empty_result_widget.dart';
import 'package:spenza/core/widgets/filter_bottom_sheet.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/sort_bottom_sheet.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';
import 'package:spenza/features/categories/presentation/blocs/category_products_bloc/category_products_bloc.dart';
import 'package:spenza/core/utils/animations/circular_reveal_route.dart';
import 'package:spenza/features/search/presentation/screens/search_screen.dart';
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/core/errors/failure.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  late int _currentCategoryId;
  String _selectedSortKey = 'newest';

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
      final state = context.read<CategoryProductsBloc>().state;
      context.read<CategoryProductsBloc>().add(GetCategoryProductsEvent(
        categoryId: _currentCategoryId,
        sort: _selectedSortKey,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        inStock: state.inStock,
      ));
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BaseState<CategoryProductsResultEntity> state) {
    final currentCategoryName = state.data?.category.name ?? "";
    final isRoot = _currentCategoryId == widget.categoryId;
    final rootName = _rootCategory?.name ?? (isRoot ? currentCategoryName : "");
    final displayChildren = _rootChildren;
    final totalProducts = (state.data?.total != null && state.data!.total > 0)
        ? state.data!.total
        : (state.data?.products.length ?? 0);

    return Container(
      padding: EdgeInsets.only(
        top: context.screenPadding.top + 8.0,
        left: 16.0,
        right: 16.0,
        bottom: 12.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        spacing: 10.0,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.0,
            children: [
              const AppBackButton(),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    Navigator.push(
                      context,
                      CircularRevealRoute(
                        page: SearchScreen(categoryId: _currentCategoryId),
                        center: details.globalPosition,
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: AppSearchField(
                      readOnly: true,
                      hintText: 'search_product_placeholder'.tr(),
                    ),
                  ),
                ),
              ),
              FilterButton(
                onlyIcon: true,
                isFiltered: state.minPrice != null ||
                    state.maxPrice != null ||
                    (state.inStock != null && state.inStock == 1),
                onTap: () async {
                  final result = await FilterBottomSheet.show(
                    context: context,
                    minPrice: state.minPrice,
                    maxPrice: state.maxPrice,
                    inStock: state.inStock,
                  );
                  if (result != null && context.mounted) {
                    context.read<CategoryProductsBloc>().add(
                          GetCategoryProductsEvent(
                            categoryId: _currentCategoryId,
                            sort: _selectedSortKey,
                            minPrice: result.minPrice,
                            maxPrice: result.maxPrice,
                            inStock: result.inStock,
                            isRefresh: true,
                          ),
                        );
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'categories'.tr(),
                style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
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
          _buildSubCategoriesRow(context, displayChildren),
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
          Text(
            'n_products'.tr(args: [total.toString()]),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          ProductSortButton(
            selectedKey: _selectedSortKey,
            onSortChanged: (newSortKey) {
              setState(() => _selectedSortKey = newSortKey);
              final currentState = context.read<CategoryProductsBloc>().state;
              context.read<CategoryProductsBloc>().add(
                GetCategoryProductsEvent(
                  categoryId: _currentCategoryId,
                  sort: newSortKey,
                  minPrice: currentState.minPrice,
                  maxPrice: currentState.maxPrice,
                  inStock: currentState.inStock,
                  isRefresh: true,
                ),
              );
            },
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
          final String name = isAll ? 'all'.tr() : item.name;
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
                borderRadius: AppRadius.extraLarge2,
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
    final crossAxisCount = context.gridColumns(
      mobile: 2,
      tabletPortrait: 4,
      tabletLandscape: 6,
      desktop: 6,
    );

    if (state.isLoading && (products.isEmpty || state.currentPage == 1)) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 174 / 250,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: crossAxisCount * 3,
        itemBuilder: (_, _) => const ShimmerPlaceholder(width: double.infinity, height: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16))),
      );
    }

    if (state.isError && products.isEmpty) {
      if (state.failure is OfflineFailure) {
        return NoInternetWidget(
          onRetry: () {
            context.read<CategoryProductsBloc>().add(GetCategoryProductsEvent(
              categoryId: _currentCategoryId,
              isRefresh: true,
            ));
          },
        );
      }
      return Center(child: Text(state.errorMessage));
    }

    if (products.isEmpty) {
      return Center(
        child: EmptyResultWidget(
          title: 'no_products_in_category'.tr(),
          subtitle: 'no_products_subtitle'.tr(),
          showShoppingButton: false,
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 174 / 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.hasReachedMax == true ? products.length : products.length + crossAxisCount,
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
