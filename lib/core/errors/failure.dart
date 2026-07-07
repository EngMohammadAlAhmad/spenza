class Failure {
  final String errMessage;
  const Failure({required this.errMessage});
}

const Failure defaultFailure = Failure(errMessage: 'init Failure');

//! un known Failure
class UnknownFailure extends Failure {
  UnknownFailure() : super(errMessage: 'Unknown Failure');
}
