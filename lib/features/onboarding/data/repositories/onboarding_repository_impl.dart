import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> getOnboardingStatus() async {
    return await localDataSource.getOnboardingStatus();
  }

  @override
  Future<void> setOnboardingStatus(bool wasSeen) async {
    await localDataSource.setOnboardingStatus(wasSeen);
  }
}
