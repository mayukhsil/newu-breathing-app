import 'package:equatable/equatable.dart';

enum BreathingPhase {
  prepare,
  breatheIn,
  holdIn,
  breatheOut,
  holdOut,
  completed,
}

class BreathingState extends Equatable {
  final BreathingPhase phase;
  final int currentCycle;
  final int totalCycles;
  final int secondsRemaining;
  final bool isPaused;
  final int totalAppTicks; // For progress bar across session
  final int maxAppTicks; // Max duration of the session

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
