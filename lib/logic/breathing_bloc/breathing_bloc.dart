import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/breathing_preferences.dart';
import 'breathing_event.dart';
import 'breathing_state.dart';

/// A finite state machine managing the logic and precise timing of a breathing session.
///
/// The [BreathingBloc] receives UI events, drives an internal timer to tick
/// every second, and emits new [BreathingState] snapshots containing the
/// updated phase, remaining duration, and total progress.
class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  Timer? _timer;
  late BreathingPreferences _preferences;

  BreathingBloc() : super(BreathingState.initial()) {
    on<StartSession>(_onStartSession);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<StopSession>(_onStopSession);
    on<BreathingTick>(_onTick);
  }

  /// Handles the [StartSession] event by parsing [BreathingPreferences],
  /// calculating the exact maximum duration of the session, and spinning
  /// up the periodic timer.
  void _onStartSession(StartSession event, Emitter<BreathingState> emit) {
    _preferences = event.preferences;

    // Calculate total ticks for progress bar
    int inSec = _preferences.advancedTimingEnabled
        ? _preferences.breatheInSeconds
        : _preferences.simpleDurationSeconds;
    int holdInSec = _preferences.advancedTimingEnabled
        ? _preferences.holdInSeconds
        : _preferences.simpleDurationSeconds;
    int outSec = _preferences.advancedTimingEnabled
        ? _preferences.breatheOutSeconds
        : _preferences.simpleDurationSeconds;
    int holdOutSec = _preferences.advancedTimingEnabled
        ? _preferences.holdOutSeconds
        : _preferences.simpleDurationSeconds;

    int oneCycleSec = inSec + holdInSec + outSec + holdOutSec;
    int totalAppTicks = oneCycleSec * _preferences.rounds;

    emit(
      BreathingState(
        phase: BreathingPhase.prepare,
        currentCycle: 1,
        totalCycles: _preferences.rounds,
        secondsRemaining: 3, // 3 seconds prepare
        isPaused: false,
        totalAppTicks: 0,
        maxAppTicks: totalAppTicks,
      ),
    );

    _startTimer();
  }

  void _onPauseSession(PauseSession event, Emitter<BreathingState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isPaused: true));
  }

  void _onResumeSession(ResumeSession event, Emitter<BreathingState> emit) {
    emit(state.copyWith(isPaused: false));
    _startTimer();
  }

  void _onStopSession(StopSession event, Emitter<BreathingState> emit) {
    _timer?.cancel();
    emit(BreathingState.initial().copyWith(phase: BreathingPhase.completed));
  }

  /// Fired every second by the internal timer.
  ///
  /// Decrements [secondsRemaining]. If zero is reached, it triggers a phase transition.
  void _onTick(BreathingTick event, Emitter<BreathingState> emit) {
    if (state.phase == BreathingPhase.completed || state.isPaused) return;

    if (state.secondsRemaining > 1) {
      int newTotalAppTicks = state.totalAppTicks;
      if (state.phase != BreathingPhase.prepare) {
        newTotalAppTicks++;
      }
      emit(
        state.copyWith(
          secondsRemaining: state.secondsRemaining - 1,
          totalAppTicks: newTotalAppTicks,
        ),
      );
    } else {
      _moveToNextPhase(emit);
    }
  }

  /// Core logic to advance the state machine to the correct next phase based on
  /// the current phase and user timing preferences.
  void _moveToNextPhase(Emitter<BreathingState> emit) {
    BreathingPhase nextPhase;
    int nextDuration;
    int cycle = state.currentCycle;

    int inSec = _preferences.advancedTimingEnabled
        ? _preferences.breatheInSeconds
        : _preferences.simpleDurationSeconds;
    int holdInSec = _preferences.advancedTimingEnabled
        ? _preferences.holdInSeconds
        : _preferences.simpleDurationSeconds;
    int outSec = _preferences.advancedTimingEnabled
        ? _preferences.breatheOutSeconds
        : _preferences.simpleDurationSeconds;
    int holdOutSec = _preferences.advancedTimingEnabled
        ? _preferences.holdOutSeconds
        : _preferences.simpleDurationSeconds;

    int newTotalTicks = state.phase != BreathingPhase.prepare
        ? state.totalAppTicks + 1
        : state.totalAppTicks;

    switch (state.phase) {
      case BreathingPhase.prepare:
        nextPhase = BreathingPhase.breatheIn;
        nextDuration = inSec;
        break;
      case BreathingPhase.breatheIn:
        nextPhase = BreathingPhase.holdIn;
        nextDuration = holdInSec;
        break;
      case BreathingPhase.holdIn:
        nextPhase = BreathingPhase.breatheOut;
        nextDuration = outSec;
        break;
      case BreathingPhase.breatheOut:
        nextPhase = BreathingPhase.holdOut;
        nextDuration = holdOutSec;
        break;
      case BreathingPhase.holdOut:
        if (cycle >= state.totalCycles) {
          nextPhase = BreathingPhase.completed;
          nextDuration = 0;
          _timer?.cancel();
        } else {
          nextPhase = BreathingPhase.breatheIn;
          nextDuration = inSec;
          cycle++;
        }
        break;
      case BreathingPhase.completed:
        return;
    }

    emit(
      state.copyWith(
        phase: nextPhase,
        secondsRemaining: nextDuration,
        currentCycle: cycle,
        totalAppTicks: newTotalTicks,
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(BreathingTick());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
