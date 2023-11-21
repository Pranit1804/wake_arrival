import 'package:flutter/material.dart';
import 'package:wake_arrival/models/home/presentation/home.dart';
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
      home: const Home(),
      routes: Routes.getAll(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
