import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/utils/strings.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';

class ThemeLocalDatasource {
  final CacheHelper cacheHelper;

  ThemeLocalDatasource({required this.cacheHelper});

  Future saveTheme({required ThemeEntity theme}) async {
    var themeValue = theme.themeType == ThemeType.dark ? 'dark' : 'light';
    await cacheHelper.saveData(key: Strings.THEME_KEY, value: themeValue);
  }

  Future<ThemeEntity> getTheme() async {
    var themeValue = await cacheHelper.getData(key: Strings.THEME_KEY);
    if(themeValue == 'dark') {
      return ThemeEntity(themeType: ThemeType.dark);
    } else {
      return ThemeEntity(themeType: ThemeType.light);
    }
  }

}