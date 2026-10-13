import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class GetFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final ProductEntity product;

  const ToggleFavoriteEvent(this.product);

  @override
  List<Object?> get props => [product];
}
