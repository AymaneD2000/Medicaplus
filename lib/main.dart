import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

const supabaseUrl = 'https://egwiobbmoojwbtlxclqf.supabase.co';
// const supabaseKey = String.fromEnvironment(
//     '');
// Get a reference your Supabase client
//final supabase = Supabase.instance.client;
Future<void> main() async {
  await Supabase.initialize(
      url: supabaseUrl,
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnd2lvYmJtb29qd2J0bHhjbHFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk0OTc2NzgsImV4cCI6MjAyNTA3MzY3OH0.Qq2IIwF8BYD2yyG1fdq8sSXoIEZM5D1GqhkX7bjoihw");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DashBoard(),
    );
  }
}
