import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  // TODO: Replace with your actual Gemini API Key
  static const String _apiKey = 'AIzaSyAQG3tNFZN3g-NKiYfs8oQTIrFd35bGcaE';
  
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  GeminiService() {
    // We remain on the model version chosen by the user
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: _apiKey,
    );
    _chatSession = _model.startChat();
  }

  /// Sends a message and returns the response as a continuous stream of strings.
  Stream<String> sendMessageStream(String message) async* {
    if (_chatSession == null) {
      yield 'Error: Chat session not initialized.';
      return;
    }

    try {
      final responseStream = _chatSession!.sendMessageStream(Content.text(message));
      await for (final chunk in responseStream) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      debugPrint('Error interacting with Gemini API: $e');
      yield '\n\n**Error connecting to AI:** $e';
      throw Exception('Stream Failed');
    }
  }
}
