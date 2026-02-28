import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/breathing_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// A state management component that reads and writes [BreathingPreferences]
/// to the local [Hive] key-value database.
///
/// The [SettingsBloc] listens for [LoadSettings] to initialize the state
/// and [UpdateSettings] to persistently save user modifications.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _boxName = 'breathing_preferences_box';
  static const String _preferencesKey = 'preferences';

  SettingsBloc() : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  /// Handles the [LoadSettings] event by opening the Hive box, retrieving
  /// saved data, and emitting it. If no data exists, creates a default model.
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

  /// Handles the [UpdateSettings] event by writing the new preferences to
  /// Hive and emitting the updated state.
  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final box = Hive.box<BreathingPreferences>(_boxName);
    await box.put(_preferencesKey, event.preferences);
    emit(state.copyWith(preferences: event.preferences));
  }
}
