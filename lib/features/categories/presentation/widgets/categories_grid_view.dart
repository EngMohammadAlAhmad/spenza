import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/categories/presentation/blocs/categories_bloc/categories_bloc.dart';
import '../widgets/category_card.dart';

class CategoriesGridView extends StatefulWidget {
  const CategoriesGridView({super.key});

  @override
  State<CategoriesGridView> createState() => _CategoriesGridViewState();
}

class _CategoriesGridViewState extends State<CategoriesGridView> {
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
      context.read<CategoriesBloc>().add(const GetCategoriesEvent());
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
    return BlocBuilder<CategoriesBloc, BaseState<List>>(
      builder: (context, state) {
        if (state.isInit || (state.isLoading && (state.data == null || state.data!.isEmpty))) {
          return _buildLoadingGrid();
        }

        if (state.isError && (state.data == null || state.data!.isEmpty)) {
          return Center(child: Text(state.errorMessage));
        }

        final categories = state.data ?? [];

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 120.0),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 174.0 / 179.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: state.hasReachedMax == true ? categories.length : categories.length + 2,
          itemBuilder: (context, index) {
            if (index >= categories.length) {
              return const ShimmerPlaceholder(
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              );
            }
            final category = categories[index];
            return CategoryCard(
              title: category.name,
              subtitle: '${category.productsCount ?? 0} منتج',
              imageUrl: category.image,
              onTap: () => context.go('${RoutePaths.categories}/${category.id}'),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 120.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 174.0 / 179.0,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => ShimmerPlaceholder(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }
}
