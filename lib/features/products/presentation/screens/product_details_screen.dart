import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/themes/app_colors.dart';
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
          body: SafeArea(
            bottom: false,
            child: data != null
                ? _buildContent(context, state, data)
                : state.dataState.isError
                    ? Center(child: Text(state.dataState.errorMessage))
                    : _buildLoadingGrid(),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ProductDetailsState state, ProductDetailsEntity data) {
    final product = data.product;

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
              ProductImageGallery(images: product.gallery.isNotEmpty ? product.gallery : (product.mainImage != null ? [product.mainImage!] : [])),
              if (product.discountPercentage > 0)
                Positioned(
                  bottom: 40,
                  right: 32,
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
                Text(
                  product.brand.name,
                  style: const TextStyle(color: AppColors.neutral, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, height: 1.3),
                  textAlign: TextAlign.right,
                ),
                
                // Rating
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ' (${product.ratingsCount} تقييم)',
                      style: const TextStyle(color: AppColors.neutral, fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, color: AppColors.secondary, size: 22),
                    Text(
                      product.rate.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOutOfStock ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isOutOfStock ? 'نفذت الكمية' : 'متوفر في المخزون',
                        style: TextStyle(color: isOutOfStock ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 48, thickness: 1, color: AppColors.fillColor),
                
                // Units
                const Text('الوحدة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                const SizedBox(height: 12),
                _buildOptionsRow(
                  options: product.units.map((u) => _SelectionItem(id: u.id, label: u.title)).toList(),
                  selectedId: state.selectedUnitId,
                  onSelected: (id) => context.read<ProductDetailsBloc>().add(SelectUnitEvent(id)),
                ),
                
                const SizedBox(height: 24),
                
                // Variants
                for (var option in product.variantOptions) ...[
                  Text(option.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                  const SizedBox(height: 12),
                  _buildOptionsRow(
                    options: option.values.map((v) => _SelectionItem(id: v.valueId, label: v.name)).toList(),
                    selectedId: state.selectedOptions[option.attributeId] ?? 0,
                    onSelected: (valId) => context.read<ProductDetailsBloc>().add(SelectVariantOptionEvent(attributeId: option.attributeId, valueId: valId)),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Quantity Selector
                const Text('الكمية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                const SizedBox(height: 12),
                _buildQuantitySelector(context, state.quantity),
                
                const SizedBox(height: 40),
                
                // Description
                const Text('الوصف', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.primary)),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: const TextStyle(height: 1.6, color: AppColors.neutral900, fontSize: 15),
                  textAlign: TextAlign.right,
                ),
                
                const SizedBox(height: 48),
                
                // Related
                const Text('قد يعجبك أيضاً', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.primary)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    //reverse: true, // RTL feel
                    itemCount: data.relatedProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => SizedBox(
                      width: 180,
                      child: ProductCard(product: data.relatedProducts[index]),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsRow({required List<_SelectionItem> options, required int selectedId, required Function(int) onSelected}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      direction: Axis.horizontal,
      alignment: WrapAlignment.end,
      children: options.map((opt) {
        final isSelected = opt.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(opt.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.fillColor,
                width: 1.5,
              ),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
            ),
            child: Text(
              opt.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.neutral,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, int quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fillColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => context.read<ProductDetailsBloc>().add(const UpdateQuantityEvent(1)),
            icon: const Icon(Icons.add_circle_rounded, color: AppColors.secondary, size: 36),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(
            onPressed: () => context.read<ProductDetailsBloc>().add(const UpdateQuantityEvent(-1)),
            icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.neutral, size: 36),
          ),
        ],
      ),
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
