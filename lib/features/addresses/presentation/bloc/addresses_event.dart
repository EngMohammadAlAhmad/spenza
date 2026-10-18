import 'package:equatable/equatable.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';

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

class GetLocationsEvent extends AddressesEvent {
  const GetLocationsEvent();
}
