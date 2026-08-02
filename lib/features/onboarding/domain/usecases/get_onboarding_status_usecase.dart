import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  final OnboardingRepository repository;

  GetOnboardingStatusUseCase({required this.repository});

  Future<bool> call() async {
    return await repository.getOnboardingStatus();
  }
}
