import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'providers/app_provider.dart';
import 'providers/bookmark_provider.dart';

import 'screens/achievements.dart';
import 'screens/carbon_tracker.dart';
import 'screens/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load(fileName: ".env");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true, // Disable in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ],
        child: EcoTrekApp(),
      ),
    ),
  );

}

class EcoTrekApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      title: 'EcoTrek',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          background: const Color(0xFFF7F8FC),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
      ),
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/achievements': (context) => AchievementsScreen(),
        '/carbon-tracker': (context) {
          final provider = Provider.of<AppProvider>(context, listen: false);
          return CarbonTrackerScreen(
            userChallenges: provider.challenges,
            completedIds: provider.currentUser?.completedChallenges ?? [],
          );
        },
      },
    );
  }
}