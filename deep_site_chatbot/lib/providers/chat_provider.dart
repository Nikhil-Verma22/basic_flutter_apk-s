import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  
  // Stores completed messages. Newest message is at index 0 (for reverse ListView)
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // Expose an isolated notifier for the currently streaming message
  // to prevent entire ListView rebuilds.
  final ValueNotifier<ChatMessage?> activeMessageNode = ValueNotifier(null);
  
  StreamSubscription<String>? _activeSubscription;

  /// Stops current generation if any
  void stopCurrentStream() {
    _activeSubscription?.cancel();
    _activeSubscription = null;
    
    // Commit interrupted message to history
    if (activeMessageNode.value != null) {
      _messages.insert(0, activeMessageNode.value!.copyWith(isStreaming: false));
      activeMessageNode.value = null;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Stop existing stream if user sends rapid messages
    stopCurrentStream();

    // 1. Commit user message to top of history (index 0)
    _messages.insert(0, ChatMessage(text: text, isUser: true));
    notifyListeners();

    // 2. Initialize an empty AI message in the active node
    var currentAiMessage = ChatMessage(text: '', isUser: false, isStreaming: true);
    activeMessageNode.value = currentAiMessage;

    // 3. Start reading the stream
    final stream = _geminiService.sendMessageStream(text);
    
    _activeSubscription = stream.listen(
      (chunk) {
        // Update the isolated notifier (triggers ValueListenableBuilder natively fast)
        currentAiMessage = currentAiMessage.copyWith(text: currentAiMessage.text + chunk);
        activeMessageNode.value = currentAiMessage;
      },
      onError: (error) {
        currentAiMessage = currentAiMessage.copyWith(
          hasError: true, 
          isStreaming: false,
          text: currentAiMessage.text + '\n\n**Generation failed:** Network interrupted.'
        );
        _messages.insert(0, currentAiMessage);
        activeMessageNode.value = null;
        notifyListeners();
      },
      onDone: () {
        // Stream completed naturally
        if (activeMessageNode.value != null) {
          _messages.insert(0, currentAiMessage.copyWith(isStreaming: false));
          activeMessageNode.value = null;
          notifyListeners();
        }
      },
    );
  }
}
