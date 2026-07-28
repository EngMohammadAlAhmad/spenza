import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BrandProductsBloc>().add(GetBrandProductsEvent(brandId: widget.brandId));
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
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<BrandProductsBloc, BaseState<BrandProductsResultEntity>>(
              builder: (context, state) {
                final products = state.data?.products ?? [];

                if (state.isLoading && products.isEmpty) {
                  return _buildLoadingGrid();
                }

                if (state.isError && products.isEmpty) {
                  return Center(child: Text(state.errorMessage));
                }

                if (products.isEmpty) {
                  return const Center(child: Text('لا يوجد منتجات لهذه الماركة'));
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<BrandProductsBloc, BaseState<BrandProductsResultEntity>>(
                builder: (context, state) {
                  return Text(
                    state.data?.brand.name ?? "",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.neutral),
              const Text(
                ' الماركات ',
                style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 174 / 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerPlaceholder(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
