import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
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
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';
import 'package:spenza/features/brands/presentation/blocs/brand_products_bloc/brand_products_bloc.dart';

class BrandProductsScreen extends StatefulWidget {
  final int brandId;

  const BrandProductsScreen({super.key, required this.brandId});

  @override
  State<BrandProductsScreen> createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedSortKey = 'default';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BrandProductsBloc>().add(
          GetBrandProductsEvent(
            brandId: widget.brandId,
            isRefresh: true,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<BrandProductsBloc>().state;
      if (state.hasReachedMax == false && !state.isLoading) {
        context.read<BrandProductsBloc>().add(
          GetBrandProductsEvent(
            brandId: widget.brandId,
            sort: _selectedSortKey,
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
            inStock: state.inStock,
          ),
        );
      }
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
    final crossAxisCount = context.gridColumns(
      mobile: 2,
      tabletPortrait: 4,
      tabletLandscape: 6,
      desktop: 6,
    );

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: BlocBuilder<BrandProductsBloc, BaseState<BrandProductsResultEntity>>(
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(context, state),
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<BrandProductsBloc, BaseState<BrandProductsResultEntity>>(
                  builder: (context, state) {
                    final data = state.data;
                    final products = data?.products ?? [];

                    if (state.isLoading && (products.isEmpty || state.currentPage == 1)) {
                      return _buildLoadingGrid(crossAxisCount);
                    }

                    if (state.isError && products.isEmpty) {
                      if (state.failure is OfflineFailure) {
                        return NoInternetWidget(
                          onRetry: () {
                            context.read<BrandProductsBloc>().add(GetBrandProductsEvent(
                                  brandId: widget.brandId,
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
                          title: 'no_products_for_brand'.tr(),
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
                          return const ShimmerPlaceholder(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          );
                        }
                        return ProductCard(product: products[index])
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(0.9, 0.9));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BaseState<BrandProductsResultEntity> state) {
    final brandName = state.data?.brand.name ?? "";
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
                  onTap: () {
                    context.push('${RoutePaths.search}?brandId=${widget.brandId}');
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
                    context.read<BrandProductsBloc>().add(
                          GetBrandProductsEvent(
                            brandId: widget.brandId,
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
          const SizedBox(height: 13.0),
          Row(
            children: [
              Text(
                'brands'.tr(),
                style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12.0, color: AppColors.neutral),
              Text(
                brandName,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
              final currentState = context.read<BrandProductsBloc>().state;
              context.read<BrandProductsBloc>().add(
                    GetBrandProductsEvent(
                      brandId: widget.brandId,
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

  Widget _buildLoadingGrid(int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 174 / 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: crossAxisCount * 3,
      itemBuilder: (_, _) => const ShimmerPlaceholder(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
