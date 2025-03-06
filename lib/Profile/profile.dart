import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sklr/Util/PrivacyPolicy.dart';
import 'package:sklr/Profile/dashboard.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/Util/startpage.dart';
import 'dart:io';
import 'editProfile.dart';
import '../Util/navigationbar-bar.dart';
import '../database/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isModerator = false;
  String? _avatarUrl;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _loadUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userId = await UserIdStorage.getLoggedInUserId();
    if (userId != null && userId > 0) {
      final response = await DatabaseHelper.fetchUserFromId(userId);
      if (response.success) {
        setState(() {
          userData = response.data;
          _avatarUrl = userData?['avatar_url'];
          isLoading = false;
          isModerator = userData!['moderator'];
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => isLoading = true);

      final userId = await UserIdStorage.getLoggedInUserId();
      if (userId == null) return;
      
      final bytes = await pickedFile.readAsBytes();
      final fileExt = pickedFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'profiles/$userId/$fileName';

      await supabase.storage.from('profile-pictures').uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final imageUrl = supabase.storage.from('profile-pictures').getPublicUrl(filePath);

      await supabase.from('users').update({
        'avatar_url': imageUrl
      }).eq('id', userId as Object);

      setState(() {
        _avatarUrl = imageUrl;
        userData?['avatar_url'] = imageUrl;
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF6296FF),
            behavior: SnackBarBehavior.floating,
          )
        );
      }

    } catch (error) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
            )
          )
        : SafeArea(
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6296FF), Color(0xFF4A7BFF)],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 40.0 : 20.0,
                      vertical: 20.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildCreditsSection()
                        ),
                        const SizedBox(height: 30),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildProfileImage()
                        ),
                        const SizedBox(height: 25),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildUserInfo()
                        ),
                        const SizedBox(height: 30),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildOptions()
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildCreditsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6296FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6296FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF6296FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Credits',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "${userData?['credits'] ?? 0}",
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6296FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6296FF), Color(0xFF4A7BFF)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6296FF).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: _avatarUrl != null
                ? Image.network(
                    _avatarUrl!,
                    fit: BoxFit.cover,
                    width: 134,
                    height: 134,
                    errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/avatar.png'),
                  )
                : Image.asset('assets/images/avatar.png'),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6296FF), Color(0xFF4A7BFF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6296FF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            userData?['username'] ?? 'Unknown User',
            style: GoogleFonts.lexend(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6296FF),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 5),
              Text(
                userData?['email'] ?? 'No Email',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 5),
              Text(
                userData?['phone_number'] ?? 'No Phone',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isModerator) ...[
            OptionTile(
              icon: Icons.report_gmailerrorred_outlined,
              title: 'Reports',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ModeratorDashboard()),
              ),
            ),
            const Divider(height: 1, thickness: 0.5),
          ],
          OptionTile(
            icon: Icons.person_outline,
            title: 'Edit profile information',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          OptionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy policy',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          OptionTile(
            icon: Icons.logout_outlined,
            title: 'Sign Out',
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6296FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFF6296FF),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Sign Out",
                  style: GoogleFonts.lexend(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "If you sign out, you will no longer have access to Sklr or any of its services.",
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.lexend(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await supabase.auth.signOut();
                        await UserIdStorage.setRememberMe(false);
                        await UserIdStorage.saveLoggedInUserId(-1);
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const StartPage())
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6296FF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF6296FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF6296FF), size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
