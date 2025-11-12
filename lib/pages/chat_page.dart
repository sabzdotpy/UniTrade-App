import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:test_flutter/utils/chat_service.dart';
import 'package:test_flutter/utils/chat.dart';
import 'package:test_flutter/utils/chat_message.dart';

class ChatPage extends StatefulWidget {
  final String sellerName;
  final String sellerProfilePic;
  final String sellerEmail;
  final String? productId;

  const ChatPage({
    super.key,
    required this.sellerName,
    required this.sellerProfilePic,
    required this.sellerEmail,
    this.productId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  
  List<ChatMessage> messages = [];
  String? chatId;
  bool isLoading = true;
  bool isSending = false;
  bool isRefreshing = false;
  Timer? _refreshTimer;
  String? currentUserEmail;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
    currentUserId = user?.uid;
    await _loadOrCreateChat();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (chatId != null && mounted) {
        _refreshMessages();
      }
    });
  }

  Future<void> _loadOrCreateChat() async {
    setState(() {
      isLoading = true;
    });

    try {
      // first try to get existing chats
      final chatsResult = await _chatService.getUserChats(page: 1, limit: 100);
      
      if (chatsResult['success']) {
        print("Fetched user chats successfully");
        print("Raw chat data: ${chatsResult['data']}");
        
        final chats = (chatsResult['data'] as List)
            .map((c) => Chat.fromJson(c))
            .toList();
        
        print("Parsed ${chats.length} chats");
        print("Looking for seller email: ${widget.sellerEmail}");
        
        // find chat with this seller
        Chat? existingChat;
        for (var chat in chats) {
          print("Chat participants: ${chat.participants}");
          if (chat.participants.contains(widget.sellerEmail)) {
            existingChat = chat;
            break;
          }
        }
        
        if (existingChat != null && existingChat.id.isNotEmpty) {
          print("Found existing chat: ${existingChat.id}");
          chatId = existingChat.id;
          await _loadMessages();
        } else {
          print("No existing chat found, starting fresh");
          // no existing chat, messages will be empty
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("Failed to fetch chats: ${chatsResult['message']}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print("Error loading or creating chat");
      print("Error: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error loading chat: ${e.toString()}\n\nCheck console for stack trace'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _loadMessages() async {
    if (chatId == null) return;

    try {
      final messagesResult = await _chatService.getChatMessages(
        chatId: chatId!,
        page: 1,
        limit: 100,
      );

      if (messagesResult['success']) {
        final fetchedMessages = (messagesResult['data'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList();
        
        setState(() {
          messages = fetchedMessages.reversed.toList(); // reverse to show newest at bottom
          isLoading = false;
        });

        _scrollToBottom();
      }
    } catch (e, stackTrace) {
      print("Error loading messages");
      print("Error: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshMessages() async {
    if (chatId == null || isRefreshing) return;

    setState(() {
      isRefreshing = true;
    });

    try {
      final messagesResult = await _chatService.getChatMessages(
        chatId: chatId!,
        page: 1,
        limit: 100,
      );

      if (messagesResult['success']) {
        final fetchedMessages = (messagesResult['data'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList();
        
        // remove optimistic messages before updating with server data
        final serverMessageIds = fetchedMessages.map((m) => m.id).toSet();
        messages.removeWhere((m) => m.id.startsWith('temp_') && !serverMessageIds.contains(m.id));
        
        setState(() {
          messages = fetchedMessages.reversed.toList();
        });
      }
    } catch (e, stackTrace) {
      print("Error refreshing messages");
      print("Error: $e");
      print("Stack trace: $stackTrace");
      // silent fail for auto refresh
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || isSending) return;
    
    final messageText = _messageController.text.trim();
    _messageController.clear();
    
    // create optimistic message
    final optimisticMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: messageText,
      productId: widget.productId,
      isDeleted: false,
      sentBy: currentUserEmail ?? currentUserId ?? '',
      sentFor: widget.sellerEmail,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // optimistically add message to UI
    setState(() {
      messages.insert(0, optimisticMessage);
      isSending = true;
    });
    
    // scroll to show new message
    _scrollToBottom();

    try {
      final result = await _chatService.sendMessage(
        toEmail: widget.sellerEmail,
        text: messageText,
        productId: widget.productId,
      );

      if (result['success']) {
        // if this was first message, get the chat id
        if (chatId == null && result['chatId'] != null) {
          chatId = result['chatId'];
        }
        
        // reload messages to get the real message from server
        await _loadMessages();
      } else {
        // remove optimistic message on failure
        setState(() {
          messages.removeWhere((m) => m.id == optimisticMessage.id);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('failed to send: ${result['message']}')),
          );
        }
      }
    } catch (e, stackTrace) {
      print("Error sending message");
      print("Error: $e");
      print("Stack trace: $stackTrace");
      
      // remove optimistic message on error
      setState(() {
        messages.removeWhere((m) => m.id == optimisticMessage.id);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error sending message: ${e.toString()}\n\nCheck console for details'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        isSending = false;
      });
    }
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color.fromARGB(255, 89, 89, 89),
              backgroundImage: CachedNetworkImageProvider(widget.sellerProfilePic),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.sellerName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
          IconButton(
            icon: const Icon(Icons.flag_outlined, size: 22),
            onPressed: () {
              if (chatId != null) {
                _showBlockDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('no active chat to report')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
          children: [
            if (messages.isEmpty)
              Expanded(
                child: Center(
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
                        'no messages yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'start the conversation',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    // compare by both email and id since backend might return either
                    final isSelf = message.sentBy == currentUserEmail || 
                                   message.sentBy == currentUserId;
                    final isOptimistic = message.id.startsWith('temp_');
                    
                    if (message.isDeleted) {
                      return Align(
                        alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'message deleted',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, (1 - value) * 50),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: isSelf && !isOptimistic ? () => _showDeleteDialog(message.id) : null,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelf 
                                ? (isOptimistic 
                                    ? const Color.fromARGB(255, 0, 122, 255).withOpacity(0.7)
                                    : const Color.fromARGB(255, 0, 122, 255))
                                : const Color.fromARGB(255, 50, 50, 50),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    message.text ?? '',
                                    style: TextStyle(
                                      color: isSelf ? Colors.white : Colors.white.withOpacity(0.95),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (isOptimistic) ...[
                                  const SizedBox(width: 8),
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                      radius: 6,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 40, 40, 40),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'message...',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 15),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: isSending ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSending 
                          ? const Color.fromARGB(255, 0, 122, 255).withOpacity(0.5)
                          : const Color.fromARGB(255, 0, 122, 255),
                        shape: BoxShape.circle,
                      ),
                      child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CupertinoActivityIndicator(color: Colors.white),
                          )
                        : const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('delete message'),
        content: const Text('are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _chatService.deleteMessage(messageId);
              if (result['success']) {
                await _loadMessages();
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('failed to delete: ${result['message']}')),
                  );
                }
              }
            },
            child: const Text('delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('block chat'),
        content: const Text('are you sure you want to block this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (chatId != null) {
                final result = await _chatService.blockChat(chatId!);
                if (result['success']) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('chat blocked')),
                    );
                    Navigator.pop(context);
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('failed to block: ${result['message']}')),
                    );
                  }
                }
              }
            },
            child: const Text('block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
