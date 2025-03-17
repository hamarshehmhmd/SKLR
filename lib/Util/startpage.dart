import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:sklr/database/supabase_service.dart';
import 'package:sklr/Home/home.dart';

import '../Auth/register.dart';
import '../Auth/login.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SupabaseService.signInWithGoogle();
      
      if (response.success) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Google: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SupabaseService.signInWithApple();
      
      if (response.success) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Apple: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Getting screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.1), // 10% of screen height
                  Text(
                    'Sklr',
                    style: GoogleFonts.averiaSansLibre(
                      textStyle: TextStyle(
                        color: Color(0xFF6296FF),
                        fontSize: screenWidth * 0.2, // 20% of screen width
                      ),
                    ),
                  ),
                  Text(
                    'Share. Learn. Repeat',
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.04, // 4% of screen width
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/skillerlogo.png',
                    height: screenWidth * 0.6, // 60% of screen width
                    width: screenWidth * 0.6, // 60% of screen width
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Login with...',
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05, // 5% of screen width
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  
                  // Email login button
                  SizedBox(
                    width: screenWidth * 0.7, // 70% of screen width
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      child: Text(
                        'Email',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:
                                screenWidth * 0.04, // 4% of screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  
                  // Google Sign-In Button
                  SizedBox(
                    width: screenWidth * 0.7, // 70% of screen width
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      label: Text(
                        'Continue with Google',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  
                  // Apple Sign-In Button
                  SizedBox(
                    width: screenWidth * 0.7, // 70% of screen width
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.apple, color: Colors.black),
                      onPressed: _isLoading ? null : _signInWithApple,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      label: Text(
                        'Continue with Apple',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  
                  // Create account button
                  SizedBox(
                    width: screenWidth * 0.7, // 70% of screen width
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                              );
                            },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.blueGrey),
                          ))),
                      child: Text(
                        'Create account',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:
                                screenWidth * 0.04, // 4% of screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//responsive check done
