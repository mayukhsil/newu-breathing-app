import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme.dart';
import 'models/breathing_preferences.dart';
import 'logic/settings_bloc/settings_bloc.dart';
import 'logic/settings_bloc/settings_event.dart';
import 'ui/screens/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BreathingPreferencesAdapter());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _imagesPreloaded = false;

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

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
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
        home: const SettingsPage(),
      ),
    );
  }
}
