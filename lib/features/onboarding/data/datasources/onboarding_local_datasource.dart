import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> getOnboardingStatus();
  Future<void> setOnboardingStatus(bool wasSeen);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _onboardingKey = 'ONBOARDING_SEEN';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> getOnboardingStatus() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> setOnboardingStatus(bool wasSeen) async {
    await sharedPreferences.setBool(_onboardingKey, wasSeen);
  }
}
