import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'message.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [];
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  static const String _apiKey =
      "YOUR_API_KEY"; // Replace with your OpenRouter API key
  static const String _apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _messages.add(
      Message(
        content: "Hello I am your AI assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
        id: _generateId(),
      ),
    );
  }

  String _generateId() {
    return DateTime
        .now()
        .microsecondsSinceEpoch
        .toString() +
        Random().nextInt(1000).toString();
  }

  Future<String> _callOpenRouterApi(String message) async {
    final headers = {
      "Authorization": "Bearer $_apiKey",
      "Content-Type": "application/json",
      "HTTP-Referer": "",
      "X-Title": "AI Chat Assistant",
    };

    final body = jsonEncode({
      "model": "deepseek/deepseek-r1:free",
      "messages": [
        {"role": "system", "content": "you are a helpful AI Assistant."},
        {"role": "user", "content": message},
      ],
      "max_tokens": 2000,
      "temperature": 0.7,
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content'] ?? "No response";
      } else {
        return "No response from AI.";
      }
    } else {
      return "API Error: ${response.statusCode}";
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

  void _sendMessage() async {
    if (_messageController.text
        .trim()
        .isEmpty) return;

    final userMessage = _messageController.text.trim();

    setState(() {
      _messages.add(
        Message(
          content: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
          id: _generateId(),
        ),
      );
      _messageController.clear();
      isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _callOpenRouterApi(userMessage);
      setState(() {
        _messages.add(
          Message(
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
            id: _generateId(),
          ),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            content:
            "Sorry, I couldn't process your request. Please try again.",
            isUser: false,
            timestamp: DateTime.now(),
            id: _generateId(),
          ),
        );
        isLoading = false;
      });
    }

    _scrollToBottom();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)])
              : LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
          borderRadius: BorderRadius.circular(16)
      ),
      child: Icon(isUser ? Icons.person : Icons.smart_toy, color: Colors.white,
        size: 16,),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animationController, builder: (context, child) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3 +
                (sin(_animationController.value * 2 * pi + index * 0.5) * 0.3)),
          borderRadius: BorderRadius.circular(4)
        ),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}
