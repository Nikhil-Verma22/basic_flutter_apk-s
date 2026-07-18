import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    _textController.clear();
    context.read<ChatProvider>().sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF00F2FF)),
                onPressed: () {},
              ),
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00F2FF), Color(0xFF56D5FA)],
                ).createShader(bounds),
                child: Text(
                  'DEEPSITE',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00F2FF).withValues(alpha: 0.3), width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCLPvL7E5nawV9LKoxhrc4TtGbjzC1jy4tgD4b_ddIddw1MIY_W_QoN05p96nDoPea2cdrkD2Z3n2eh5NIa8MZAC69kt-zWony46OkK-XzxE0PDFsqJ9mO8nbGu9Hs6DObj4JxdINMtmVO-1c_rngBZQZc-1oSfrqj4u6v1CRnIu-wu6G7b0zS7i_9dxfebBRTQcYoMylYG60xp1gtZUQG--2u3dRG9oCt9aPwWomMThq1Km_70KqqSTA1zv0Xpj7mdc6J9vkUd_f8Q'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty && chatProvider.activeMessageNode.value == null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, size: 48, color: Color(0xFF00F2FF)),
                        const SizedBox(height: 16),
                        Text(
                          'How can I help you today?',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 120),
                  itemCount: chatProvider.messages.length + (chatProvider.activeMessageNode.value != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (chatProvider.activeMessageNode.value != null) {
                      if (index == 0) {
                        return ValueListenableBuilder<ChatMessage?>(
                          valueListenable: chatProvider.activeMessageNode,
                          builder: (context, activeMsg, child) {
                            if (activeMsg == null) return const SizedBox.shrink();
                            return MessageBubble(message: activeMsg);
                          },
                        );
                      }
                      return MessageBubble(message: chatProvider.messages[index - 1]);
                    }
                    return MessageBubble(message: chatProvider.messages[index]);
                  },
                );
              },
            ),
          ),
          
          // Bottom Input Area with Futuristic Styling
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF121212).withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F2FF).withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF333333),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            maxLines: 5,
                            minLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                            style: GoogleFonts.manrope(fontSize: 15, color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.manrope(color: Colors.grey.shade600),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<ChatProvider>(
                        builder: (context, provider, child) {
                          final isStreaming = provider.activeMessageNode.value != null;
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00F2FF), Color(0xFF0088FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00F2FF).withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(isStreaming ? Icons.stop_rounded : Icons.send_rounded, color: Colors.black),
                              onPressed: isStreaming ? provider.stopCurrentStream : _sendMessage,
                            ),
                          );
                        },
                      ),
                    ],
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
