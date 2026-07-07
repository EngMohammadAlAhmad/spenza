import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class BaseParameters extends Equatable {
  const BaseParameters();

  Map<String, dynamic> toJson();

  Future<FormData> formDate() {
    throw UnimplementedError();
  }
}
