import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme.dart';
import 'models/breathing_preferences.dart';
import 'logic/settings_bloc/settings_bloc.dart';
import 'logic/settings_bloc/settings_event.dart';
import 'ui/screens/settings_page.dart';
import 'ui/screens/breathing_page.dart';
import 'ui/screens/completion_page.dart';

/// The main entry point for the Box Breathing application.
///
/// Initializes critical services such as [WidgetsFlutterBinding] and [Hive]
/// for local storage before running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BreathingPreferencesAdapter());
  await Hive.openBox('appSettings');

  runApp(const MyApp());
}

/// The root widget of the Breathing application.
///
/// This widget sets up the global [BlocProvider] for [SettingsBloc] and
/// configures the [MaterialApp] with the appropriate theme and routing.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Retrieves the current [MyAppState] from the given [BuildContext].
  ///
  /// This is used to access global app-level methods like [toggleTheme].
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

/// The state for [MyApp], managing the global theme mode and preloading assets.
class MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  bool _imagesPreloaded = false;
  late Box _appSettingsBox;

  @override
  void initState() {
    super.initState();
    _appSettingsBox = Hive.box('appSettings');
    final isDark = _appSettingsBox.get('isDarkMode', defaultValue: false);
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPreloaded) {
      precacheImage(const AssetImage('assets/images/lightBG.png'), context);
      precacheImage(const AssetImage('assets/images/lightBG_web.png'), context);
      precacheImage(const AssetImage('assets/images/darkBG.png'), context);
      precacheImage(const AssetImage('assets/images/darkBG_web.png'), context);
      _imagesPreloaded = true;
    }
  }

  /// Toggles the application between light and dark modes.
  ///
  /// The selection is updated globally via [setState] and saved
  /// persistently using [Hive].
  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    _appSettingsBox.put('isDarkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(LoadSettings()),
      child: MaterialApp(
        title: 'Breathing App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => const SettingsPage(),
          '/breathing': (context) => const BreathingPage(),
          '/completion': (context) => const CompletionPage(),
        },
      ),
    );
  }
}
