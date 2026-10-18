import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/get_addresses_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/get_locations_use_case.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final GetLocationsUseCase getLocationsUseCase;

  AddressesBloc({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.getLocationsUseCase,
  }) : super(const AddressesState()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<GetLocationsEvent>(_onGetLocations);
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(state.copyWith(getAddressesStatus: RequestStatus.loading));

    final result = await getAddressesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        getAddressesStatus: RequestStatus.error,
        getAddressesFailure: failure,
      )),
      (addresses) => emit(state.copyWith(
        getAddressesStatus: RequestStatus.success,
        addresses: addresses,
      )),
    );
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(state.copyWith(
      addAddressStatus: RequestStatus.loading,
      addAddressSuccessMessage: null,
    ));

    final result = await addAddressUseCase(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        addAddressStatus: RequestStatus.error,
        addAddressFailure: failure,
      )),
      (successResult) {
        emit(state.copyWith(
          addAddressStatus: RequestStatus.success,
          addAddressSuccessMessage: successResult.message,
        ));
        add(const GetAddressesEvent());
      },
    );
  }

  Future<void> _onGetLocations(
    GetLocationsEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(state.copyWith(locationsStatus: RequestStatus.loading));

    final result = await getLocationsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        locationsStatus: RequestStatus.error,
        locationsFailure: failure,
      )),
      (governorates) => emit(state.copyWith(
        locationsStatus: RequestStatus.success,
        governorates: governorates,
      )),
    );
  }
}
