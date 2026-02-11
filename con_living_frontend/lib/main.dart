import 'package:con_living_frontend/features/chat/chat_empty_state_screen.dart';
import 'package:con_living_frontend/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// This app currently boots into the pixel-perfect dashboard recreation.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String dashboardRoute = '/';
  static const String chatEmptyRoute = '/chat-empty';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Con Living',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Keep a dark UI by default to match dashboard design.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A2CFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      initialRoute: dashboardRoute,
      routes: {
        dashboardRoute: (context) => const DashboardScreen(),
        chatEmptyRoute: (context) => const ChatEmptyStateScreen(),
      },
    );
  }
}
