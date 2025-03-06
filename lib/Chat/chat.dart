import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/Chat/chatSessionUtil.dart';
import '../database/database.dart';

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
    _loadMessages();
    // Set up periodic refresh every 10 seconds
    _startPeriodicRefresh();
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
      messages = DatabaseHelper.fetchMessages(widget.chatId);
      
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages: $e'))
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleSendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await DatabaseHelper.sendMessage(
        widget.chatId,
        widget.loggedInUserId,
        messageText,
      );
      _messageController.clear();
      await _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e'))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherUsername,
              style: GoogleFonts.mulish(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _loadSessionAndSkill(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Loading...',
                    style: GoogleFonts.mulish(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error loading skill info',
                    style: GoogleFonts.mulish(
                      color: Colors.red[100],
                      fontSize: 14,
                    ),
                  );
                }
                final skillName = snapshot.data?['skillName'] ?? 'Unknown Skill';
                return Text(
                  skillName,
                  style: GoogleFonts.mulish(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ],
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

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data![index];
                  final bool isSentByUser = message['sender_id'] == widget.loggedInUserId;
                  final bool isNextSameSender = index > 0 &&
                      snapshot.data![index - 1]['sender_id'] == message['sender_id'];
                  final bool isPrevSameSender = index < snapshot.data!.length - 1 &&
                      snapshot.data![index + 1]['sender_id'] == message['sender_id'];

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
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.handshake_outlined),
            onPressed: () => _handleServiceRequest(session),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6296FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            label: Text(
              'Request Service',
              style: GoogleFonts.mulish(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case 'Pending':
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => _handleServiceComplete(session),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  'Complete',
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () => _handleServiceCancel(session),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  'Cancel',
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
