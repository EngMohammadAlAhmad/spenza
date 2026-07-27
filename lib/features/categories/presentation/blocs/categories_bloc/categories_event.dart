part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoriesEvent {
  final bool isRefresh;

  const GetCategoriesEvent({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}
