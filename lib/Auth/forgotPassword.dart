import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Image/Icon
                Image.asset(
                  "assets/images/forgot-password.png",
                  height: isLargeScreen ? 300 : 200,
                  width: isLargeScreen ? 300 : 200,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.mulish(
                    fontSize: isLargeScreen ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  "Don't worry! It happens. Please enter the email associated with your account.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    fontSize: isLargeScreen ? 18 : 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),
                // Email Input Label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                // Email Input Field
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    fillColor: const Color.fromARGB(125, 207, 235, 252),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add send functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6296FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// responsive check done 
//forgot password page done 