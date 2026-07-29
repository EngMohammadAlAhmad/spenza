import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';
import 'package:spenza/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:spenza/injection_locator.dart' as di;

class SearchScreen extends StatefulWidget {
  final int? categoryId;
  final int? brandId;

  const SearchScreen({super.key, this.categoryId, this.brandId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = di.sl<SearchBloc>();
    _scrollController.addListener(_onScroll);
    // Focus the text field after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    // Only close if we created it. Since it's factory in DI, we should close it.
    _searchBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _searchBloc.add(const LoadMoreSearchEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    _focusNode.unfocus();
    _searchBloc.add(PerformSearchEvent(
      q: query,
      categoryId: widget.categoryId,
      brandId: widget.brandId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Search Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.backgroundLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppSearchField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onSubmitted: (value) => _performSearch(value),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<SearchBloc, BaseState<SearchResultEntity>>(
                    builder: (context, state) {
                      if (state.requestStatus == RequestStatus.init) {
                        return _buildInitialState();
                      }

                      final products = state.data?.products ?? [];

                      if (state.isLoading && products.isEmpty) {
                        return _buildLoadingGrid();
                      }

                      if (state.isError && products.isEmpty) {
                        if (state.failure is OfflineFailure) {
                          return NoInternetWidget(
                            onRetry: () {
                              if (_controller.text.isNotEmpty) {
                                _performSearch(_controller.text);
                              }
                            },
                          );
                        }
                        return Center(child: Text(state.errorMessage));
                      }

                      if (products.isEmpty) {
                        return const Center(child: Text('لا توجد نتائج لبحثك'));
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
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 8),
        // Recent Searches
        _buildSectionHeader('عمليات بحث سابقة', 'assets/icons/clock_icon.svg'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            _buildSearchTag('أقلام رصاص'),
            _buildSearchTag('كلاسور'),
          ],
        ),

        const SizedBox(height: 32),

        // Popular Searches
        _buildSectionHeader('الأكثر بحثاً', 'assets/icons/trand_icon.svg'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            _buildSearchTag('دفاتر'),
            _buildSearchTag('أقلام جل'),
            _buildSearchTag('حقيبة مدرسية'),
            _buildSearchTag('ألوان خشبية'),
            _buildSearchTag('ورق A4'),
            _buildSearchTag('آلة حاسبة'),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(AppColors.neutral, BlendMode.srcIn), width: 20, height: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.neutral,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTag(String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: AppRadius.extraLarge,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.neutral900,
            fontWeight: FontWeight.w600,
          ),
        ),
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
