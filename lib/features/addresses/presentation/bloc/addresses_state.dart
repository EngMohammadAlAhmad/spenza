import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class AddressesState extends Equatable {
  final List<AddressEntity> addresses;
  final RequestStatus getAddressesStatus;
  final Failure getAddressesFailure;

  final RequestStatus addAddressStatus;
  final Failure addAddressFailure;
  final String? addAddressSuccessMessage;

  const AddressesState({
    this.addresses = const [],
    this.getAddressesStatus = RequestStatus.init,
    this.getAddressesFailure = defaultFailure,
    this.addAddressStatus = RequestStatus.init,
    this.addAddressFailure = defaultFailure,
    this.addAddressSuccessMessage,
  });

  AddressesState copyWith({
    List<AddressEntity>? addresses,
    RequestStatus? getAddressesStatus,
    Failure? getAddressesFailure,
    RequestStatus? addAddressStatus,
    Failure? addAddressFailure,
    String? addAddressSuccessMessage,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      getAddressesStatus: getAddressesStatus ?? this.getAddressesStatus,
      getAddressesFailure: getAddressesFailure ?? this.getAddressesFailure,
      addAddressStatus: addAddressStatus ?? this.addAddressStatus,
      addAddressFailure: addAddressFailure ?? this.addAddressFailure,
      addAddressSuccessMessage: addAddressSuccessMessage ?? this.addAddressSuccessMessage,
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
      ];
}
