import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

/// Represents the current snapshot of the user's settings.
///
/// Emitted by the [SettingsBloc] whenever preferences are loaded or updated.
class SettingsState extends Equatable {
  /// The current user preferences for the breathing session.
  final BreathingPreferences preferences;

  /// Whether the [SettingsBloc] is currently loading data from Hive.
  final bool isLoading;

  const SettingsState({required this.preferences, this.isLoading = false});

  factory SettingsState.initial() {
    return SettingsState(preferences: BreathingPreferences(), isLoading: true);
  }

  SettingsState copyWith({BreathingPreferences? preferences, bool? isLoading}) {
    return SettingsState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
    preferences.simpleDurationSeconds,
    preferences.rounds,
    preferences.soundEnabled,
    preferences.advancedTimingEnabled,
    preferences.breatheInSeconds,
    preferences.holdInSeconds,
    preferences.breatheOutSeconds,
    preferences.holdOutSeconds,
    isLoading,
  ];
}
