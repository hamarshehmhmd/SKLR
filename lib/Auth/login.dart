import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/Home/home.dart';
import 'package:sklr/Auth/register.dart';
//login page done   
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _keepLogIn = false;
  bool isLoginEnabled = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to email and password controllers
    _emailController.addListener(_updateLoginButtonState);
    _passwordController.addListener(_updateLoginButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to check if the Login button should be enabled
  void _updateLoginButtonState() {
    setState(() {
      isLoginEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _isValidEmail(_emailController.text);
    });
  }

  // Simple email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Method to check login credentials
  Future<void> _checkLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // fetch for potential user 
    LoginResponse result = await DatabaseHelper.fetchUserId(email, password);
        

    // If a matching user is found, navigate to the next page
    if (result.success) {
      // Successfully logged in

      //saving the userId
      final int userId = result.userId;
      await UserIdStorage.saveLoggedInUserId(userId);

      // save remember me status
      await UserIdStorage.setRememberMe(_keepLogIn);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      // Invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust layout based on screen size
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenWidth < 600
            ? const EdgeInsets.all(16)
            : const EdgeInsets.symmetric(
                horizontal: 50, vertical: 30), // Responsive padding
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.mulish(
                      fontSize:
                          screenWidth < 600 ? 32 : 40, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Email Input TextField
                const Text("Email", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
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
                // Password Input TextField
                const Text("Password", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Toggle visibility
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle visibility
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
                // "Keep me logged in" Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _keepLogIn,
                      onChanged: (value) {
                        setState(() {
                          _keepLogIn = value!;
                        });
                      },
                      activeColor: const Color(0xFF6296FF),
                    ),
                    const Text("Keep me logged in"),
                  ],
                ),
                const SizedBox(height: 20),
                // Login Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6296FF),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoginEnabled ? _checkLogin : null,
                    child: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                ),
                const SizedBox(height: 20),
                
                // "Don't have an account? Sign up" Text
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6296FF),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
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
