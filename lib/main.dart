import 'package:medpharm/DatabaseManagement/providers/medicament_provider.dart';
import 'package:medpharm/DatabaseManagement/providers/pharmacie_provider.dart';
import 'package:medpharm/DatabaseManagement/providers/cours_provider.dart';
import 'package:medpharm/DatabaseManagement/providers/materiel_provider.dart';
import 'package:medpharm/Utils/version_gate.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:medpharm/auth/supabase_auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:medpharm/Utils/transitions.dart';
import 'package:medpharm/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const supabaseUrl = 'https://egwiobbmoojwbtlxclqf.supabase.co';
const authRedirectUrl = 'medpharm://login-callback';
// const supabaseKey = String.fromEnvironment(
//     '');
// Get a reference your Supabase client
//final supabase = Supabase.instance.client;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: supabaseUrl,
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnd2lvYmJtb29qd2J0bHhjbHFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk0OTc2NzgsImV4cCI6MjAyNTA3MzY3OH0.Qq2IIwF8BYD2yyG1fdq8sSXoIEZM5D1GqhkX7bjoihw");
  final authRepository = SupabaseAuthRepository(
    Supabase.instance.client,
    redirectUrl: kIsWeb ? Uri.base.origin : authRedirectUrl,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthController(authRepository)..initialize(),
      ),
      ChangeNotifierProvider(create: (_) => MedicamentProvider()),
      ChangeNotifierProvider(create: (_) => PharmacieProvider()),
      ChangeNotifierProvider(create: (_) => CoursProvider()),
      ChangeNotifierProvider(create: (_) => MaterielProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fr', 'FR'), // Set the desired locale (e.g., French)
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('fr', 'FR'), // French
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // Provides Material localizations
        GlobalWidgetsLocalizations.delegate, // Defines text direction (LTR/RTL)
        GlobalCupertinoLocalizations
            .delegate, // Optional, for Cupertino widgets
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: AppTheme.light.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PremiumPageTransitionsBuilder(),
            TargetPlatform.iOS: PremiumPageTransitionsBuilder(),
            TargetPlatform.macOS: PremiumPageTransitionsBuilder(),
            TargetPlatform.windows: PremiumPageTransitionsBuilder(),
            TargetPlatform.linux: PremiumPageTransitionsBuilder(),
          },
        ),
      ),
      home: const VersionGate(),
    );
  }
}
