import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'register.dart';
import 'loginpage.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    'Sklr',
                    style: GoogleFonts.averiaSansLibre(
                      textStyle: TextStyle(
                        color: Color(0xFF6296FF),
                        fontSize: 74,
                      ),
                    ),
                  ),
                  Text(
                    'Share. Learn. Repeat',
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/skillerlogo.png',
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Login with...',
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 250.0,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 250.0,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            //go to google login page!
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
                            'Google',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 250.0,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            //go to apple login page!
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.black),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.black),
                              ))),
                          child: Text(
                            'Apple',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                          'Create an account',
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              color: Color(0xFF6296FF),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
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