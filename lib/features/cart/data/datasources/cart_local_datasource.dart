import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/features/cart/data/models/cart_item_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<List<CartItemModel>> addToCart(CartItemEntity item);
  Future<List<CartItemModel>> updateQuantity(int productId, int unitId, int quantity);
  Future<List<CartItemModel>> removeFromCart(int productId, int unitId);
  Future<List<CartItemModel>> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cartKey = 'cart_items_key';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCart() async {
    final jsonString = sharedPreferences.getString(_cartKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_cartKey, jsonString);
  }

  @override
  Future<List<CartItemModel>> addToCart(CartItemEntity item) async {
    final currentList = await getCart();
    final existingIndex = currentList.indexWhere(
      (e) => e.productId == item.productId && e.unitId == item.unitId && e.variantId == item.variantId,
    );

    if (existingIndex >= 0) {
      final existing = currentList[existingIndex];
      currentList[existingIndex] = CartItemModel.fromEntity(
        existing.copyWith(quantity: existing.quantity + item.quantity),
      );
    } else {
      currentList.add(CartItemModel.fromEntity(item));
    }

    await _saveCart(currentList);
    return currentList;
  }

  @override
  Future<List<CartItemModel>> updateQuantity(int productId, int unitId, int quantity) async {
    final currentList = await getCart();
    if (quantity <= 0) {
      return removeFromCart(productId, unitId);
    }

    final index = currentList.indexWhere((e) => e.productId == productId && e.unitId == unitId);
    if (index >= 0) {
      currentList[index] = CartItemModel.fromEntity(
        currentList[index].copyWith(quantity: quantity),
      );
      await _saveCart(currentList);
    }
    return currentList;
  }

  @override
  Future<List<CartItemModel>> removeFromCart(int productId, int unitId) async {
    final currentList = await getCart();
    currentList.removeWhere((e) => e.productId == productId && e.unitId == unitId);
    await _saveCart(currentList);
    return currentList;
  }

  @override
  Future<List<CartItemModel>> clearCart() async {
    await sharedPreferences.remove(_cartKey);
    return [];
  }
}
