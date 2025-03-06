import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String? _selectedCountryCode = '+1'; // Default to US
  String? _selectedCountryFlag = '🇺🇸'; // Default US flag emoji
  
  // Common country codes with flag emojis
  final Map<String, String> _countryCodes = {
    '🇺🇸 United States': '+1',
    '🇬🇧 United Kingdom': '+44',
    '🇨🇦 Canada': '+1',
    '🇦🇺 Australia': '+61',
    '🇩🇪 Germany': '+49',
    '🇫🇷 France': '+33',
    '🇮🇳 India': '+91',
    '🇨🇳 China': '+86',
    '🇯🇵 Japan': '+81',
    '🇧🇷 Brazil': '+55',
    '🇲🇽 Mexico': '+52',
    '🇿🇦 South Africa': '+27',
    '🇳🇬 Nigeria': '+234',
    '🇪🇬 Egypt': '+20',
    '🇸🇦 Saudi Arabia': '+966',
    '🇦🇪 UAE': '+971',
    '🇸🇬 Singapore': '+65',
    '🇲🇾 Malaysia': '+60',
    '🇮🇹 Italy': '+39',
    '🇪🇸 Spain': '+34',
  };
  
  Map<String, dynamic>? userData;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await UserIdStorage.getLoggedInUserId();
      final result = await DatabaseHelper.getUser(userId!);
      if (result.success && result.data != null) {
        setState(() {
          userData = result.data;
          _usernameController.text = userData?['username'] ?? '';
          _emailController.text = userData?['email'] ?? '';
          _bioController.text = userData?['bio'] ?? '';
          _locationController.text = userData?['location'] ?? '';
          _websiteController.text = userData?['website'] ?? '';
          
          // Parse phone number if it exists
          String phoneNumber = userData?['phone_number'] ?? '';
          if (phoneNumber.isNotEmpty) {
            // Check if phone has country code
            if (phoneNumber.startsWith('+')) {
              // Extract country code (assuming format like +1234567890)
              int spaceIndex = phoneNumber.indexOf(' ');
              if (spaceIndex != -1) {
                _selectedCountryCode = phoneNumber.substring(0, spaceIndex);
                _phoneController.text = phoneNumber.substring(spaceIndex + 1);
              } else {
                // Default handling if no space found
                _selectedCountryCode = '+1'; // Default to US
                _phoneController.text = phoneNumber.replaceFirst(RegExp(r'^\+\d+'), '');
              }
            } else {
              _selectedCountryCode = '+1'; // Default to US
              _phoneController.text = phoneNumber;
            }
            
            // Set flag emoji based on country code
            _setFlagFromCountryCode(_selectedCountryCode!);
          } else {
            _selectedCountryCode = '+1'; // Default to US
            _selectedCountryFlag = '🇺🇸'; // Default US flag
          }
          
          isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
  
  void _setFlagFromCountryCode(String code) {
    // Find the flag for the given country code
    String? countryWithFlag = _countryCodes.entries
        .firstWhere(
          (entry) => entry.value == code,
          orElse: () => const MapEntry('🇺🇸 United States', '+1'),
        )
        .key;
    
    // Extract just the flag emoji (first character)
    _selectedCountryFlag = countryWithFlag.substring(0, 2);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    int? maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.lexend(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lexend(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF6296FF)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6296FF), width: 2),
          ),
          errorText: errorText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
  
  Widget _buildPhoneField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ],
        style: GoogleFonts.lexend(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: GoogleFonts.lexend(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: GestureDetector(
            onTap: () {
              _showCountryCodeDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedCountryFlag ?? '🌍', style: GoogleFonts.lexend(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    _selectedCountryCode ?? '+1',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: const Color(0xFF6296FF),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF6296FF), size: 18),
                ],
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6296FF), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
  
  void _showCountryCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Country Code',
            style: GoogleFonts.lexend(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _countryCodes.length,
              itemBuilder: (context, index) {
                String country = _countryCodes.keys.elementAt(index);
                String code = _countryCodes.values.elementAt(index);
                return ListTile(
                  title: Text(
                    '$country ($code)',
                    style: GoogleFonts.lexend(),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCountryCode = code;
                      _selectedCountryFlag = country.substring(0, 2); // Get just the flag emoji
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.lexend(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF6296FF),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6296FF)))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 40.0 : 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6296FF), Color(0xFF5A89F2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6296FF).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_note,
                              color: Colors.white,
                              size: 36,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Personal Information',
                                style: GoogleFonts.lexend(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person_outline,
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildPhoneField(),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      _buildTextField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on_outlined,
                      ),
                      _buildTextField(
                        controller: _websiteController,
                        label: 'Website',
                        icon: Icons.link,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6296FF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() => isLoading = true);
                            try {
                              final userId = await UserIdStorage.getLoggedInUserId();
                              
                              // Format phone number with country code
                              String formattedPhone = '';
                              if (_phoneController.text.isNotEmpty) {
                                formattedPhone = '$_selectedCountryCode ${_phoneController.text}';
                              }
                              
                              final update = {
                                'username': _usernameController.text,
                                'email': _emailController.text,
                                'bio': _bioController.text,
                                'location': _locationController.text,
                                'website': _websiteController.text,
                                'phone': formattedPhone,
                              };
                              
                              final result = await DatabaseHelper.patchUser(userId!, update);
                              setState(() => isLoading = false);
                              
                              if (result.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Profile updated successfully',
                                      style: GoogleFonts.lexend(),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update profile',
                                      style: GoogleFonts.lexend(),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() => isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'An error occurred',
                                    style: GoogleFonts.lexend(),
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6296FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save_outlined, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                'Save Changes',
                                style: GoogleFonts.lexend(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
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