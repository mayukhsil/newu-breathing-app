import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

/// Base class for all events handled by the [SettingsBloc].
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched to load the user's saved [BreathingPreferences] from Hive.
class LoadSettings extends SettingsEvent {}

/// Event dispatched to save and emit new [BreathingPreferences].
class UpdateSettings extends SettingsEvent {
  final BreathingPreferences preferences;

  const UpdateSettings(this.preferences);

  @override
  List<Object> get props => [preferences];
}
