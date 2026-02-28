import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final BreathingPreferences preferences;

  const UpdateSettings(this.preferences);

  @override
  List<Object> get props => [preferences];
}
