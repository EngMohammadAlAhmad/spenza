import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/core/shared/models/product_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<void> saveFavorites(List<ProductModel> products);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'FAVORITE_PRODUCTS';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getFavorites() async {
    final jsonString = sharedPreferences.getString(_favoritesKey);
    if (jsonString != null) {
      final List decodeData = json.decode(jsonString);
      return decodeData.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveFavorites(List<ProductModel> products) async {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(_favoritesKey, jsonString);
  }
}
