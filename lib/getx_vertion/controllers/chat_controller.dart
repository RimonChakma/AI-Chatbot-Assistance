import 'dart:math';
import 'package:get/get.dart';

import '../model/message_model.dart';
import '../service/open_router_service.dart';


class ChatController extends GetxController {
  final OpenRouterService _service;

  ChatController(this._service);

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    messages.add(
      MessageModel(
        content:
        "Hello I am your AI assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
        id: _generateId(),
      ),
    );
    super.onInit();
  }

  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(
      MessageModel(
        content: text,
        isUser: true,
        timestamp: DateTime.now(),
        id: _generateId(),
      ),
    );

    isLoading.value = true;

    final response = await _service.sendMessage(text);

    messages.add(
      MessageModel(
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
        id: _generateId(),
      ),
    );

    isLoading.value = false;
  }
}