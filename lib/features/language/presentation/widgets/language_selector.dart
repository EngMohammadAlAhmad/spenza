import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/features/language/domain/entities/language_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spenza/core/databases/api/language_interpretation.dart';
import 'package:spenza/injection_locator.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, BaseState<LanguageEntity>>(
      builder: (context, state) {
        return Row(
          children: [
            Text('language'.tr()),
            const SizedBox(width: 16.0),
            DropdownButton<String>(
              value: context.locale.toString(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.read<LanguageBloc>().add(ChangeLanguageEvent(languageCode: newValue));
                  _changeLanguage(context, newValue);
                }
              },
              items: LanguageEntity.values.map((LanguageEntity language) {
                return DropdownMenuItem<String>(
                  value: language.code,
                  child: Text(language.name),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    final locale = _getLocaleFromCode(languageCode);
    context.setLocale(locale);

    // 🔑 CRITICAL: Sync the API interceptor with the new language
    final languageInterceptor = sl<LanguageInterceptor>();
    languageInterceptor.setLanguage(languageCode);
  }

  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case 'ar':
        return const Locale('ar');
      default:
        return const Locale('en');
    }
  }
}