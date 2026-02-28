import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../logic/settings_bloc/settings_bloc.dart';
import '../../logic/breathing_bloc/breathing_bloc.dart';
import '../../logic/breathing_bloc/breathing_event.dart';
import '../../logic/breathing_bloc/breathing_state.dart';
import '../../main.dart' as import_main;
import '../widgets/background_wrapper.dart';
import '../widgets/smooth_progress.dart';

/// The active breathing session screen.
///
/// This screen displays the expanding and contracting orb mapped exactly
/// to the state emitted by the [BreathingBloc]. It handles implicit animations
/// and audio playback.
class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

/// The state for [BreathingPage], managing the local [BreathingBloc] instance
/// and the [AudioPlayer] for transition chimes.
class _BreathingPageState extends State<BreathingPage>
    with TickerProviderStateMixin {
  late BreathingBloc _breathingBloc;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _breathingBloc = BreathingBloc();
    final prefs = context.read<SettingsBloc>().state.preferences;
    _breathingBloc.add(StartSession(prefs));
  }

  @override
  void dispose() {
    _breathingBloc.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Plays a subtle sound chime if enabled in settings.
  ///
  /// Fires specifically when there is exactly 1 second remaining before
  /// entering a new active breathing phase.
  void _playSoundIfNeeded(BreathingState state) async {
    if (context.read<SettingsBloc>().state.preferences.soundEnabled) {
      if (state.secondsRemaining == 1 &&
          state.phase != BreathingPhase.completed &&
          state.phase != BreathingPhase.prepare) {
        try {
          await _audioPlayer.play(AssetSource('audios/chime.mp3'));
        } catch (e) {
          debugPrint('Error playing sound: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxBubbleSize = kIsWeb ? 500.0 : size.width * 0.7;
    final minBubbleSize = kIsWeb ? 300.0 : size.width * 0.4;

    return BackgroundWrapper(
      child: BlocProvider.value(
        value: _breathingBloc,
        child: Scaffold(
          body: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: kIsWeb
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth,
                  child: BlocConsumer<BreathingBloc, BreathingState>(
                    listener: (context, state) {
                      if (state.phase == BreathingPhase.completed) {
                        // Navigate to completion screen
                        Navigator.pushReplacementNamed(context, '/completion');
                      } else {
                        _playSoundIfNeeded(state);
                      }
                    },
                    builder: (context, state) {
                      // Determine bubble size and animation duration based on phase
                      double targetSize = minBubbleSize;
                      int animDuration = state.secondsRemaining;

                      String phaseTitle = '';
                      String phaseSubtitle = '';

                      switch (state.phase) {
                        case BreathingPhase.prepare:
                          targetSize = minBubbleSize;
                          animDuration = 0; // static
                          phaseTitle = 'Get ready';
                          phaseSubtitle = 'Get going on your breathing session';
                          break;
                        case BreathingPhase.breatheIn:
                          targetSize = maxBubbleSize;
                          phaseTitle = 'Breathe in';
                          phaseSubtitle = 'nice and slow';
                          break;
                        case BreathingPhase.holdIn:
                          targetSize = maxBubbleSize;
                          animDuration = 0;
                          phaseTitle = 'Hold gently';
                          phaseSubtitle = 'keep it in';
                          break;
                        case BreathingPhase.breatheOut:
                          targetSize = minBubbleSize;
                          phaseTitle = 'Breathe out';
                          phaseSubtitle = 'nice and slow';
                          break;
                        case BreathingPhase.holdOut:
                          targetSize = minBubbleSize;
                          animDuration = 0;
                          phaseTitle = 'Hold softly';
                          phaseSubtitle = 'keep it out';
                          break;
                        case BreathingPhase.completed:
                          phaseTitle = 'Done!';
                          phaseSubtitle = 'Great job.';
                          break;
                      }

                      // Calculating displayed number inside bubble
                      String bubbleText = '';
                      if (state.phase != BreathingPhase.prepare &&
                          state.phase != BreathingPhase.completed) {
                        if (state.phase == BreathingPhase.holdIn ||
                            state.phase == BreathingPhase.holdOut) {
                          bubbleText =
                              ''; // Do not show anything in bubble when holding
                        } else if (state.phase == BreathingPhase.breatheIn) {
                          // Count up
                          int totalPhaseSec = _getPhaseDuration(state.phase);
                          int elapsed =
                              totalPhaseSec - state.secondsRemaining + 1;
                          bubbleText = '$elapsed';
                        } else if (state.phase == BreathingPhase.breatheOut) {
                          // Count down
                          bubbleText = '${state.secondsRemaining}';
                        }
                      } else if (state.phase == BreathingPhase.prepare) {
                        bubbleText = '${state.secondsRemaining}';
                      }

                      return Column(
                        children: [
                          SizedBox(height: 60),
                          // Top Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Exit?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.red),
                                        ),
                                        content: Text(
                                          'Are you sure you want to exit?',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        actionsPadding: EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/',
                                                (route) => false,
                                              );
                                            },
                                            child: Text(
                                              'Yes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    import_main.MyApp.of(context).toggleTheme();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black.withValues(alpha: 0.1)
                                          : Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: SvgPicture.asset(
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 'assets/icons/darkMode.svg'
                                          : 'assets/icons/lightMode.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text(
                            "You're a natural",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                          ),

                          // Bubble Area
                          Expanded(
                            child: Center(
                              child: AnimatedContainer(
                                duration: Duration(
                                  seconds: state.isPaused ? 0 : animDuration,
                                ),
                                curve: Curves.easeInOut,
                                width: targetSize,
                                height: targetSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const [
                                            Color(0x337B2D8E),
                                            Color(0x0D7B2D8E),
                                          ]
                                        : const [
                                            Color(0x66C97CF5),
                                            Color(0x1AC97CF5),
                                          ],
                                  ),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0x1F7B2D8E)
                                        : const Color(0x40C97CF5),
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 100),
                                  switchInCurve: Curves.easeIn,
                                  switchOutCurve: Curves.easeOut,
                                  child: Text(
                                    bubbleText,
                                    key: ValueKey<String>(bubbleText),
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontVariations: const <FontVariation>[
                                        FontVariation('wght', 700),
                                      ],
                                      color: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium?.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Bottom Info
                          Column(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Text(
                                  phaseTitle,
                                  key: ValueKey<String>(phaseTitle),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Text(
                                  phaseSubtitle,
                                  key: ValueKey<String>(phaseSubtitle),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Progress Bar
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 64.0,
                                ),
                                child: SmoothBreathingProgress(
                                  value: state.maxAppTicks > 0
                                      ? (state.totalAppTicks /
                                            state.maxAppTicks)
                                      : 0,
                                  isPaused: state.isPaused,
                                  backgroundColor: Colors.grey.withValues(
                                    alpha: 0.2,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Text(
                                  'Cycle ${state.currentCycle} of ${state.totalCycles}',
                                  key: ValueKey<String>(
                                    'Cycle ${state.currentCycle} of ${state.totalCycles}',
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontVariations: <FontVariation>[
                                      FontVariation('wght', 600),
                                    ],
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black87
                                        : Colors.white70,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Pause/Resume Button
                              GestureDetector(
                                onTap: () {
                                  if (state.isPaused) {
                                    _breathingBloc.add(ResumeSession());
                                  } else {
                                    _breathingBloc.add(PauseSession());
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xFFEFE6F0)
                                        : Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        state.isPaused
                                            ? 'assets/icons/play.svg'
                                            : 'assets/icons/pause.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).iconTheme.color ??
                                              Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      Text(
                                        state.isPaused ? 'Resume' : 'Pause',
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black87
                                              : Colors.white,
                                          fontVariations: <FontVariation>[
                                            FontVariation('wght', 600),
                                          ],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Retrieves the correct duration in seconds for a specific [BreathingPhase].
  ///
  /// Checks whether advanced timing is enabled to return distinct phase durations,
  /// otherwise returns the uniform simple duration.
  int _getPhaseDuration(BreathingPhase phase) {
    final prefs = context.read<SettingsBloc>().state.preferences;
    if (prefs.advancedTimingEnabled) {
      switch (phase) {
        case BreathingPhase.breatheIn:
          return prefs.breatheInSeconds;
        case BreathingPhase.holdIn:
          return prefs.holdInSeconds;
        case BreathingPhase.breatheOut:
          return prefs.breatheOutSeconds;
        case BreathingPhase.holdOut:
          return prefs.holdOutSeconds;
        default:
          return 0;
      }
    }
    return prefs.simpleDurationSeconds;
  }
}
