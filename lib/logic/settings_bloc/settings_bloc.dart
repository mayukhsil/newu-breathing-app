import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/models/breathing_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _boxName = 'breathing_preferences_box';
  static const String _preferencesKey = 'preferences';

  SettingsBloc() : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final box = await Hive.openBox<BreathingPreferences>(_boxName);
    BreathingPreferences? prefs = box.get(_preferencesKey);

    if (prefs == null) {
      prefs = BreathingPreferences();
      await box.put(_preferencesKey, prefs);
    }

    emit(state.copyWith(preferences: prefs, isLoading: false));
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final box = Hive.box<BreathingPreferences>(_boxName);
    await box.put(_preferencesKey, event.preferences);
    emit(state.copyWith(preferences: event.preferences));
  }
}
