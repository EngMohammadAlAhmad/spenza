import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/addresses/data/models/address_model.dart';
import 'package:spenza/features/addresses/data/models/governorate_model.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';

abstract class AddressesDatasource {
  Future<List<AddressModel>> getAddresses();
  Future<AddAddressResult> addAddress(AddAddressParams params);
  Future<List<GovernorateModel>> getLocations();
}

class AddressesDatasourceImpl implements AddressesDatasource {
  final ApiConsumer api;

  AddressesDatasourceImpl({required this.api});

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await api.get(EndPoints.addresses);

    List addressesJson = [];
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data != null) {
        if (data is Map<String, dynamic> && data['addresses'] is List) {
          addressesJson = data['addresses'] as List;
        } else if (data is List) {
          addressesJson = data;
        }
      } else if (response['addresses'] is List) {
        addressesJson = response['addresses'] as List;
      }
    } else if (response is List) {
      addressesJson = response;
    }

    return addressesJson
        .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddAddressResult> addAddress(AddAddressParams params) async {
    final response = await api.post(EndPoints.addresses, data: params.toJson());

    String message = 'تم حفظ العنوان بنجاح';
    Map<String, dynamic> addressJson = {};

    if (response is Map<String, dynamic>) {
      if (response['message'] != null && (response['message'] as String).isNotEmpty) {
        message = response['message'] as String;
      }
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        addressJson = data;
      } else {
        addressJson = response;
      }
    }

    final address = AddressModel.fromJson(addressJson);
    return AddAddressResult(message: message, address: address);
  }

  @override
  Future<List<GovernorateModel>> getLocations() async {
    final response = await api.get(EndPoints.locations);

    List governoratesJson = [];
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic> && data['governorates'] is List) {
        governoratesJson = data['governorates'] as List;
      } else if (response['governorates'] is List) {
        governoratesJson = response['governorates'] as List;
      }
    }

    return governoratesJson
        .map((e) => GovernorateModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
