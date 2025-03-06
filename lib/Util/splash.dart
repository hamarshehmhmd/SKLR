import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/Util/startpage.dart';

// using "flutter_native_splash" instead

class SplashToHome extends StatefulWidget {
  const SplashToHome({super.key});

  @override
  _SplashToHomeState createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  bool _loading = true;
  final int _duration = 1;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: _duration));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? SplashScreen() : StartPage();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                // top-right blurred circle
                top: -150,
                right: -150,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.lightBlue.withAlpha(51),
                        Colors.lightBlue.withAlpha(0)
                      ],
                      stops: [0.6, 1.0],
                    ),
                  ),
                )),
            Positioned(
                // bottom-left blurred circle
                bottom: -150,
                left: -150,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.lightBlue.withAlpha(51),
                        Colors.lightBlue.withAlpha(0)
                      ],
                      stops: [0.6, 1.0],
                    ),
                  ),
                )),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sklr",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.averiaSansLibre(
                      textStyle:
                          TextStyle(color: Color(0xFF6296FF), fontSize: 74),
                    ),
                  ),
                  Text(
                    "Share. Learn. Repeat",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}