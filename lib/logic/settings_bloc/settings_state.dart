import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

class SettingsState extends Equatable {
  final BreathingPreferences preferences;
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
