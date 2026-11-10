import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_scaffold.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/core/widgets/filter_bottom_sheet.dart';
import 'package:spenza/features/search/presentation/widgets/search_empty_widget.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/core/widgets/general_error_widget.dart';
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

  double? _minPrice;
  double? _maxPrice;
  int? _inStock;

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
    if (query.trim().isEmpty && _minPrice == null && _maxPrice == null && _inStock == null) return;
    _focusNode.unfocus();
    _searchBloc.add(PerformSearchEvent(
      q: query.trim().isEmpty ? null : query.trim(),
      categoryId: widget.categoryId,
      brandId: widget.brandId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      inStock: _inStock,
    ));
  }

  Future<void> _openFilter() async {
    final result = await FilterBottomSheet.show(
      context: context,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      inStock: _inStock,
    );
    if (result != null && mounted) {
      setState(() {
        _minPrice = result.minPrice;
        _maxPrice = result.maxPrice;
        _inStock = result.inStock;
      });
      _performSearch(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = context.gridColumns(
      mobile: 2,
      tabletPortrait: 4,
      tabletLandscape: 6,
      desktop: 6,
    );

    return BlocProvider.value(
      value: _searchBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AppScaffold(
          titleWidget: AppSearchField(
            controller: _controller,
            focusNode: _focusNode,
            onSubmitted: (value) => _performSearch(value),
          ),
          subtitleWidget: const SizedBox(),
          backgroundColor: AppColors.neutralBackground,
          safeAreaBottom: false,
          body: BlocBuilder<SearchBloc, BaseState<SearchResultEntity>>(
            builder: (context, state) {
              if (state.requestStatus == RequestStatus.init) {
                return _buildInitialState();
              }

              final products = state.data?.products ?? [];

              if (state.isLoading && products.isEmpty) {
                return Column(
                  children: [
                    _buildHeaderRow(state),
                    Expanded(child: _buildLoadingGrid(crossAxisCount)),
                  ],
                );
              }

              if (state.isError && products.isEmpty) {
                if (state.failure is OfflineFailure) {
                  return NoInternetWidget(
                    onRetry: () {
                      if (_controller.text.isNotEmpty || _minPrice != null || _maxPrice != null || _inStock != null) {
                        _performSearch(_controller.text);
                      }
                    },
                  );
                }
                return GeneralErrorWidget(
                  message: state.errorMessage,
                  onRetry: () {
                    if (_controller.text.isNotEmpty || _minPrice != null || _maxPrice != null || _inStock != null) {
                      _performSearch(_controller.text);
                    }
                  },
                );
              }

              if (products.isEmpty) {
                return Column(
                  children: [
                    _buildHeaderRow(state),
                    Expanded(
                      child: SearchEmptyWidget(
                        searchQuery: _controller.text,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _buildHeaderRow(state),
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 174 / 250,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: state.hasReachedMax == true
                          ? products.length
                          : products.length + crossAxisCount,
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BaseState<SearchResultEntity> state) {
    final total = state.data?.total ?? (state.data?.products.length ?? 0);
    final queryText = _controller.text.trim();

    final isFiltered = _minPrice != null ||
        _maxPrice != null ||
        (_inStock != null && _inStock == 1);

    final String countText = queryText.isNotEmpty
        ? 'search_results_count_for_query'.tr(args: [total.toString(), queryText])
        : 'n_products'.tr(args: [total.toString()]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              countText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          FilterButton(
            isFiltered: isFiltered,
            onTap: _openFilter,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 8),
        // Recent Searches
        _buildSectionHeader('recent_searches'.tr(), AppAssets.activityIcon, iconColor: AppColors.neutral),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            _buildSearchTag('search_tag_pencils'.tr()),
            _buildSearchTag('search_tag_binders'.tr()),
          ],
        ),

        const SizedBox(height: 32),

        // Popular Searches
        _buildSectionHeader('trending_searches'.tr(), AppAssets.iconSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            _buildSearchTag('search_tag_notebooks'.tr()),
            _buildSearchTag('search_tag_gel_pens'.tr()),
            _buildSearchTag('search_tag_school_bag'.tr()),
            _buildSearchTag('search_tag_colored_pencils'.tr()),
            _buildSearchTag('search_tag_a4_paper'.tr()),
            _buildSearchTag('search_tag_calculator'.tr()),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String iconPath, {Color? iconColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath, colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null, width: 20, height: 20),
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
        _performSearch(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.extraLarge,
          border: Border.all(
            color: AppColors.neutralBorderStrong,
          )
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

  Widget _buildLoadingGrid(int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
