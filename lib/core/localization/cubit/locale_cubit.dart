import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(_loadInitial(_prefs));

  final SharedPreferences _prefs;

  static const _prefsKey = 'app_locale';

  static Locale _loadInitial(SharedPreferences prefs) {
    final locale =
        prefs.getString(_prefsKey) == 'en'
            ? AppLocale.english
            : AppLocale.arabic;
    AppLocale.current = locale;
    return locale;
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == state) return;
    AppLocale.current = locale;
    emit(locale);
    await _prefs.setString(_prefsKey, locale.languageCode);
  }
}
