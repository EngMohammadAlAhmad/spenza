import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';
import '../../domain/usecases/set_onboarding_status_usecase.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingStatusUseCase getOnboardingStatusUseCase;
  final SetOnboardingStatusUseCase setOnboardingStatusUseCase;

  OnboardingBloc({
    required this.getOnboardingStatusUseCase,
    required this.setOnboardingStatusUseCase,
  }) : super(OnboardingInitial()) {
    on<CheckOnboardingStatusEvent>(_onCheckStatus);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  Future<void> _onCheckStatus(
      CheckOnboardingStatusEvent event, Emitter<OnboardingState> emit) async {
    final wasSeen = await getOnboardingStatusUseCase.call();
    if (wasSeen) {
      emit(OnboardingCompleted());
    } else {
      emit(OnboardingRequired());
    }
  }

  Future<void> _onCompleteOnboarding(
      CompleteOnboardingEvent event, Emitter<OnboardingState> emit) async {
    await setOnboardingStatusUseCase.call(true);
    emit(OnboardingCompleted());
  }
}
