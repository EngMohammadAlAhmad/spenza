import 'package:equatable/equatable.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/entities/update_address_params.dart';

abstract class AddressesEvent extends Equatable {
  const AddressesEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressesEvent extends AddressesEvent {
  const GetAddressesEvent();
}

class AddAddressEvent extends AddressesEvent {
  final AddAddressParams params;

  const AddAddressEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateAddressEvent extends AddressesEvent {
  final UpdateAddressParams params;

  const UpdateAddressEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteAddressEvent extends AddressesEvent {
  final int addressId;

  const DeleteAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class GetLocationsEvent extends AddressesEvent {
  const GetLocationsEvent();
}
