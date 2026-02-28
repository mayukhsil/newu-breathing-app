import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/breathing_preferences.dart';
import '../../logic/settings_bloc/settings_bloc.dart';
import '../../logic/settings_bloc/settings_event.dart';
import '../../logic/settings_bloc/settings_state.dart';
import '../../main.dart' as import_main;
import '../widgets/background_wrapper.dart';

/// The initial screen where users configure their breathing session parameters.
///
/// This screen listens to the [SettingsBloc] and allows users to update
/// preferences like phase duration, total cycles, and advanced asymmetrical timing.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final prefs = state.preferences;

        return BackgroundWrapper(
          child: Scaffold(
            body: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: kIsWeb
                        ? constraints.maxWidth / 2
                        : constraints.maxWidth,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 60),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
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
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Set your breathing pace',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Customise your breathing session. You can always change this later.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 32),

                              // Card with settings
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Simple Duration
                                    _buildSectionTitle(
                                      context,
                                      'Breath duration',
                                      'Seconds per phase',
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [3, 4, 5, 6].map((sec) {
                                        return _buildChoiceChip(
                                          context,
                                          label: '${sec}s',
                                          isSelected:
                                              prefs.simpleDurationSeconds ==
                                              sec,
                                          onTap: () {
                                            context.read<SettingsBloc>().add(
                                              UpdateSettings(
                                                prefs.copyWith(
                                                  simpleDurationSeconds: sec,
                                                  breatheInSeconds: sec,
                                                  holdInSeconds: sec,
                                                  breatheOutSeconds: sec,
                                                  holdOutSeconds: sec,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),

                                    const SizedBox(height: 32),

                                    // Rounds
                                    _buildSectionTitle(
                                      context,
                                      'Rounds',
                                      'Full box breathing cycles',
                                    ),
                                    const SizedBox(height: 16),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildChoiceChip(
                                            context,
                                            label: '2 quick',
                                            isSelected: prefs.rounds == 2,
                                            onTap: () => context
                                                .read<SettingsBloc>()
                                                .add(
                                                  UpdateSettings(
                                                    prefs.copyWith(rounds: 2),
                                                  ),
                                                ),
                                          ),
                                          _buildChoiceChip(
                                            context,
                                            label: '4 calm',
                                            isSelected: prefs.rounds == 4,
                                            onTap: () => context
                                                .read<SettingsBloc>()
                                                .add(
                                                  UpdateSettings(
                                                    prefs.copyWith(rounds: 4),
                                                  ),
                                                ),
                                          ),
                                          _buildChoiceChip(
                                            context,
                                            label: '6 deep',
                                            isSelected: prefs.rounds == 6,
                                            onTap: () => context
                                                .read<SettingsBloc>()
                                                .add(
                                                  UpdateSettings(
                                                    prefs.copyWith(rounds: 6),
                                                  ),
                                                ),
                                          ),
                                          _buildChoiceChip(
                                            context,
                                            label: '8 zen',
                                            isSelected: prefs.rounds == 8,
                                            onTap: () => context
                                                .read<SettingsBloc>()
                                                .add(
                                                  UpdateSettings(
                                                    prefs.copyWith(rounds: 8),
                                                  ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    Divider(color: Colors.grey.withAlpha(100)),
                                    const SizedBox(height: 16),

                                    // Advanced timing logic
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Advanced timing',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              'Set different durations for each phase',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        onExpansionChanged: (expanded) {
                                          var updatedPrefs = prefs.copyWith(
                                            advancedTimingEnabled: expanded,
                                          );

                                          // Reset advanced timings to 4s when closing panel
                                          if (!expanded) {
                                            updatedPrefs = updatedPrefs
                                                .copyWith(
                                                  simpleDurationSeconds: 4,
                                                  breatheInSeconds: 4,
                                                  holdInSeconds: 4,
                                                  breatheOutSeconds: 4,
                                                  holdOutSeconds: 4,
                                                );
                                          }

                                          context.read<SettingsBloc>().add(
                                            UpdateSettings(updatedPrefs),
                                          );
                                        },
                                        initiallyExpanded:
                                            prefs.advancedTimingEnabled,
                                        children: [
                                          const SizedBox(height: 16),
                                          _buildAdvancedSlider(
                                            context,
                                            'Breathe in',
                                            prefs.breatheInSeconds,
                                            (v) => _updateAdvanced(
                                              context,
                                              prefs,
                                              breatheIn: v,
                                            ),
                                          ),
                                          _buildAdvancedSlider(
                                            context,
                                            'Hold in',
                                            prefs.holdInSeconds,
                                            (v) => _updateAdvanced(
                                              context,
                                              prefs,
                                              holdIn: v,
                                            ),
                                          ),
                                          _buildAdvancedSlider(
                                            context,
                                            'Breathe out',
                                            prefs.breatheOutSeconds,
                                            (v) => _updateAdvanced(
                                              context,
                                              prefs,
                                              breatheOut: v,
                                            ),
                                          ),
                                          _buildAdvancedSlider(
                                            context,
                                            'Hold out',
                                            prefs.holdOutSeconds,
                                            (v) => _updateAdvanced(
                                              context,
                                              prefs,
                                              holdOut: v,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    Divider(color: Colors.grey.withAlpha(100)),
                                    const SizedBox(height: 16),

                                    // Sound Toggle
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sound',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              'Gentle chime between phases',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        Switch(
                                          value: prefs.soundEnabled,
                                          activeThumbColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          onChanged: (val) {
                                            context.read<SettingsBloc>().add(
                                              UpdateSettings(
                                                prefs.copyWith(
                                                  soundEnabled: val,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 56,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ).copyWith(bottom: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/breathing');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Start breathing',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontVariations: [
                                            FontVariation('wght', 700),
                                          ],
                                          color: Colors.white,
                                        ),
                                  ),
                                  SizedBox(width: 8),
                                  SvgPicture.asset(
                                    'assets/icons/air.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a standardized section title and subtitle for the settings UI.
  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  /// Dispatches an [UpdateSettings] event when an advanced timing slider changes.
  ///
  /// Automatically recalculates the [simpleDurationSeconds] if all phases
  /// are deliberately set to the exact same duration.
  void _updateAdvanced(
    BuildContext context,
    BreathingPreferences prefs, {
    int? breatheIn,
    int? holdIn,
    int? breatheOut,
    int? holdOut,
  }) {
    final newPrefs = prefs.copyWith(
      breatheInSeconds: breatheIn,
      holdInSeconds: holdIn,
      breatheOutSeconds: breatheOut,
      holdOutSeconds: holdOut,
    );

    bool allEqual =
        newPrefs.breatheInSeconds == newPrefs.holdInSeconds &&
        newPrefs.holdInSeconds == newPrefs.breatheOutSeconds &&
        newPrefs.breatheOutSeconds == newPrefs.holdOutSeconds;

    context.read<SettingsBloc>().add(
      UpdateSettings(
        newPrefs.copyWith(
          simpleDurationSeconds: allEqual ? newPrefs.breatheInSeconds : 0,
        ),
      ),
    );
  }

  /// Builds a selectable rounded chip for quickly choosing numerical values.
  Widget _buildChoiceChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).brightness == Brightness.light
                    ? Color(0x22E47B00)
                    : Color(0x44E47B00)
              : Colors.grey.withValues(alpha: 0.1),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).brightness == Brightness.light
                      ? Color(0x66E47B00)
                      : Color(0xFFE47B00)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).brightness == Brightness.light
                      ? Color(0xAAE47B00)
                      : Color(0xFFE47B00)
                : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Builds a dedicated row with increment and decrement buttons for
  /// fine-tuning independent advanced phase timings.
  Widget _buildAdvancedSlider(
    BuildContext context,
    String label,
    int value,
    Function(int) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                onPressed: value > 2 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
              ),
              Text(
                '${value}s',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: value < 10 ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
