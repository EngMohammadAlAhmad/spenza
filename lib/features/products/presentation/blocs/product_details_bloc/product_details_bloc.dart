import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/domain/usecases/get_product_details_use_case.dart';

part 'product_details_event.dart';

class ProductDetailsState extends Equatable {
  final BaseState<ProductDetailsEntity> dataState;
  final int selectedUnitId;
  final Map<int, int> selectedOptions; // {attributeId: valueId}
  final int quantity;

  const ProductDetailsState({
    required this.dataState,
    this.selectedUnitId = 0,
    this.selectedOptions = const {},
    this.quantity = 1,
  });

  ProductDetailsState copyWith({
    BaseState<ProductDetailsEntity>? dataState,
    int? selectedUnitId,
    Map<int, int>? selectedOptions,
    int? quantity,
  }) {
    return ProductDetailsState(
      dataState: dataState ?? this.dataState,
      selectedUnitId: selectedUnitId ?? this.selectedUnitId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [dataState, selectedUnitId, selectedOptions, quantity];
}

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsBloc({required this.getProductDetailsUseCase})
      : super(const ProductDetailsState(dataState: BaseState())) {
    on<GetProductDetailsEvent>(_onGetProductDetails);
    on<SelectUnitEvent>(_onSelectUnit);
    on<SelectVariantOptionEvent>(_onSelectVariantOption);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  Future<void> _onGetProductDetails(
    GetProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(state.copyWith(dataState: state.dataState.loading()));

    final result = await getProductDetailsUseCase.call(productId: event.productId);

    result.fold(
      (failure) => emit(state.copyWith(dataState: state.dataState.error(failure))),
      (data) {
        final Map<int, int> initialOptions = {};
        for (var option in data.product.variantOptions) {
          if (option.values.isNotEmpty) {
            initialOptions[option.attributeId] = option.values.first.valueId;
          }
        }

        emit(state.copyWith(
          dataState: state.dataState.success(data),
          selectedUnitId: data.product.defaultUnitId,
          selectedOptions: initialOptions,
          quantity: 1,
        ));
      },
    );
  }

  void _onSelectUnit(SelectUnitEvent event, Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedUnitId: event.unitId));
  }

  void _onSelectVariantOption(SelectVariantOptionEvent event, Emitter<ProductDetailsState> emit) {
    final newOptions = Map<int, int>.from(state.selectedOptions);
    newOptions[event.attributeId] = event.valueId;
    emit(state.copyWith(selectedOptions: newOptions, quantity: 1));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<ProductDetailsState> emit) {
    final newQty = state.quantity + event.delta;
    if (newQty >= 1) {
      emit(state.copyWith(quantity: newQty));
    }
  }
}
