import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/Home/home.dart';
import 'package:sklr/Util/startpage.dart';
import 'package:sklr/Util/splash_screen.dart';
import 'Support/supportFinder.dart';
import 'Support/supportMain.dart';
import 'Auth/test_auth.dart';
import 'Auth/fix_user.dart';
import 'Auth/emailVerification.dart';

// Create a global Supabase client that can be accessed from anywhere in the app
final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up logging
  log('==================================================');
  log('APPLICATION STARTING - ${DateTime.now()}');
  log('==================================================');

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://hoejgoxnrjbcjjwztgpf.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvZWpnb3hucmpiY2pqd3p0Z3BmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NjgzNzUsImV4cCI6MjA1NTU0NDM3NX0.yyw76pCrJ1y_uz_wBHH8ZWLNV7HTOBQcSQk_Ngj3kBs',
      debug: true,
    );
    
    log('Supabase initialized successfully');
  } catch (e) {
    log('Error initializing Supabase: $e');
    // Continue anyway, we'll handle the error gracefully
  }
  
  // Test Supabase connection
  try {
    log('Testing Supabase connection...');
    final response = await DatabaseHelper.testConnection();
    log('Database connection test: $response');
    
    // Try to get categories as a simple test
    final categories = await supabase.from('categories').select();
    log('Categories test: Found ${categories.length} categories');
    
    // Try to get current session info
    final session = supabase.auth.currentSession;
    log('Current auth session: ${session != null ? "Active" : "None"}');
    if (session != null) {
      log('Session user: ${session.user.id}');
      log('Session user email: ${session.user.email}');
      log('Session user metadata: ${session.user.userMetadata}');
    }
  } catch (e) {
    log('Database connection test failed: $e');
  }

  // Look for rememberMe in SharedPrefs.
  bool? rememberMe = false;
  dynamic userId;
  
  try {
    log('Reading saved authentication state...');
    rememberMe = await UserIdStorage.getRememberMe();
    userId = await UserIdStorage.getLoggedInUserId();
    log('Remember me setting: $rememberMe, User ID: $userId');
  } catch (e) {
    log('Error retrieving user data from storage: $e');
    // Reset values to ensure clean startup
    rememberMe = false;
    userId = null;
  }

  // Check if user is already authenticated with Supabase
  Session? session;
  try {
    log('Checking existing Supabase session...');
    session = supabase.auth.currentSession;
    log('Current session: ${session != null ? "Active" : "None"}');
    
    // If we have a session but no stored user ID, update storage
    if (session != null && userId == null) {
      log('Session exists but no stored user ID, updating storage');
      
      // Check if we have a db_user_id in metadata
      final dbUserId = session.user.userMetadata?['db_user_id'];
      
      if (dbUserId != null) {
        log('Found db_user_id in auth metadata: $dbUserId');
        await UserIdStorage.saveLoggedInUserId(dbUserId);
        userId = dbUserId;
        log('Saved db_user_id to local storage: $dbUserId');
      } else {
        // Try to find user by email
        final email = session.user.email;
        if (email != null) {
          log('No db_user_id in metadata, looking up user by email: $email');
          try {
            final userData = await supabase
                .from('users')
                .select()
                .eq('email', email)
                .maybeSingle();
                
            if (userData != null) {
              final dbId = userData['id'];
              log('Found user with email $email, ID: $dbId');
              await UserIdStorage.saveLoggedInUserId(dbId);
              userId = dbId;
              
              // Update auth metadata for future logins
              log('Updating auth metadata with db_user_id: $dbId');
              await supabase.auth.updateUser(UserAttributes(
                data: {
                  'db_user_id': dbId,
                }
              ));
              log('Auth metadata updated successfully');
            } else {
              log('No database user found with email $email, using auth ID');
              await UserIdStorage.saveLoggedInUserId(session.user.id);
              userId = session.user.id;
            }
          } catch (e) {
            log('Error looking up user by email: $e');
            await UserIdStorage.saveLoggedInUserId(session.user.id);
            userId = session.user.id;
          }
        } else {
          // No email, fall back to auth ID
          log('No email available, using auth ID as fallback');
          await UserIdStorage.saveLoggedInUserId(session.user.id);
          userId = session.user.id;
        }
      }
    }
  } catch (e) {
    log('Error checking current session: $e');
    // Continue with null session
  }
  
  // Determine which screen to show
  Widget homeWidget = const StartPage();
  
  try {
    // If we have a session or remembered user, try to log in
    if ((rememberMe == true && userId != null) || session != null) {
      // If we have a valid user ID, go to HomePage
      if (userId != null) {
        homeWidget = const HomePage();
      }
    }
  } catch (e) {
    log('Error determining home widget: $e');
  }
  
  // Start the app regardless of any errors
  runApp(MyApp(home: homeWidget));
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({Key? key, required this.home}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sklr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: home,
      routes: {
        '/support': (context) => const SupportMainPage(),
        '/support/finder': (context) => const SupportFinderPage(),
        '/home': (context) => const HomePage(),
        '/test_auth': (context) => const TestAuthPage(),
        '/fix_user': (context) => const FixUserPage(),
      },
      onGenerateRoute: (settings) {
        // Handle email verification deep link
        if (settings.name?.startsWith('/verify-email') ?? false) {
          final uri = Uri.parse(settings.name!);
          final token = uri.queryParameters['token'];
          final type = uri.queryParameters['type'];
          final email = uri.queryParameters['email'];
          
          return MaterialPageRoute(
            builder: (context) => EmailVerificationPage(
              token: token,
              type: type,
              email: email,
            ),
          );
        }
        
        // Handle other routes
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          // ... other routes ...
          default:
            return MaterialPageRoute(builder: (context) => const SplashScreen());
        }
      },
    );
  }
}
