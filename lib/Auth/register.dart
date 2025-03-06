import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/Auth/phoneNumber.dart';
import 'login.dart';
import '../Util/PrivacyPolicy.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool termsAccepted = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool registerEnabled() {
    return username.isNotEmpty && 
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        termsAccepted;
  }

  void registerUser(BuildContext context) async {
    LoginResponse result = await DatabaseHelper.registerUser(username, email, password);

    if (result.success) {
      await UserIdStorage.saveLoggedInUserId(result.userId);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PhoneNumber()),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Register',
                    style: GoogleFonts.mulish(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Username", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8,),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    prefixIcon: const Icon(Icons.account_circle_outlined),
                    fillColor: const Color.fromARGB(125, 207, 235, 252),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Email", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
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
                const SizedBox(height: 20),
                const Text("Password", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  obscureText: !passwordVisible,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    fillColor: const Color.fromARGB(125, 207, 235, 252),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Confirm Password", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  obscureText: !confirmPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        });
                      },
                    ),
                    fillColor: const Color.fromARGB(125, 207, 235, 252),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF6296FF),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        const Text("I agree to the"),
                      ],
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: 'Terms of Service ',
                          style: GoogleFonts.mulish(
                            color: Color(0xFF6296FF),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                                //Dont exist
                            },
                          children: [
                            const TextSpan(
                              text: 'and ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.mulish(
                                color: Color(0xFF6296FF),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to the Privacy Policy page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: registerEnabled()
                        ? () {
                            registerUser(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: registerEnabled()
                          ? const Color(0xFF6296FF)
                          : Colors.grey,
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child:RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.mulish(
                            textStyle: const TextStyle(
                              color: Color(0xFF6296FF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}