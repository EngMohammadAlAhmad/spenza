part of 'points_market_bloc.dart';

abstract class PointsMarketEvent extends Equatable {
  const PointsMarketEvent();

  @override
  List<Object?> get props => [];
}

class GetMyPointsEvent extends PointsMarketEvent {
  const GetMyPointsEvent();
}
