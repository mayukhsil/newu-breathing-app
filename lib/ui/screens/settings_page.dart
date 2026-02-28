import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/settings_bloc/settings_bloc.dart';
import '../../logic/settings_bloc/settings_event.dart';
import '../../logic/settings_bloc/settings_state.dart';
import 'breathing_page.dart';
import '../../main.dart' as import_main;
import '../widgets/background_wrapper.dart';

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
            appBar: AppBar(
              title: const Text('breathing'),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.nights_stay,
                  ), // or brightness_high based on theme
                  onPressed: () {
                    // Toggle theme globally
                    import_main.MyApp.of(context).toggleTheme();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Set your breathing pace',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w800,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [3, 4, 5, 6].map((sec) {
                            return _buildChoiceChip(
                              context,
                              label: '${sec}s',
                              isSelected: prefs.simpleDurationSeconds == sec,
                              onTap: () {
                                context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    prefs.copyWith(simpleDurationSeconds: sec),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildChoiceChip(
                              context,
                              label: '2 quick',
                              isSelected: prefs.rounds == 2,
                              onTap: () => context.read<SettingsBloc>().add(
                                UpdateSettings(prefs.copyWith(rounds: 2)),
                              ),
                            ),
                            _buildChoiceChip(
                              context,
                              label: '4 calm',
                              isSelected: prefs.rounds == 4,
                              onTap: () => context.read<SettingsBloc>().add(
                                UpdateSettings(prefs.copyWith(rounds: 4)),
                              ),
                            ),
                            _buildChoiceChip(
                              context,
                              label: '6 deep',
                              isSelected: prefs.rounds == 6,
                              onTap: () => context.read<SettingsBloc>().add(
                                UpdateSettings(prefs.copyWith(rounds: 6)),
                              ),
                            ),
                            _buildChoiceChip(
                              context,
                              label: '8 zen',
                              isSelected: prefs.rounds == 8,
                              onTap: () => context.read<SettingsBloc>().add(
                                UpdateSettings(prefs.copyWith(rounds: 8)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Advanced timing logic
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Advanced timing',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Set different durations for each phase',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            onExpansionChanged: (expanded) {
                              context.read<SettingsBloc>().add(
                                UpdateSettings(
                                  prefs.copyWith(
                                    advancedTimingEnabled: expanded,
                                  ),
                                ),
                              );
                            },
                            initiallyExpanded: prefs.advancedTimingEnabled,
                            children: [
                              const SizedBox(height: 16),
                              _buildAdvancedSlider(
                                context,
                                'Breathe in',
                                prefs.breatheInSeconds,
                                (v) => context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    prefs.copyWith(breatheInSeconds: v),
                                  ),
                                ),
                              ),
                              _buildAdvancedSlider(
                                context,
                                'Hold in',
                                prefs.holdInSeconds,
                                (v) => context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    prefs.copyWith(holdInSeconds: v),
                                  ),
                                ),
                              ),
                              _buildAdvancedSlider(
                                context,
                                'Breathe out',
                                prefs.breatheOutSeconds,
                                (v) => context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    prefs.copyWith(breatheOutSeconds: v),
                                  ),
                                ),
                              ),
                              _buildAdvancedSlider(
                                context,
                                'Hold out',
                                prefs.holdOutSeconds,
                                (v) => context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    prefs.copyWith(holdOutSeconds: v),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Sound Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sound',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Gentle chime between phases',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                                    prefs.copyWith(soundEnabled: val),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BreathingPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start breathing',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.air),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildChoiceChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.1),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

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
