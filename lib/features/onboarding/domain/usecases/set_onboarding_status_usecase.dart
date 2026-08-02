import '../repositories/onboarding_repository.dart';

class SetOnboardingStatusUseCase {
  final OnboardingRepository repository;

  SetOnboardingStatusUseCase({required this.repository});

  Future<void> call(bool wasSeen) async {
    return await repository.setOnboardingStatus(wasSeen);
  }
}
