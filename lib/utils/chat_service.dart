import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static String baseUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';

  // get current user email
  Future<String?> _getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  // send a message
  Future<Map<String, dynamic>> sendMessage({
    required String toEmail,
    required String text,
    String? productId,
  }) async {
    try {
      final fromEmail = await _getUserEmail();
      if (fromEmail == null) {
        return {'success': false, 'message': 'user not logged in'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/chat/send?email=$fromEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'toEmail': toEmail,
          'text': text,
          if (productId != null) 'product': productId,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // get all chats for current user
  Future<Map<String, dynamic>> getUserChats({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final email = await _getUserEmail();
      if (email == null) {
        return {'success': false, 'message': 'user not logged in'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/chat/list?email=$email&page=$page&limit=$limit'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // get messages in a specific chat
  Future<Map<String, dynamic>> getChatMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat/$chatId/messages?page=$page&limit=$limit'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // delete a message
  Future<Map<String, dynamic>> deleteMessage(String messageId) async {
    try {
      final email = await _getUserEmail();
      if (email == null) {
        return {'success': false, 'message': 'user not logged in'};
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/chat/message/$messageId?email=$email'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // block a chat
  Future<Map<String, dynamic>> blockChat(String chatId) async {
    try {
      final email = await _getUserEmail();
      if (email == null) {
        return {'success': false, 'message': 'user not logged in'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/chat/$chatId/block?email=$email'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // unblock a chat
  Future<Map<String, dynamic>> unblockChat(String chatId) async {
    try {
      final email = await _getUserEmail();
      if (email == null) {
        return {'success': false, 'message': 'user not logged in'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/chat/$chatId/unblock?email=$email'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}