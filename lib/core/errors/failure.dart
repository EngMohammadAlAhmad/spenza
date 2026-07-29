class Failure {
  final String errMessage;
  const Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errMessage});
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super(errMessage: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة وإعادة المحاولة.');
}

const Failure defaultFailure = Failure(errMessage: 'init Failure');

//! un known Failure
class UnknownFailure extends Failure {
  UnknownFailure() : super(errMessage: 'Unknown Failure');
}
