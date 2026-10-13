import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/utils/base_state.dart';
import '../../../domain/usecases/get_favorites_use_case.dart';
import '../../../domain/usecases/toggle_favorite_use_case.dart';
import 'favorites_event.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, BaseState<List<ProductEntity>>> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const BaseState<List<ProductEntity>>(data: [])) {
    on<GetFavoritesEvent>((event, emit) async {
      emit(state.loading());
      final result = await getFavoritesUseCase();
      result.fold(
        (failure) => emit(state.error(failure)),
        (products) => emit(state.success(products)),
      );
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      // Optimistic update
      final currentFavorites = List<ProductEntity>.from(state.data ?? []);
      final index = currentFavorites.indexWhere((p) => p.id == event.product.id);

      if (index != -1) {
        currentFavorites.removeAt(index);
      } else {
        currentFavorites.add(event.product);
      }
      emit(state.success(currentFavorites));

      // Persist change
      final result = await toggleFavoriteUseCase(event.product);
      result.fold(
        (failure) {
          // Revert if failed (optional, but good for robust Clean Arch)
          // For now, we assume local storage won't fail often.
          add(GetFavoritesEvent());
        },
        (_) => null,
      );
    });
  }
}
