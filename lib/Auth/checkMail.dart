import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckMailPage extends StatefulWidget {
  const CheckMailPage({Key? key}) : super(key: key);

  @override
  _CheckMailPageState createState() => _CheckMailPageState();
}

class _CheckMailPageState extends State<CheckMailPage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve screen dimensions
    final size = MediaQuery.of(context).size;

    // Dynamic sizing based on screen width
    final isLargeScreen = size.width > 600;
    final imageSize = isLargeScreen ? size.width * 0.4 : size.width * 0.8;
    final fontSize = isLargeScreen ? 22.0 : 18.0;
    final buttonPadding = isLargeScreen
        ? const EdgeInsets.symmetric(vertical: 18, horizontal: 40)
        : const EdgeInsets.symmetric(vertical: 15, horizontal: 30);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/checkmail.png',
                height: imageSize,
                width: imageSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                "We have sent password recovery instructions to your email.",
                style: GoogleFonts.mulish(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6296FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: buttonPadding,
                ),
                child: Text(
                  "Finish",
                  style: TextStyle(
                    fontSize: isLargeScreen ? 18 : 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//responsive check done 
//check mail page done 