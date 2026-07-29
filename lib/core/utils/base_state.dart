import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';

class BaseState<T> extends Equatable {
  final RequestStatus requestStatus;
  final Failure failure;

  final T? data; // (For the success state)

  final bool? hasReachedMax;

  final String? message; // for adding , deleting , creating , benefit from the message returned bt the Backend

  final int currentPage;
  final String? sort; // for sorting filters

  const BaseState({
    this.requestStatus = RequestStatus.init,
    this.failure = defaultFailure,
    this.hasReachedMax = false,
    this.data,
    this.message,
    this.currentPage = 1,
    this.sort,
  });

  BaseState<T> copyWith({
    RequestStatus? requestStatus,
    bool? hasReachedMax,
    Failure? failure,
    T? data,
    String? message,
    int? currentPage,
    String? sort,
  }) => BaseState<T>(
    data: data ?? this.data,
    failure: failure ?? this.failure,
    requestStatus: requestStatus ?? this.requestStatus,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    message: message ?? this.message,
    currentPage: currentPage ?? this.currentPage,
    sort: sort ?? this.sort,
  );

  @override
  List<Object?> get props => [requestStatus, failure, data, hasReachedMax, message, currentPage, sort];

  BaseState<T> loading() {
    return copyWith(requestStatus: RequestStatus.loading);
  }

  BaseState<T> success(T newData, {String? message}) => copyWith(
    requestStatus: RequestStatus.success,
    data: newData,
    message: message,
  );

  BaseState<T> error(Failure newFailure) {
    return copyWith(requestStatus: RequestStatus.error, failure: newFailure);
  }

  BaseState<T> defaultError() {
    return copyWith(
      requestStatus: RequestStatus.error,
      failure: UnknownFailure(),
    );
  }

  BaseState<T> reset() => BaseState<T>();

  bool get isLoading => requestStatus == RequestStatus.loading;

  bool get isSuccess => requestStatus == RequestStatus.success;

  bool get isInit => requestStatus == RequestStatus.init;

  bool get isError => requestStatus == RequestStatus.error;

  String get errorMessage => failure.errMessage;

}
