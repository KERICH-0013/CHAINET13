import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatController extends ChangeNotifier {
  final ChatService _chatService;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatController({required ChatService chatService}) : _chatService = chatService;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();

    // Placeholder for AI response
    _isLoading = true;
    final aiMessage = ChatMessage(text: '', isUser: false);
    _messages.add(aiMessage);
    notifyListeners();

    try {
      final buffer = StringBuffer();
      await for (final chunk in _chatService.sendMessageStream(text)) {
        print('Received chunk: $chunk'); // ADD THIS
        buffer.write(chunk);
        aiMessage.text = buffer.toString();
        notifyListeners();
      }
    } catch (e) {
      print('Error in sendMessage: $e'); // ADD THIS
      aiMessage.text = 'Sorry, I encountered an error. Please try again.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}

class ChatMessage {
  String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
  }) : timestamp = DateTime.now();
}