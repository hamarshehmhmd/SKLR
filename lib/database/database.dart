import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'userIdStorage.dart';
import 'supabase_service.dart';
import 'models.dart'; // Import shared models

// This class is now a wrapper around SupabaseService to maintain compatibility with existing code
class DatabaseHelper {
  // Flag to determine whether to use Supabase (true) or HTTP API (false)
  static const bool useSupabase = true;
  
  // Legacy backend URL (no longer used but kept for reference)
  static final String baseUrl = _initBackendUrl();
  
  static String _initBackendUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // Helper method to convert between String and int user IDs
  static String _convertUserId(dynamic userId) {
    if (userId is int) {
      return userId.toString();
    }
    return userId.toString();
  }

  // test backend server connection
  static Future<String> testConnection() async {
    try {
      // Just check if we can access the Supabase instance
      final result = await SupabaseService.getCategories();
      return result.isNotEmpty ? 'connected' : 'failed connection';
    } catch (err) {
      return 'failed connection: $err';
    }
  }

  // Get user data
  static Future<DatabaseResponse> getUser(int userId) async {
    try {
      final result = await SupabaseService.getUser(userId.toString());
      return result;
    } catch (err) {
      return DatabaseResponse(
        success: false,
        data: {'error': err.toString()},
      );
    }
  }

