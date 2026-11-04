import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';

class AddressesState extends Equatable {
  final List<AddressEntity> addresses;
  final RequestStatus getAddressesStatus;
  final Failure getAddressesFailure;

  final RequestStatus addAddressStatus;
  final Failure addAddressFailure;
  final String? addAddressSuccessMessage;

  final RequestStatus updateAddressStatus;
  final Failure updateAddressFailure;
  final String? updateAddressSuccessMessage;

  final RequestStatus deleteAddressStatus;
  final Failure deleteAddressFailure;
  final String? deleteAddressSuccessMessage;

  final List<GovernorateEntity> governorates;
  final RequestStatus locationsStatus;
  final Failure locationsFailure;

  const AddressesState({
    this.addresses = const [],
    this.getAddressesStatus = RequestStatus.init,
    this.getAddressesFailure = defaultFailure,
    this.addAddressStatus = RequestStatus.init,
    this.addAddressFailure = defaultFailure,
    this.addAddressSuccessMessage,
    this.updateAddressStatus = RequestStatus.init,
    this.updateAddressFailure = defaultFailure,
    this.updateAddressSuccessMessage,
    this.deleteAddressStatus = RequestStatus.init,
    this.deleteAddressFailure = defaultFailure,
    this.deleteAddressSuccessMessage,
    this.governorates = const [],
    this.locationsStatus = RequestStatus.init,
    this.locationsFailure = defaultFailure,
  });

  AddressesState copyWith({
    List<AddressEntity>? addresses,
    RequestStatus? getAddressesStatus,
    Failure? getAddressesFailure,
    RequestStatus? addAddressStatus,
    Failure? addAddressFailure,
    String? addAddressSuccessMessage,
    RequestStatus? updateAddressStatus,
    Failure? updateAddressFailure,
    String? updateAddressSuccessMessage,
    RequestStatus? deleteAddressStatus,
    Failure? deleteAddressFailure,
    String? deleteAddressSuccessMessage,
    List<GovernorateEntity>? governorates,
    RequestStatus? locationsStatus,
    Failure? locationsFailure,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      getAddressesStatus: getAddressesStatus ?? this.getAddressesStatus,
      getAddressesFailure: getAddressesFailure ?? this.getAddressesFailure,
      addAddressStatus: addAddressStatus ?? this.addAddressStatus,
      addAddressFailure: addAddressFailure ?? this.addAddressFailure,
      addAddressSuccessMessage: addAddressSuccessMessage ?? this.addAddressSuccessMessage,
      updateAddressStatus: updateAddressStatus ?? this.updateAddressStatus,
      updateAddressFailure: updateAddressFailure ?? this.updateAddressFailure,
      updateAddressSuccessMessage: updateAddressSuccessMessage ?? this.updateAddressSuccessMessage,
      deleteAddressStatus: deleteAddressStatus ?? this.deleteAddressStatus,
      deleteAddressFailure: deleteAddressFailure ?? this.deleteAddressFailure,
      deleteAddressSuccessMessage: deleteAddressSuccessMessage ?? this.deleteAddressSuccessMessage,
      governorates: governorates ?? this.governorates,
      locationsStatus: locationsStatus ?? this.locationsStatus,
      locationsFailure: locationsFailure ?? this.locationsFailure,
    );
  }

  @override
  List<Object?> get props => [
        addresses,
        getAddressesStatus,
        getAddressesFailure,
        addAddressStatus,
        addAddressFailure,
        addAddressSuccessMessage,
        updateAddressStatus,
        updateAddressFailure,
        updateAddressSuccessMessage,
        deleteAddressStatus,
        deleteAddressFailure,
        deleteAddressSuccessMessage,
        governorates,
        locationsStatus,
        locationsFailure,
      ];
}
