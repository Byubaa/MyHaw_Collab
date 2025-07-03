import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  final GeminiService _gemini = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Menambahkan pesan selamat datang awal dari asisten
    _messages.add(
      ChatMessage(
        id: _uuid.v4(),
        text: "Halo! Saya Asisten Pulsa. Ada yang bisa saya bantu terkait penggunaan aplikasi ini?",
        isFromUser: false,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage({String? text}) async {
    final messageText = text ?? _controller.text;
    if (messageText.isEmpty) return;

    _controller.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(id: _uuid.v4(), text: messageText, isFromUser: true));
      _messages.add(ChatMessage(id: _uuid.v4(), text: '...', isFromUser: false, isTyping: true));
    });

    _scrollToBottom();

    try {
      final response = await _gemini.sendMessage(messageText);
      setState(() {
        _messages.removeWhere((msg) => msg.isTyping);
        _messages.add(ChatMessage(id: _uuid.v4(), text: response, isFromUser: false));
      });
    } catch (_) {
      setState(() {
        _messages.removeWhere((msg) => msg.isTyping);
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: "Terjadi kesalahan, coba lagi.",
          isFromUser: false,
          isError: true,
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Customer Service'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (_, i) => MessageBubble(message: _messages[i]),
            ),
          ),
          // Jika belum ada percakapan, tampilkan saran
          if (_messages.length <= 1) _buildSuggestionChips(),
          MessageInputBar(
            controller: _controller,
            isLoading: _isLoading,
            onSend: () => _sendMessage(),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan chip saran
  Widget _buildSuggestionChips() {
    final suggestions = [
      'Cara beli pulsa',
      'Berapa biaya admin?',
      'Provider apa saja?',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Wrap(
        spacing: 8.0,
        children: suggestions.map((text) {
          return ActionChip(
            label: Text(text),
            onPressed: () => _sendMessage(text: text),
          );
        }).toList(),
      ),
    );
  }
}