  // Search users by username or email
  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    return await SupabaseService.searchUsers(query);
  }

  // auth: Register
  static Future<LoginResponse> registerUser(
      String username, String email, String password) async {
    try {
      final result = await SupabaseService.registerUser(username, email, password);
      
      // Even if registration is successful but needs verification,
      // we return success with a special message
      if (result.message.contains('verification')) {
        return LoginResponse(
          success: true,
          message: 'verification_pending',
          userId: result.userId is String ? int.tryParse(result.userId) ?? -1 : result.userId,
        );
      }
      
      return LoginResponse(
        success: result.success,
        message: result.message,
        userId: result.userId is String ? int.tryParse(result.userId) ?? -1 : result.userId,
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Verify email
  static Future<bool> verifyEmail(String token, String type) async {
    try {
      return await SupabaseService.verifyEmail(token, type);
    } catch (e) {
      log('Error verifying email: $e');
      rethrow;
    }
  }

  // auth: Login
  static Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final result = await SupabaseService.signInWithEmail(email, password);
      return LoginResponse(
        success: result.success,
        message: result.message,
        userId: result.userId is String ? int.tryParse(result.userId) ?? -1 : result.userId,
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Logout
  static Future<Response> logoutUser() async {
    try {
      final success = await SupabaseService.signOut();
      return Response(
        success: success,
        message: success ? 'Logged out successfully' : 'Failed to logout',
      );
    } catch (e) {
      return Response(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Google Sign-In
  static Future<LoginResponse> googleSignIn() async {
    try {
      final result = await SupabaseService.signInWithGoogle();
      return LoginResponse(
        success: result.success,
        message: result.message,
        userId: result.userId is String ? int.tryParse(result.userId) ?? -1 : result.userId,
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Apple Sign-In
  static Future<LoginResponse> appleSignIn() async {
    try {
      final result = await SupabaseService.signInWithApple();
      return LoginResponse(
        success: result.success,
        message: result.message,
        userId: result.userId is String ? int.tryParse(result.userId) ?? -1 : result.userId,
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<DatabaseResponse> fetchUserFromId(int userId) async {
    return await SupabaseService.getUser(userId.toString());
  }

  // update data for user
  // supported fields: email, password, phone_number, bio
  static Future<DatabaseResponse> patchUser(
      int userId, Map<String, dynamic> fields) async {
    if (fields.isEmpty) {
      return DatabaseResponse(
          success: false, data: {'error': 'No fields provided'});
    }

    return await SupabaseService.updateUserData(userId.toString(), fields);
  }

  static Future<bool> userExist(String username) async {
    return await SupabaseService.usernameExists(username);
  }

  static Future<bool> userExistEmail(String email) async {
    return await SupabaseService.emailExists(email);
  }

  // fetch categories
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    return await SupabaseService.getCategories();
  }

  // fetch recent listings
  static Future<List<Map<String, dynamic>>> fetchRecentListings(
      int limit) async {
    return await SupabaseService.getRecentSkills(limit);
  }

  // fetch skills of a user
  static Future<List<Map<String, dynamic>>> fetchUserSkills(int userId) async {
    return await SupabaseService.getUserSkills(userId: userId.toString());
  }

  // search listings by keyword
  static Future<List<Map<String, dynamic>>> searchListings(String query) async {
    return await SupabaseService.searchSkills(query);
  }

  // create new listing
  static Future<DatabaseResponse> createListing(Map<String, dynamic> listing) async {
    return await SupabaseService.createSkill(listing);
  }

  // fetch specific listing
  static Future<DatabaseResponse> fetchListing(int skillId) async {
    try {
      final data = await SupabaseService.getSkill(skillId);
      return DatabaseResponse(
        success: data.isNotEmpty,
        data: data.isNotEmpty ? data : {'error': 'Skill not found'},
      );
    } catch (e) {
      return DatabaseResponse(
        success: false,
        data: {'error': e.toString()},
      );
    }
  }

  // update listing information
  static Future<DatabaseResponse> patchListing(
      int skillId, Map<String, dynamic> fields) async {
    return await SupabaseService.updateSkill(skillId, fields);
  }

  // delete listing
  static Future<bool> deleteListing(int skillId) async {
    return await SupabaseService.deleteSkill(skillId);
  }

  // fetch skills by category
  static Future<List<Map<String, dynamic>>> fetchSkillsByCategory(
      String category) async {
    return await SupabaseService.getSkillsByCategory(category);
  }

  // Compatibility method for older code
  static Future<List<Map<String, dynamic>>> fetchListingsByCategory(
      String categoryName) async {
    return await SupabaseService.getSkillsByCategory(categoryName);
  }

  // Compatibility method for older code
  static Future<Map<String, dynamic>> fetchOneSkill(int id) async {
    return await SupabaseService.getSkill(id);
  }

  // Advanced search with filters
  static Future<List<Map<String, dynamic>>> searchResults(
    String search, {
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) async {
    try {
      // Start with a basic search
      List<Map<String, dynamic>> results = await SupabaseService.searchSkills(search);
      
      // Apply filters
      if (category != null) {
        results = results.where((skill) => 
          skill['category'] == category
        ).toList();
      }
      
      if (minPrice != null) {
        results = results.where((skill) => 
          (skill['cost'] ?? 0) >= minPrice
        ).toList();
      }
      
      if (maxPrice != null) {
        results = results.where((skill) => 
          (skill['cost'] ?? 0) <= maxPrice
        ).toList();
      }
      
      // Sort results
      if (sortBy != null) {
        if (sortBy == 'price_asc') {
          results.sort((a, b) => (a['cost'] ?? 0).compareTo(b['cost'] ?? 0));
        } else if (sortBy == 'price_desc') {
          results.sort((a, b) => (b['cost'] ?? 0).compareTo(a['cost'] ?? 0));
        } else if (sortBy == 'date') {
          results.sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
        }
      }
      
      return results;
    } catch (e) {
      log('Error in searchResults: $e');
      return [];
    }
  }

  // For backward compatibility
  static Future<LoginResponse> fetchUserId(String email, String password) async {
    return await loginUser(email, password);
  }

  // CHAT OPERATIONS
  
  // Get all chats for the current user
  static Future<List<Map<String, dynamic>>> getUserChats([int? userId]) async {
    try {
      // Get current user ID if not provided
      final currentUserId = userId ?? await getCurrentUserId();
      if (currentUserId == null) {
        log('Error: No user ID available for fetching chats');
        return [];
      }

      log('Fetching chats for user $currentUserId');
      
      // Get all chats where the user is either sender or recipient
      final response = await supabase
          .from('chats')
          .select('*, messages(*)')
          .or('sender_id.eq.$currentUserId,recipient_id.eq.$currentUserId')
          .order('created_at', ascending: false);

      if (response == null) {
        log('No chats found for user $currentUserId');
        return [];
      }

      final List<Map<String, dynamic>> chats = List<Map<String, dynamic>>.from(response);
      log('Successfully fetched ${chats.length} chats');
      
      // Process chats to include other user's details
      final processedChats = await Future.wait(chats.map((chat) async {
        final otherUserId = chat['sender_id'] == currentUserId 
            ? chat['recipient_id'] 
            : chat['sender_id'];
            
        final otherUser = await getUserById(otherUserId);
        if (otherUser == null) {
          log('Warning: Could not find user details for ID $otherUserId');
          return null;
        }
        
        // Get the latest message for this chat
        final messages = List<Map<String, dynamic>>.from(chat['messages'] ?? []);
        messages.sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
        
        return {
          ...chat,
          'other_user': otherUser,
          'last_message': messages.isNotEmpty ? messages.first : {},
        };
      }));
      
      return processedChats.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      log('Error fetching user chats: $e');
      return [];
    }
  }

  // Get messages for a chat
  static Future<List<Map<String, dynamic>>> getChatMessages(int chatId, {int limit = 50, int offset = 0}) async {
    try {
      log('Fetching messages for chat $chatId (limit: $limit, offset: $offset)');
      
      final response = await supabase
          .from('messages')
          .select('*, sender:sender_id(*)')
          .eq('chat_id', chatId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (response == null) {
        log('No messages found for chat $chatId');
        return [];
      }

      final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(response);
      log('Successfully fetched ${messages.length} messages');

      // Process messages to include sender details
      return messages.map((message) {
        final sender = message['sender'] as Map<String, dynamic>?;
        return {
          ...message,
          'sender_name': sender?['full_name'] ?? 'Unknown User',
          'sender_image': sender?['profile_image'],
        };
      }).toList();
    } catch (e) {
      log('Error fetching chat messages: $e');
      return [];
    }
  }

  // Send a message
  static Future<bool> sendMessage(int chatId, dynamic senderId, String message) async {
    try {
      final messageData = {
        'chat_id': chatId,
        'sender_id': senderId is int ? senderId.toString() : senderId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };
      
      final response = await SupabaseService.sendMessage(messageData);
      return response.success;
    } catch (e) {
      log('Error in sendMessage: $e');
      return false;
    }
  }

  // Send a message with notification
  static Future<void> sendMessageWithNotification({
    required int chatId,
    required dynamic senderId,
    required String message,
    required String senderName,
    required dynamic recipientId,
    String? senderImage,
  }) async {
    try {
      log('Sending message from $senderId to $recipientId in chat $chatId: $message');
      
      // Create message data for the SupabaseService
      final messageData = {
        'chat_id': chatId,
        'sender_id': senderId is int ? senderId.toString() : senderId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };
      
      // Send the message
      final response = await SupabaseService.sendMessage(messageData);
      
      if (!response.success) {
        log('Failed to send message: ${response.data?['error'] ?? 'Unknown error'}');
        return;
      }
      
      log('Message sent successfully with ID: ${response.data['id']}');
      
      // Send notification to recipient
      final notificationContent = '$senderName: $message';
      await createNotification(
        recipientId: recipientId is int ? recipientId : int.parse(recipientId.toString()),
        message: notificationContent,
        senderId: senderId is int ? senderId : int.parse(senderId.toString()),
        senderImage: senderImage,
        chatId: chatId,
      );
      
      log('Notification created for recipient $recipientId');
    } catch (e) {
      log('Error in sendMessageWithNotification: $e');
    }
  }

  // For backward compatibility
  static Future<List<Map<String, dynamic>>> fetchChats(int userId) async {
    return await getUserChats(userId);
  }

  // Check if skill name exists
  static Future<bool> checkSkillName(String name, int? userId) async {
    try {
      final skills = await SupabaseService.getUserSkills(userId: userId?.toString());
      return skills.any((skill) => skill['name'] == name);
    } catch (e) {
      log('Error checking skill name: $e');
      return false;
    }
  }

  // Insert skill (compatibility with old method)
  static Future<Response> insertSkill(
      int? userId, String name, String description, String? category, double? cost) async {
    try {
      final result = await SupabaseService.createSkill({
        'user_id': userId.toString(),
        'name': name,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
        'category': category,
        'cost': cost,
      });
      
      return Response(
        success: result.success,
        message: result.success ? 'Skill added successfully' : result.data['error']?.toString() ?? 'Failed to insert skill',
      );
    } catch (e) {
      return Response(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Delete skill (compatibility with old method)
  static Future<Response> deleteSkill(String name, int? userId) async {
    try {
      // First find the skill by name and user ID
      final skills = await SupabaseService.getUserSkills(userId: userId?.toString());
      final skill = skills.firstWhere(
        (skill) => skill['name'] == name,
        orElse: () => <String, dynamic>{},
      );
      
      if (skill.isEmpty) {
        return Response(
          success: false,
          message: 'Skill not found',
        );
      }
      
      // Then delete it
      final success = await SupabaseService.deleteSkill(skill['id']);
      return Response(
        success: success,
        message: success ? 'Skill deleted successfully' : 'Failed to delete skill',
      );
    } catch (e) {
      return Response(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Award user (mock implementation)
  static Future<bool> awardUser(int userId) async {
    try {
      // Since we don't have this feature in the Supabase implementation,
      // we can mock it or update the user data to add credits
      final userData = await SupabaseService.getUser(userId.toString());
      if (!userData.success) return false;
      
      final currentCredits = userData.data['credits'] ?? 0;
      final result = await SupabaseService.updateUserData(
        userId.toString(),
        {'credits': currentCredits + 1}
      );
      
      return result.success;
    } catch (e) {
      log('Error awarding user: $e');
      return false;
    }
  }

  // get or create chat between users
  static Future<int> getOrCreateChat(
      int user1Id, int user2Id, int skillId) async {
    try {
      final chat = await SupabaseService.getOrCreateChat(
        user1Id.toString(),
        user2Id.toString(),
        skillId,
      );
      return chat['id'] ?? -1;
    } catch (e) {
      log('Error getting or creating chat: $e');
      return -1;
    }
  }

  // delete chat
  static Future<bool> deleteChat(int chatId) async {
    // Not implemented in SupabaseService yet, but would require proper cascade delete in Supabase
    // For now, just mark as deleted in the database
    try {
      // Return false instead of implementing this, as it's a destructive operation that should be carefully thought through
      return false;
    } catch (e) {
      return false;
    }
  }

  // create session
  static Future<DatabaseResponse> createSession(
      int requesterId, int skillId) async {
    final skillData = await SupabaseService.getSkill(skillId);
    if (skillData.isEmpty) {
      return DatabaseResponse(
        success: false,
        data: {'error': 'Skill not found'},
      );
    }

    final providerId = skillData['user_id'].toString();
    
    return await SupabaseService.createSession({
      'requester_id': requesterId.toString(),
      'provider_id': providerId,
      'skill_id': skillId,
      'status': 'Pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // fetch session by id
  static Future<DatabaseResponse> fetchSession(int sessionId) async {
    return await SupabaseService.getSession(sessionId);
  }
  
  // For backward compatibility
  static Future<DatabaseResponse> fetchSessionFromId(int sessionId) async {
    return await fetchSession(sessionId);
  }

  // fetch session from chat
  static Future<DatabaseResponse> fetchSessionFromChat(int chatId) async {
    return await SupabaseService.fetchSessionFromChat(chatId);
  }

  // fetch transaction
  static Future<DatabaseResponse> fetchTransaction(int transactionId) async {
    return await SupabaseService.getTransaction(transactionId);
  }

  // fetch transaction from session
  static Future<DatabaseResponse> fetchTransactionFromSession(
      int sessionId) async {
    try {
      final transactions = await SupabaseService.getSessionTransactions(sessionId);
      if (transactions.isEmpty) {
        return DatabaseResponse(
          success: false,
          data: {'error': 'No transaction found for this session'},
        );
      }
      return DatabaseResponse(
        success: true,
        data: transactions[0],
      );
    } catch (e) {
      return DatabaseResponse(
        success: false,
        data: {'error': e.toString()},
      );
    }
  }

  // create transaction
  static Future<bool> createTransaction(int sessionId) async {
    try {
      final result = await SupabaseService.createTransaction({
        'session_id': sessionId,
        'status': 'Pending',
        'created_at': DateTime.now().toIso8601String(),
      });
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // finalize transaction
  static Future<bool> finalizeTransaction(int transactionId) async {
    try {
      final result = await SupabaseService.finalizeTransaction(transactionId, 'Completed');
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // update session status
  static Future<bool> updateSessionStatus(int sessionId, String status) async {
    try {
      final result = await SupabaseService.updateSession(sessionId, {
        'status': status,
      });
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // fetch reports
  static Future<List<Map<String, dynamic>>> fetchReports() async {
    return await SupabaseService.getAllReports();
  }

  // remove report
  static Future<bool> removeReport(int reportId) async {
    try {
      await SupabaseService.getReport(reportId); // Check if report exists
      return await SupabaseService.resolveReport(reportId);
    } catch (e) {
      return false;
    }
  }

  // resolve report
  static Future<bool> resolveReport(int reportId) async {
    return await SupabaseService.resolveReport(reportId);
  }

  // create report
  static Future<bool> createReport(int skillId) async {
    final userId = await UserIdStorage.getLoggedInUserId();
    if (userId == null) return false;
    
    try {
      final result = await SupabaseService.createReport({
        'reporter_id': userId.toString(),
        'skill_id': skillId,
        'reason': 'Reported from mobile app',
        'status': 'Pending',
        'created_at': DateTime.now().toIso8601String(),
      });
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // get unread message count
  static Future<int> getUnreadMessageCount() async {
    return await SupabaseService.getUnreadMessageCount();
  }

  // mark chat as read
  static Future<void> markChatAsRead(int chatId) async {
    await SupabaseService.markChatAsRead(chatId);
  }

  // get notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    return await SupabaseService.getNotifications();
  }

  // mark notification as read
  static Future<void> markNotificationAsRead(int notificationId) async {
    await SupabaseService.markNotificationAsRead(notificationId);
  }

  // fetch active services
  static Future<List<Map<String, dynamic>>> fetchActiveServices() async {
    final userId = await UserIdStorage.getLoggedInUserId();
    if (userId == null) return [];
    
    return await SupabaseService.getActiveSessionsForUser(userId.toString());
  }

  // complete service
  static Future<bool> completeService(int sessionId) async {
    return await SupabaseService.completeSession(sessionId);
  }

  // cancel service
  static Future<bool> cancelService(int sessionId) async {
    return await SupabaseService.cancelSession(sessionId);
  }

  // Get a user's skills
  static Future<List<Map<String, dynamic>>> getUserSkills(String userId) async {
    if (useSupabase) {
      return await SupabaseService.getUserSkills(userId: userId.toString());
    } else {
      final response = await http.get(
        Uri.parse('$baseUrl/api/skills/user/$userId'),
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      } else {
        print('Failed to load user skills: ${response.statusCode}');
        return [];
      }
    }
  }

  // Get user profile with their skills
  static Future<Map<String, dynamic>> getUserProfileWithSkills(String userId) async {
    if (useSupabase) {
      try {
        final user = await SupabaseService.getUserById(userId);
        
        if (user == null) {
          return {'error': 'User not found'};
        }
        
        final skills = await SupabaseService.getUserSkills(userId: userId.toString());
        
        final Map<String, dynamic> userProfile = Map.from(user);
        userProfile['skills'] = skills;
        
        return userProfile;
      } catch (e) {
        print('Error fetching user profile with skills: $e');
        return {'error': 'Failed to fetch user profile'};
      }
    } else {
      // HTTP API version
      // ... existing code ...
      return {};
    }
  }

  // For backward compatibility
  static Future<List<Map<String, dynamic>>> fetchSkills(int userId) async {
    return await fetchUserSkills(userId);
  }

  // Get provider details
  static Future<Map<String, dynamic>> getProviderDetails(String userId) async {
    if (useSupabase) {
      try {
        final user = await SupabaseService.getUserById(userId);
        
        if (user == null) {
          return {'error': 'Provider not found'};
        }
        
        final skills = await SupabaseService.getUserSkills(userId: userId.toString());
        
        final Map<String, dynamic> providerDetails = Map.from(user);
        providerDetails['skills'] = skills;
        
        return providerDetails;
      } catch (e) {
        print('Error fetching provider details: $e');
        return {'error': 'Failed to fetch provider details'};
      }
    } else {
      // HTTP API version
      // ... existing code ...
      return {};
    }
  }

  // Create notification
  static Future<bool> createNotification({
    required int recipientId,
    required String message,
    required int senderId,
    String? senderImage,
    int? chatId,
  }) async {
    try {
      log('Creating notification for recipient $recipientId from sender $senderId');
      
      final notificationData = {
        'user_id': recipientId,
        'message': message,
        'sender_id': senderId,
        'sender_image': senderImage,
        'chat_id': chatId,
        'read': false,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final result = await supabase
          .from('notifications')
          .insert(notificationData)
          .select()
          .single();
      
      log('Notification created successfully with ID: ${result['id']}');
      return true;
    } catch (e) {
      log('Error creating notification: $e');
      return false;
    }
  }

  // Get the current user's ID
  static Future<int?> getCurrentUserId() async {
    try {
      final userId = await UserIdStorage.getLoggedInUserId();
      if (userId != null) {
        return int.tryParse(userId.toString());
      }
      return null;
    } catch (e) {
      log('Error getting current user ID: $e');
      return null;
    }
  }

  // Get user by ID
  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final response = await SupabaseService.getUser(userId.toString());
      if (response.success && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      log('Error getting user by ID: $e');
      return null;
    }
  }
}

