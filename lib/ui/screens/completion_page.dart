import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:newu_task/core/utils.dart';
import '../../main.dart' as import_main;
import '../widgets/background_wrapper.dart';

class CompletionPage extends StatelessWidget {
  const CompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: kIsWeb
                    ? EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.35,
                        right: MediaQuery.of(context).size.width * 0.35,
                        top: 20,
                      )
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        import_main.MyApp.of(context).toggleTheme();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
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

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie Animation
                      SizedBox(
                        height: 180,
                        width: 180,
                        child: Lottie.asset(
                          'assets/animations/completed.lottie',
                          addRepaintBoundary: true,
                          decoder: customDecoder,
                          alignment: Alignment.center,
                          animate: true,
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'You did it! 🎉',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Great rounds of calm, just like that. Your mind thanks you.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 48),

                      // Start again button
                      SizedBox(
                        width: 260,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/breathing',
                              (route) => false,
                            );
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
                                'Start again',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 700),
                                  ],
                                  color:
                                      Theme.of(context).brightness !=
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/icons/air.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).brightness !=
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Back to set up button
                      SizedBox(
                        width: 190,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Back to set up',
                              style: TextStyle(
                                fontSize: 16,
                                fontVariations: <FontVariation>[
                                  FontVariation('wght', 600),
                                ],
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // Close SafeArea
      ), // Close Scaffold
    ); // Close BackgroundWrapper
  }
}
