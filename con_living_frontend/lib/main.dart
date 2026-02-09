import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// This is intentionally minimal so the project compiles and runs even before
/// additional screens/routes are wired up.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If an AppTheme is added later (e.g. lib/theme/app_theme.dart),
    // update this file to use it. For now, default ThemeData keeps it compile-ready.
    return MaterialApp(
      title: 'Con Living',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Con Living'),
      ),
    );
  }
}
