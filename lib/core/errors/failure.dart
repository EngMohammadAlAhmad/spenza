import 'package:easy_localization/easy_localization.dart';

class Failure {
  final String errMessage;
  const Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errMessage});
}

class OfflineFailure extends Failure {
  OfflineFailure() : super(errMessage: 'offline_failure'.tr());
}

const Failure defaultFailure = Failure(errMessage: 'init Failure');

//! un known Failure
class UnknownFailure extends Failure {
  UnknownFailure() : super(errMessage: 'Unknown Failure');
}
