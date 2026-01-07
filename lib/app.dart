import 'package:flutter/material.dart';
import 'package:wake_arrival/common/pages/splash_screen.dart';
import 'package:wake_arrival/common/theme/app_theme.dart';
import 'package:wake_arrival/models/routes/routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: Routes.getAll(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
