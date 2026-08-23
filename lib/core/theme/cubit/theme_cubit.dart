// lib/core/theme/cubit/theme_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_loadInitial(_prefs));

  final SharedPreferences _prefs;

  static const _prefsKey = 'theme_mode';

  static ThemeMode _loadInitial(SharedPreferences prefs) {
    switch (prefs.getString(_prefsKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    await _prefs.setString(_prefsKey, mode.name);
  }
}
