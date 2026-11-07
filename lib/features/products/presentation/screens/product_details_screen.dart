import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:spenza/features/products/presentation/widgets/product_details_bottom_bar.dart';
import 'package:spenza/features/products/presentation/widgets/product_header_section.dart';
import 'package:spenza/features/products/presentation/widgets/product_image_gallery.dart';
import 'package:spenza/features/products/presentation/widgets/product_price_card.dart';
import 'package:spenza/features/products/presentation/widgets/product_quantity_selector.dart';
import 'package:spenza/features/products/presentation/widgets/product_ratings_section.dart';
import 'package:spenza/features/products/presentation/widgets/product_related_section.dart';
import 'package:spenza/features/products/presentation/widgets/product_selling_units_section.dart';
import 'package:spenza/features/products/presentation/widgets/product_specifications_card.dart';
import 'package:spenza/features/products/presentation/widgets/product_variant_options.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        final data = state.dataState.data;

        return Scaffold(
          backgroundColor: AppColors.neutralBackground,
          body: data != null
              ? _buildContent(context, state, data)
              : state.dataState.isError
                  ? (state.dataState.failure is OfflineFailure
                      ? NoInternetWidget(
                          onRetry: () => context
                              .read<ProductDetailsBloc>()
                              .add(GetProductDetailsEvent(productId: productId)),
                        )
                      : SafeArea(
                          child: Center(
                            child: Text(state.dataState.errorMessage),
                          ),
                        ))
                  : _buildLoadingGrid(),
          bottomNavigationBar: data != null
              ? ProductDetailsBottomBar(
                  state: state,
                  data: data,
                  onAddToCart: () {
                    // Action for adding to cart
                  },
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsEntity data,
  ) {
    final product = data.product;
    final formatter = NumberFormat('#,##0');

    // Find matching variant
    ProductVariantEntity? selectedVariant;
    try {
      selectedVariant = product.variants.firstWhere(
        (v) => state.selectedOptions.values
            .every((valId) => v.selectionKey.contains(valId.toString())),
      );
    } catch (_) {
      selectedVariant =
          product.variants.isNotEmpty ? product.variants.first : null;
    }

    final isOutOfStock = selectedVariant != null
        ? !selectedVariant.inStock
        : !product.storage.inStock;
    final int maxQty = selectedVariant != null
        ? selectedVariant.qtyAvailable
        : product.storage.qtyAvailable;

    ProductUnitEntity? selectedUnit;
    try {
      selectedUnit =
          product.units.firstWhere((u) => u.id == state.selectedUnitId);
    } catch (_) {
      selectedUnit = product.units.isNotEmpty ? product.units.first : null;
    }
    final unitTitle = selectedUnit?.title ?? 'piece_unit'.tr();

    final num currentUnitPrice =
        (selectedUnit != null && selectedUnit.discountedPrice > 0)
            ? selectedUnit.discountedPrice
            : ((selectedUnit != null && selectedUnit.price > 0)
                ? selectedUnit.price
                : product.discountedPrice);
    final num originalUnitPrice =
        (selectedUnit != null && selectedUnit.price > 0)
            ? selectedUnit.price
            : product.price;
    final bool hasUnitDiscount = originalUnitPrice > currentUnitPrice;

    if (context.isTabletLandscape) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right Column (in RTL: Gallery + Description + Specifications)
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageGallery(
                        product: product.toProductEntity(),
                        images: product.gallery,
                        sideImages: product.sideImages,
                        video: product.video,
                        model3d: product.model3d,
                        isTabletLandscape: true,
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'description'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
                      const SizedBox(height: 12.0),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).animate().fadeIn(delay: 1280.ms, duration: 650.ms),
                      if (product.specifications.isNotEmpty) ...[
                        const SizedBox(height: 30.0),
                        Text(
                          'specifications'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ).animate().fadeIn(delay: 1320.ms, duration: 600.ms),
                        const SizedBox(height: 12.0),
                        ProductSpecificationsCard(specifications: product.specifications)
                            .animate()
                            .fadeIn(delay: 1360.ms, duration: 650.ms)
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              duration: 650.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 24.0),

                // Left Column (in RTL: Header + Price + Units + Variants + Quantity + Ratings)
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductHeaderSection(
                        product: product,
                        isOutOfStock: isOutOfStock,
                      ),
                      const SizedBox(height: 20.0),
                      ProductPriceCard(
                        currentPrice: currentUnitPrice,
                        originalPrice: originalUnitPrice,
                        hasDiscount: hasUnitDiscount,
                        unitTitle: unitTitle,
                        formatter: formatter,
                      ).animate().fadeIn(delay: 600.ms, duration: 650.ms).slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 650.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      const SizedBox(height: 24.0),
                      if (product.units.isNotEmpty) ...[
                        ProductSellingUnitsSection(
                          units: product.units,
                          selectedUnitId: state.selectedUnitId,
                          defaultDiscountedPrice: product.discountedPrice,
                          defaultPrice: product.price,
                          formatter: formatter,
                          isTabletLandscape: context.isTabletLandscape,
                          onUnitSelected: (id) => context
                              .read<ProductDetailsBloc>()
                              .add(SelectUnitEvent(id)),
                        ).animate().fadeIn(delay: 800.ms, duration: 650.ms).slideY(
                          begin: 0.08,
                          end: 0.0,
                          duration: 650.ms,
                          curve: Curves.easeOutCubic,
                        ),
                        const SizedBox(height: 24.0),
                      ],
                      for (var option in product.variantOptions) ...[
                        Text(
                          option.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w800),
                        ).animate().fadeIn(delay: 950.ms, duration: 600.ms),
                        const SizedBox(height: 12),
                        ProductVariantOptions(
                          options: option.values
                              .map((v) => SelectionItem(id: v.valueId, label: v.name))
                              .toList(),
                          selectedId: state.selectedOptions[option.attributeId] ?? 0,
                          onSelected: (valId) => context.read<ProductDetailsBloc>().add(
                                SelectVariantOptionEvent(
                                  attributeId: option.attributeId,
                                  valueId: valId,
                                ),
                              ),
                        ).animate().fadeIn(delay: 1020.ms, duration: 650.ms).slideY(
                              begin: 0.08,
                              end: 0,
                              duration: 650.ms,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 24),
                      ],
                      ProductQuantitySection(
                        quantity: state.quantity,
                        maxQty: maxQty,
                        unitTitle: unitTitle,
                        onQuantityChanged: (delta) => context
                            .read<ProductDetailsBloc>()
                            .add(UpdateQuantityEvent(delta, maxQuantity: maxQty)),
                      ).animate().fadeIn(delay: 1100.ms, duration: 700.ms).slideY(
                        begin: 0.05,
                        end: 0.0,
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      const SizedBox(height: 30.0),
                      ProductRatingsSection(
                        rate: product.rate,
                        ratingsCount: product.ratingsCount,
                      ).animate().fadeIn(delay: 1400.ms, duration: 650.ms).slideY(
                        begin: 0.05,
                        end: 0.0,
                        duration: 650.ms,
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48.0),
            ProductRelatedSection(relatedProducts: data.relatedProducts),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ProductImageGallery(
        product: product.toProductEntity(),
        images: product.gallery,
        sideImages: product.sideImages,
        video: product.video,
        model3d: product.model3d,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Category, Title, Rating & Availability)
              ProductHeaderSection(
                product: product,
                isOutOfStock: isOutOfStock,
              ),

              const SizedBox(height: 20.0),

              // Price Section Card
              ProductPriceCard(
                currentPrice: currentUnitPrice,
                originalPrice: originalUnitPrice,
                hasDiscount: hasUnitDiscount,
                unitTitle: unitTitle,
                formatter: formatter,
              ).animate().fadeIn(delay: 600.ms, duration: 650.ms).slideY(
                begin: 0.08,
                end: 0,
                duration: 650.ms,
                curve: Curves.easeOutCubic,
              ),

              const SizedBox(height: 24.0),

              // Selling Units Section
              if (product.units.isNotEmpty) ...[
                ProductSellingUnitsSection(
                  units: product.units,
                  selectedUnitId: state.selectedUnitId,
                  defaultDiscountedPrice: product.discountedPrice,
                  defaultPrice: product.price,
                  formatter: formatter,
                  isTabletLandscape: context.isTabletLandscape,
                  onUnitSelected: (id) => context
                      .read<ProductDetailsBloc>()
                      .add(SelectUnitEvent(id)),
                ).animate().fadeIn(delay: 800.ms, duration: 650.ms).slideY(
                  begin: 0.08,
                  end: 0.0,
                  duration: 650.ms,
                  curve: Curves.easeOutCubic,
                ),
                const SizedBox(height: 24.0),
              ],

              // Variants (if any)
              for (var option in product.variantOptions) ...[
                Text(
                  option.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w800),
                ).animate().fadeIn(delay: 950.ms, duration: 600.ms),
                const SizedBox(height: 12),
                ProductVariantOptions(
                  options: option.values
                      .map((v) => SelectionItem(id: v.valueId, label: v.name))
                      .toList(),
                  selectedId: state.selectedOptions[option.attributeId] ?? 0,
                  onSelected: (valId) => context.read<ProductDetailsBloc>().add(
                        SelectVariantOptionEvent(
                          attributeId: option.attributeId,
                          valueId: valId,
                        ),
                      ),
                ).animate().fadeIn(delay: 1020.ms, duration: 650.ms).slideY(
                      begin: 0.08,
                      end: 0,
                      duration: 650.ms,
                      curve: Curves.easeOutCubic,
                    ),
                const SizedBox(height: 24),
              ],

              // Quantity Selector
              ProductQuantitySection(
                quantity: state.quantity,
                maxQty: maxQty,
                unitTitle: unitTitle,
                onQuantityChanged: (delta) => context
                    .read<ProductDetailsBloc>()
                    .add(UpdateQuantityEvent(delta, maxQuantity: maxQty)),
              ).animate().fadeIn(delay: 1100.ms, duration: 700.ms).slideY(
                begin: 0.05,
                end: 0.0,
                duration: 700.ms,
                curve: Curves.easeOutCubic,
              ),

              const SizedBox(height: 30.0),

              // Description
              Text(
                'description'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
              const SizedBox(height: 12.0),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 1280.ms, duration: 650.ms),

              // Specifications
              if (product.specifications.isNotEmpty) ...[
                const SizedBox(height: 30.0),
                Text(
                  'specifications'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(delay: 1320.ms, duration: 600.ms),
                const SizedBox(height: 12.0),
                ProductSpecificationsCard(specifications: product.specifications)
                    .animate()
                    .fadeIn(delay: 1360.ms, duration: 650.ms)
                    .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: 650.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ],

              // Ratings Section
              const SizedBox(height: 30.0),
              ProductRatingsSection(
                rate: product.rate,
                ratingsCount: product.ratingsCount,
              ).animate().fadeIn(delay: 1400.ms, duration: 650.ms).slideY(
                begin: 0.05,
                end: 0.0,
                duration: 650.ms,
                curve: Curves.easeOutCubic,
              ),

              const SizedBox(height: 48),

              // Related Products
              ProductRelatedSection(relatedProducts: data.relatedProducts),

              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
