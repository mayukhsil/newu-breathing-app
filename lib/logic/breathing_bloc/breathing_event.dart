import 'package:equatable/equatable.dart';
import '../../models/breathing_preferences.dart';

/// Base class for all events handled by the [BreathingBloc].
abstract class BreathingEvent extends Equatable {
  const BreathingEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched to begin a new breathing session with specific [BreathingPreferences].
class StartSession extends BreathingEvent {
  final BreathingPreferences preferences;

  const StartSession(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Event dispatched to pause the current breathing session.
class PauseSession extends BreathingEvent {}

/// Event dispatched to resume a paused breathing session.
class ResumeSession extends BreathingEvent {}

/// Event dispatched to prematurely terminate or stop the breathing session.
class StopSession extends BreathingEvent {}

/// Internal event fired every second by the bloc's timer to advance the session logic.
class BreathingTick extends BreathingEvent {}
