import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  String _getStabilizedText() {
    String txt = message.text;
    if (message.isStreaming) {
      final int backticks = '```'.allMatches(txt).length;
      if (backticks % 2 != 0) {
        txt += '\n```';
      }
      txt += ' █';
    }
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Header Label
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!message.isUser) ...[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_outlined, size: 16, color: Color(0xFF00F2FF)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI WRITER',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ] else ...[
                  Text(
                    'YOU',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC7rDapaQ2mO8Zf4hoU7j5azZYeEz200aRXaudEIaRLxgGNCcFReFviSS4gpn_lf2FXYZl-mQSClINgWVil6xwP-KAE1YyDiqr9Vrjrov195Dr5Jg3NgCveGivIHKOY_uBpaXLL5E2AhMjxAQZVo3Z3g4lzgUbhtp5nDbw7hpetqfSCXsIOogLzRr-1j3W095lmBORcBqDLwnSdGvaQLF-6TVOW0NJhBqfAH8MY9ryKsu98Gv5wBLo5w6xbe6B6LLVQlrh7whRpFFW2'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Bubble Content
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              alignment: message.isUser ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: message.isUser ? null : const Color(0xFF1E1E1E),
                  gradient: message.isUser 
                      ? const LinearGradient(
                          colors: [Color(0xFF00F2FF), Color(0xFF0088FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
                    bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
                  ),
                  border: message.isUser ? null : Border(
                    left: BorderSide(color: const Color(0xFF00F2FF).withValues(alpha: 0.2), width: 2),
                  ),
                  boxShadow: message.isUser ? [
                    BoxShadow(
                      color: const Color(0xFF0088FF).withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ] : [],
                ),
                child: message.isUser
                    ? Text(
                        message.text,
                        style: GoogleFonts.manrope(
                          fontSize: 15, 
                          color: Colors.black, 
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      )
                    : MarkdownBody(
                        data: _getStabilizedText(),
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.manrope(
                            fontSize: 15, 
                            color: const Color(0xFFE2E2E2), 
                            height: 1.6,
                          ),
                          code: GoogleFonts.spaceGrotesk(
                            backgroundColor: const Color(0xFF121212),
                            color: const Color(0xFF00F2FF),
                            fontSize: 14,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: const Color(0xFF121212),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          strong: const TextStyle(color: Color(0xFF00F2FF), fontWeight: FontWeight.bold),
                          em: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
