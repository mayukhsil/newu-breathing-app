import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

abstract class BreathingEvent extends Equatable {
  const BreathingEvent();

  @override
  List<Object?> get props => [];
}

class StartSession extends BreathingEvent {
  final BreathingPreferences preferences;

  const StartSession(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class PauseSession extends BreathingEvent {}

class ResumeSession extends BreathingEvent {}

class StopSession extends BreathingEvent {}

class BreathingTick extends BreathingEvent {}
