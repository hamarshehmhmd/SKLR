import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/Home/home.dart';
import 'package:sklr/Util/startpage.dart';
import 'Support/supportFinder.dart';
import 'Support/supportMain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://hoejgoxnrjbcjjwztgpf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvZWpnb3hucmpiY2pqd3p0Z3BmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NjgzNzUsImV4cCI6MjA1NTU0NDM3NX0.yyw76pCrJ1y_uz_wBHH8ZWLNV7HTOBQcSQk_Ngj3kBs',
  );

  // Test database connection
  DatabaseHelper.testConnection()
      .then((data) => {log('testConnection(): $data')});

  // Look for rememberMe in SharedPrefs.
  bool? rememberMe = await UserIdStorage.getRememberMe();

  // RememberMe is enabled
  if (rememberMe != null && rememberMe) {
    // Look for userId in SharedPrefs.
    int? userId = await UserIdStorage.getLoggedInUserId();

    // userId is set
    if (userId != null && userId > 0) {
      runApp(MyApp(home: const HomePage()));
    } else {
      runApp(MyApp(home: const StartPage()));
    }
  } else {
    runApp(MyApp(home: const StartPage()));
  }
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({Key? key, required this.home}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      routes: {
        '/support': (context) => const SupportMainPage(),
        '/support/finder': (context) => const SupportFinderPage(),
      },
    );
  }
}
