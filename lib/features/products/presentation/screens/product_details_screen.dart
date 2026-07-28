import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:spenza/features/products/presentation/widgets/product_image_gallery.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        final data = state.dataState.data;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: data != null
              ? _buildContent(context, state, data)
              : state.dataState.isError
                  ? SafeArea(child: Center(child: Text(state.dataState.errorMessage)))
                  : _buildLoadingGrid(),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ProductDetailsState state, ProductDetailsEntity data) {
    final product = data.product;
    final formatter = NumberFormat('#,##0');

    // Find matching variant (simplified logic based on available keys)
    ProductVariantEntity? selectedVariant;
    try {
      selectedVariant = product.variants.firstWhere(
        (v) => state.selectedOptions.values.every((valId) => v.selectionKey.contains(valId.toString())),
      );
    } catch (_) {
      selectedVariant = product.variants.isNotEmpty ? product.variants.first : null;
    }

    final isOutOfStock = selectedVariant != null ? !selectedVariant.inStock : !product.storage.inStock;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gallery with "Save" Badge
          Stack(
            children: [
              ProductImageGallery(
                images: product.gallery,
                sideImages: product.sideImages,
                video: product.video,
                model3d: product.model3d,
              ),
              if (product.discountPercentage > 0)
                Positioned(
                  bottom: 120.0,
                  right: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'وفّر ${(product.price - product.discountedPrice).toStringAsFixed(0)} ل.س',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Brand
                Container(
                  padding: .symmetric(horizontal: 10.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: AppRadius.extra2Large,
                  ),
                  child: Text(
                    product.category.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: .bold),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .w800),
                  textAlign: TextAlign.right,
                ),
                
                // Rating
                const SizedBox(height: 16.0),
                Row(
                  spacing: 5.0,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.secondary, size: 22.0),
                    Text(
                      product.rate.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      ' (${product.ratingsCount} تقييم)',
                      style: const TextStyle(color: AppColors.neutral, fontSize: 14.0),
                    ),
                    Text(
                      '   .    N/A عملية بيع',
                      style: const TextStyle(color: AppColors.neutral, fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${formatter.format(product.discountedPrice)} ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: .w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: 'ل.س ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.neutral,
                        ),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: formatter.format(product.price),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.neutral,
                          decoration: .lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  spacing: 5.0,
                  children: [
                    CircleAvatar(backgroundColor: Colors.green, radius: 4.0),
                    Text(
                      isOutOfStock ? 'نفذت الكمية' : 'متوفر في المخزون',
                      style: TextStyle(color: isOutOfStock ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Units
                Text('الوحدة', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: .bold)),
                const SizedBox(height: 12),
                _buildOptionsRow(
                  context,
                  options: product.units.map((u) => _SelectionItem(id: u.id, label: u.title)).toList(),
                  selectedId: state.selectedUnitId,
                  onSelected: (id) => context.read<ProductDetailsBloc>().add(SelectUnitEvent(id)),
                ),
                
                const SizedBox(height: 24),
                
                // Variants
                for (var option in product.variantOptions) ...[
                  Text(option.name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: .bold)),
                  const SizedBox(height: 12),
                  _buildOptionsRow(
                    context,
                    options: option.values.map((v) => _SelectionItem(id: v.valueId, label: v.name)).toList(),
                    selectedId: state.selectedOptions[option.attributeId] ?? 0,
                    onSelected: (valId) => context.read<ProductDetailsBloc>().add(SelectVariantOptionEvent(attributeId: option.attributeId, valueId: valId)),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Quantity Selector
                Container(
                  height: 72.0,
                  width: double.infinity,
                  padding: .symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: AppRadius.overMedium,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text('الكمية', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: .bold)),
                        const Spacer(),
                        _buildQuantitySelector(context, state.quantity),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30.0),
                // Description
                Text('الوصف', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: .bold, color: AppColors.primary)),
                const SizedBox(height: 12.0),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  /*textAlign: TextAlign.right,*/
                ),
                
                const SizedBox(height: 48),
                
                // Related
                Text('قد يعجبك أيضاً', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: .bold, color: AppColors.primary)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    //reverse: true, // RTL feel
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.relatedProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => SizedBox(
                      width: 180,
                      child: ProductCard(product: data.relatedProducts[index]),
                    ),
                  ),
                ),
                const SizedBox(height: 75.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context, {required List<_SelectionItem> options, required int selectedId, required Function(int) onSelected}) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      direction: Axis.horizontal,
      alignment: WrapAlignment.end,
      children: options.map((opt) {
        final isSelected = opt.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(opt.id),
          child: AnimatedContainer(
            constraints: const BoxConstraints(minHeight: 40.0),
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.neutral200,
              borderRadius: AppRadius.extraLarge,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.fillColor,
                width: 1.5,
              ),
              //boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
            ),
            child: Text(
              opt.label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isSelected ? AppColors.primary : null,
                fontWeight: .bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, int quantity) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.read<ProductDetailsBloc>().add(const UpdateQuantityEvent(-1)),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20.0,
            child: Icon(Icons.remove, size: 15.0, color: AppColors.primary),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 40),
          alignment: Alignment.center,
          child: Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: .bold),
          ),
        ),
        InkWell(
          onTap: () => context.read<ProductDetailsBloc>().add(const UpdateQuantityEvent(1)),
          child: CircleAvatar(
            backgroundColor: AppColors.secondary,
            radius: 20.0,
            child: Icon(Icons.add, size: 15.0, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}

class _SelectionItem {
  final int id;
  final String label;
  const _SelectionItem({required this.id, required this.label});
}
