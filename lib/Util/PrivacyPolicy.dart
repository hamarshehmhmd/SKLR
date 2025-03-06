import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Privacy & Policy",
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF6296FF),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1. Types of Data We Collect",
              style: GoogleFonts.mulish(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              "SKLR collects essential information to create and manage your account. This includes your username, email address, and phone number. Additionally, we store data about your in-app activities, such as coin transactions and rewards earned. This helps us enhance your experience and ensure the proper functioning of app features.",
              style: GoogleFonts.mulish(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "2. Use of Your Personal Data",
              style: GoogleFonts.mulish(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              "The information you provide is used to personalize your experience on SKLR. For example, your data enables us to manage your account, show your profile to others when needed, and track in-app coin usage. We also analyze this information to improve the app and introduce features that match user preferences. Your personal data is never shared with third parties for marketing purposes.",
              style: GoogleFonts.mulish(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "3. Disclosure of Your Personal Data",
              style: GoogleFonts.mulish(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              "We prioritize your privacy and do not share your personal data with third parties unless required by law. In certain situations, such as to comply with legal obligations or to prevent misuse of the platform, we may disclose limited data. SKLR ensures that any data shared follows strict security protocols to protect your information.",
              style: GoogleFonts.mulish(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
