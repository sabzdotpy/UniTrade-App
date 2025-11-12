import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:test_flutter/utils/chat_service.dart';
import 'package:test_flutter/utils/chat.dart';
import 'package:test_flutter/pages/chat_page.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final ChatService _chatService = ChatService();
  List<Chat> chats = [];
  bool isLoading = true;
  bool isRefreshing = false;
  String? currentUserEmail;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
    await _loadChats();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _refreshChats();
      }
    });
  }

  Future<void> _loadChats() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _chatService.getUserChats(page: 1, limit: 100);
      
      if (result['success']) {
        final fetchedChats = (result['data'] as List)
            .map((c) => Chat.fromJson(c))
            .toList();
        
        setState(() {
          chats = fetchedChats;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print("error loading chats");
      print("error: $e");
      print("stack trace: $stackTrace");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshChats() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
    });

    try {
      final result = await _chatService.getUserChats(page: 1, limit: 100);
      
      if (result['success']) {
        final fetchedChats = (result['data'] as List)
            .map((c) => Chat.fromJson(c))
            .toList();
        
        if (mounted) {
          setState(() {
            chats = fetchedChats;
          });
        }
      }
    } catch (e, stackTrace) {
      print("error refreshing chats");
      print("error: $e");
      print("stack trace: $stackTrace");
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _getOtherParticipant(List<String> participants) {
    // find the participant that is not the current user
    for (var participant in participants) {
      if (participant != currentUserEmail) {
        return participant;
      }
    }
    return participants.isNotEmpty ? participants[0] : 'unknown';
  }

  String _getLastMessagePreview(Chat chat) {
    if (chat.messages.isEmpty) {
      return 'no messages yet';
    }
    // since messages are IDs, we can't show preview
    // in real app you'd need to fetch message details or include text in chat object
    return 'tap to view messages';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'messages',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          AnimatedOpacity(
            opacity: isRefreshing ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 122, 255),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 122, 255).withOpacity(0.6),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no conversations yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'start messaging sellers',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshChats,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chats.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 80,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final otherParticipant = _getOtherParticipant(chat.participants);
                      final lastMessage = _getLastMessagePreview(chat);
                      final isBlocked = chat.status == 'blocked';
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color.fromARGB(255, 89, 89, 89),
                          child: Text(
                            otherParticipant.isNotEmpty 
                                ? otherParticipant[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                otherParticipant,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isBlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'blocked',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            lastMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onTap: isBlocked
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('this chat is blocked'),
                                  ),
                                );
                              }
                            : () async {
                                // navigate to chat page
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      sellerName: otherParticipant,
                                      sellerProfilePic: '', // placeholder
                                      sellerEmail: otherParticipant,
                                    ),
                                  ),
                                );
                                // refresh after returning from chat
                                _loadChats();
                              },
                      );
                    },
                  ),
                ),
    );
  }
}
