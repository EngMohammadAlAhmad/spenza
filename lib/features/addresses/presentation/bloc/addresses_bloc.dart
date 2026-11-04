import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/delete_address_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/get_addresses_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/get_locations_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final GetLocationsUseCase getLocationsUseCase;

  AddressesBloc({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.getLocationsUseCase,
  }) : super(const AddressesState()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
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

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(state.copyWith(
      updateAddressStatus: RequestStatus.loading,
      updateAddressSuccessMessage: null,
    ));

    final result = await updateAddressUseCase(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        updateAddressStatus: RequestStatus.error,
        updateAddressFailure: failure,
      )),
      (message) {
        emit(state.copyWith(
          updateAddressStatus: RequestStatus.success,
          updateAddressSuccessMessage: message,
        ));
        add(const GetAddressesEvent());
      },
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(state.copyWith(
      deleteAddressStatus: RequestStatus.loading,
      deleteAddressSuccessMessage: null,
    ));

    final result = await deleteAddressUseCase(event.addressId);

    result.fold(
      (failure) => emit(state.copyWith(
        deleteAddressStatus: RequestStatus.error,
        deleteAddressFailure: failure,
      )),
      (message) {
        emit(state.copyWith(
          deleteAddressStatus: RequestStatus.success,
          deleteAddressSuccessMessage: message,
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
