part of 'brands_bloc.dart';

sealed class BrandsEvent extends Equatable {
  const BrandsEvent();

  @override
  List<Object> get props => [];
}

class GetBrandsEvent extends BrandsEvent {
  final bool isRefresh;

  const GetBrandsEvent({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}
