import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/Chat/chatSessionUtil.dart';
import 'package:sklr/Profile/user.dart';
import '../database/database.dart';
import '../Util/navigationbar-bar.dart';
import 'chatsHome.dart';
import '../Home/home.dart';
import '../Skills/myOrders.dart';
import '../Profile/profile.dart';
import '../Support/supportMain.dart';

class ChatPage extends StatefulWidget {
  final int chatId;
  final int loggedInUserId; 
  final String otherUsername;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.loggedInUserId,
    required this.otherUsername,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<Map<String, dynamic>>> messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  late Map<String, dynamic> session;

  @override
  void initState() {
    super.initState();
    messages = _initializeMessages();
    _markMessagesAsRead();
    // Set up periodic refresh every 10 seconds
    _startPeriodicRefresh();
  }

  Future<List<Map<String, dynamic>>> _initializeMessages() async {
    try {
      final messages = await DatabaseHelper.getChatMessages(widget.chatId);
      return messages;
    } catch (e) {
      debugPrint('Error initializing messages: $e');
      return [];
    }
  }

  void _startPeriodicRefresh() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _loadMessages();
        _startPeriodicRefresh();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (!mounted) return;
    
    setState(() => isLoading = true);
    try {
      final messagesList = await DatabaseHelper.getChatMessages(widget.chatId);
      if (mounted) {
        setState(() {
          messages = Future.value(messagesList);
          isLoading = false;
        });
      }
      
      // Scroll to bottom after messages load
      await Future.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages: $e'))
        );
      }
    }
  }

  Future<void> _handleSendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() => isLoading = true);
    try {
      // Get the recipient ID from the session
      final sessionData = await DatabaseHelper.fetchSessionFromChat(widget.chatId);
      if (!sessionData.success) {
        throw Exception('Failed to fetch session data');
      }
      
      final recipientId = sessionData.data['provider_id'] == widget.loggedInUserId
          ? sessionData.data['requester_id']
          : sessionData.data['provider_id'];
      
      // Get the sender's name
      final senderData = await DatabaseHelper.getUserById(widget.loggedInUserId);
      final senderName = senderData?['username'] ?? 'Unknown User';
      final senderImage = senderData?['profile_image'];

      await DatabaseHelper.sendMessageWithNotification(
        chatId: widget.chatId,
        senderId: widget.loggedInUserId,
        message: messageText,
        senderName: senderName,
        recipientId: recipientId,
        senderImage: senderImage,
      );
      _messageController.clear();
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e'))
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _markMessagesAsRead() async {
    await DatabaseHelper.markChatAsRead(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChatsHomePage()),
          (route) => false,
        );
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadMessages,
                  color: const Color(0xFF6296FF),
                  child: _buildMessageList(),
                ),
              ),
              _buildSessionStatus(),
              _buildMessageInput(),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(85),
      child: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6296FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            // Navigate to ChatsHomePage when back button is pressed
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChatsHomePage()),
              (route) => false,
            );
          },
        ),
        title: FutureBuilder<Map<String, dynamic>>(
          future: _loadSessionAndSkill(),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                // Only navigate if we have session data
                if (snapshot.hasData && snapshot.data != null) {
                  final sessionData = snapshot.data!['session'];
                  int otherUserId;
                  
                  // Determine which user ID to use based on who is logged in
                  if (sessionData['provider_id'] == widget.loggedInUserId) {
                    // If logged-in user is the provider, navigate to requester's profile
                    otherUserId = sessionData['requester_id'];
                  } else {
                    // If logged-in user is the requester, navigate to provider's profile
                    otherUserId = sessionData['provider_id'];
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPage(userId: otherUserId),
                    ),
                  );
                } else {
                  // Show loading message if session data isn't available yet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Loading user data...'))
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.otherUsername,
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.person_outline,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    Text(
                      'Loading...',
                      style: GoogleFonts.mulish(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    )
                  else if (snapshot.hasError)
                    Text(
                      'Error loading skill info',
                      style: GoogleFonts.mulish(
                        color: Colors.red[100],
                        fontSize: 14,
                      ),
                    )
                  else
                    Text(
                      snapshot.data?['skillName'] ?? 'Unknown Skill',
                      style: GoogleFonts.mulish(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadMessages,
            tooltip: 'Refresh messages',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF6296FF)),
            ),
          )
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF6296FF)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading messages\nPull to refresh',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              final messagesList = snapshot.data ?? [];
              if (messagesList.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet\nStart the conversation!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  final message = messagesList[index];
                  final bool isSentByUser = message['sender_id'].toString() == widget.loggedInUserId.toString();
                  final bool isNextSameSender = index > 0 &&
                      messagesList[index - 1]['sender_id'].toString() == message['sender_id'].toString();
                  final bool isPrevSameSender = index < messagesList.length - 1 &&
                      messagesList[index + 1]['sender_id'].toString() == message['sender_id'].toString();

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isPrevSameSender ? 4 : 12,
                      top: isNextSameSender ? 4 : 12,
                    ),
                    child: _buildMessageBubble(message, isSentByUser),
                  );
                },
              );
            },
          );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isSentByUser) {
    if (message['sender_id'] == -1) {
      return _buildSystemMessage(message);
    }

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: isSentByUser ? 50 : 0,
          right: isSentByUser ? 0 : 50,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSentByUser
              ? const Color(0xFF6296FF)
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isSentByUser ? 20 : 5),
            bottomRight: Radius.circular(isSentByUser ? 5 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          message['message'],
          style: GoogleFonts.mulish(
            color: isSentByUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildSystemMessage(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message['message'],
            style: GoogleFonts.mulish(
              color: Colors.black54,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionStatus() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF6296FF)),
            ),
          );
        }
        if (snapshot.hasData) {
          return _buildStateButton(snapshot.data!['status'], snapshot.data!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStateButton(String status, Map<String, dynamic> session) {
    if (session['provider_id'] == widget.loggedInUserId) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Text(
          "You are providing this service",
          textAlign: TextAlign.center,
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6296FF),
          ),
        ),
      );
    }

    switch (status) {
      case 'Idle':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () => _handleServiceRequest(session),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6296FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.handshake_outlined, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Request Service',
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'Pending':
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleServiceComplete(session),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Complete',
                        style: GoogleFonts.mulish(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleServiceCancel(session),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cancel_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Cancel',
                        style: GoogleFonts.mulish(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleServiceRequest(Map<String, dynamic> session) async {
    try {
      bool? result = await RequestService(session: session)
          .showRequestDialog(context);
      if (result == true) {
        await DatabaseHelper.sendMessage(
          widget.chatId,
          -1,
          'The Service was Requested!',
        );
        setState(() {
          _loadSession();
          _loadMessages();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request service: $e'))
      );
    }
  }

  Future<void> _handleServiceComplete(Map<String, dynamic> session) async {
    try {
      bool? result = await CompleteService(session: session)
          .showFinalizeDialog(context);
      if (result == true) {
        await DatabaseHelper.sendMessage(
          widget.chatId,
          -1,
          'The Service was Completed!',
        );
        setState(() {
          _loadSession();
          _loadMessages();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete service: $e'))
      );
    }
  }

  Future<void> _handleServiceCancel(Map<String, dynamic> session) async {
    try {
      bool? result = await CancelService(session: session)
          .showFinalizeDialog(context);
      if (result == true) {
        await DatabaseHelper.sendMessage(
          widget.chatId,
          -1,
          'The Service was Cancelled!',
        );
        setState(() {
          _loadSession();
          _loadMessages();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel service: $e'))
      );
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.mulish(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: GoogleFonts.mulish(),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF6296FF),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _handleSendMessage,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _loadSession() async {
    try {
      final response = await DatabaseHelper.fetchSessionFromChat(widget.chatId);
      if (!response.success) throw Exception('Failed to fetch session');
      return response.data;
    } catch (err) {
      throw Exception('Error loading session: $err');
    }
  }

  Future<Map<String, dynamic>> _loadSessionAndSkill() async {
    try {
      final sessionResponse = await DatabaseHelper.fetchSessionFromChat(widget.chatId);
      if (!sessionResponse.success) throw Exception('Failed to fetch session');

      final skillResponse = await DatabaseHelper.fetchOneSkill(sessionResponse.data['skill_id']);
      if (skillResponse.isEmpty) throw Exception('Failed to fetch skill');

      return {
        'skillName': skillResponse['name'],
        'session': sessionResponse.data
      };
    } catch (err) {
      throw Exception('Error loading data: $err');
    }
  }
}
