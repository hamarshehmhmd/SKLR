import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/Profile/profile.dart';
import 'package:sklr/Chat/chat.dart';
import 'package:sklr/database/userIdStorage.dart';
import '../database/database.dart';
import '../Profile/user.dart';

class Skillinfo extends StatelessWidget {
  final int id;
  Skillinfo({super.key, required this.id});
  String userName = '';

  Future<Map<String, dynamic>> fetchSkill(int? id) async {
    if (id == null) {
      throw Exception('Skill does not exist');
    }

    try {
      return DatabaseHelper.fetchOneSkill(id);
    } catch (error) {
      throw Exception('Failed to fetch skill: $error');
    }
  }

  Future<Map<String, dynamic>> fetchUser(dynamic id) async {
    final response = await DatabaseHelper.fetchUserFromId(id is String ? int.tryParse(id) ?? 0 : id);
    if (response.success) {
      return response.data;
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6296FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF6296FF)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchSkill(id),
        builder: (context, skillSnapshot) {
          if (skillSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6296FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
                ),
              ),
            );
          } else if (skillSnapshot.hasError || !skillSnapshot.hasData || skillSnapshot.data == null) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6296FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      skillSnapshot.hasError ? Icons.error_outline : Icons.search_off,
                      size: 80,
                      color: skillSnapshot.hasError ? Colors.red : const Color(0xFF6296FF),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      skillSnapshot.hasError ? 'Error: ${skillSnapshot.error}' : 'Skill not found',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final skill = skillSnapshot.data!;
          return FutureBuilder<Map<String, dynamic>>(
            future: fetchUser(skill['user_id']),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
                  ),
                );
              } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                return Center(
                  child: Text(
                    'User not found',
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                );
              }

              final user = userSnapshot.data!;
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    // Background gradient
                    Container(
                      height: size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF6296FF).withOpacity(0.1),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                    
                    // Content
                    Column(
                      children: [
                        // Hero section
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF6296FF).withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6296FF).withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6296FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  skill['category'],
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6296FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                skill['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: isLargeScreen ? 36 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 24),
                              InkWell(
                                onTap: () async {
                                  final loggedInUserId = await UserIdStorage.getLoggedInUserId();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => skill['user_id'] == loggedInUserId
                                          ? ProfilePage()
                                          : UserPage(userId: skill['user_id']),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6296FF).withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF6296FF).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6296FF),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          user['username'][0].toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['username'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'Skill Provider',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Description section
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF6296FF).withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About this Skill',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                skill['description'],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  height: 1.8,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6296FF).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF6296FF).withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  'Posted on ${skill['created_at'].toString().substring(0, 10)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action buttons
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: FutureBuilder<dynamic>(
                            future: UserIdStorage.getLoggedInUserId(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
                                );
                              }

                              final userId = snapshot.data;
                              
                              // Helper function to check if the IDs are equivalent
                              bool isSameUser() {
                                if (userId == skill['user_id']) return true;
                                
                                // Try converting both to strings for comparison
                                final userIdStr = userId.toString();
                                final skillUserIdStr = skill['user_id'].toString();
                                return userIdStr == skillUserIdStr;
                              }
                              
                              if (isSameUser()) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6296FF).withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF6296FF).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.verified_user,
                                        color: const Color(0xFF6296FF),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'This is your own skill',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final self = await UserIdStorage.getLoggedInUserId();
                                        final selfInt = self is String ? int.tryParse(self) ?? -1 : self;
                                        
                                        final session = await DatabaseHelper.createSession(
                                          selfInt,
                                          skill['id'],
                                        );
                                        
                                        final skillUserId = skill['user_id'] is String ? 
                                            int.tryParse(skill['user_id']) ?? -1 : skill['user_id'];
                                            
                                        final result = await DatabaseHelper.getOrCreateChat(
                                          selfInt,
                                          skillUserId,
                                          session.data['id'],
                                        );
                                        
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              chatId: result,
                                              loggedInUserId: selfInt,
                                              otherUsername: user['username'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.chat_bubble_outline),
                                      label: Text(
                                        'Start Conversation',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xFF6296FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: TextButton.icon(
                                      onPressed: () => _confirmReport(context, skill['id']),
                                      icon: const Icon(Icons.flag_outlined),
                                      label: Text(
                                        'Report Skill',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(
                                            color: Colors.red.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmReport(BuildContext context, int skillId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Report Skill',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to report this skill? This action cannot be undone.',
            style: GoogleFonts.poppins(
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseHelper.createReport(skillId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Skill reported successfully',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Report',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
