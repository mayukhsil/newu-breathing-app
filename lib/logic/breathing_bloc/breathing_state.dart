import 'package:equatable/equatable.dart';

/// Represents the continuous cycle of phases within a single breathing round.
enum BreathingPhase {
  prepare,
  breatheIn,
  holdIn,
  breatheOut,
  holdOut,
  completed,
}

/// Represents the current snapshot of the breathing session.
///
/// Contains precisely calculated data about the phase, remaining time,
/// and total progression to be consumed by the UI.
class BreathingState extends Equatable {
  /// The specific structural phase of the breath (e.g. inhale, hold, exhale).
  final BreathingPhase phase;

  /// The current round out of [totalCycles] being executed.
  final int currentCycle;

  /// The total number of rounds prescribed by the user.
  final int totalCycles;

  /// Seconds remaining before the current phase transitions to the next.
  final int secondsRemaining;

  /// Whether the session is currently paused.
  final bool isPaused;

  /// A running counter of seconds elapsed across the entire session, used for the progress bar.
  final int totalAppTicks;

  /// The maximum expected seconds (ticks) for the totality of the session.
  final int maxAppTicks;

  const BreathingState({
    required this.phase,
    required this.currentCycle,
    required this.totalCycles,
    required this.secondsRemaining,
    required this.isPaused,
    required this.totalAppTicks,
    required this.maxAppTicks,
  });

  factory BreathingState.initial() {
    return const BreathingState(
      phase: BreathingPhase.prepare,
      currentCycle: 1,
      totalCycles: 1,
      secondsRemaining: 0,
      isPaused: false,
      totalAppTicks: 0,
      maxAppTicks: 1,
    );
  }

  BreathingState copyWith({
    BreathingPhase? phase,
    int? currentCycle,
    int? totalCycles,
    int? secondsRemaining,
    bool? isPaused,
    int? totalAppTicks,
    int? maxAppTicks,
  }) {
    return BreathingState(
      phase: phase ?? this.phase,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isPaused: isPaused ?? this.isPaused,
      totalAppTicks: totalAppTicks ?? this.totalAppTicks,
      maxAppTicks: maxAppTicks ?? this.maxAppTicks,
    );
  }

  @override
  List<Object> get props => [
    phase,
    currentCycle,
    totalCycles,
    secondsRemaining,
    isPaused,
    totalAppTicks,
    maxAppTicks,
  ];
}
