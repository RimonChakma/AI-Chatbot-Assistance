import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import '../controllers/chat_controller.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final TextEditingController textController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    void scrollToBottom() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    return Scaffold(
      body: Obx(() => Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: controller.messages.length +
                  (controller.isLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.messages.length &&
                    controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Typing...",
                        style: TextStyle(color: Colors.white)),
                  );
                }

                final message = controller.messages[index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.blue
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: message.isUser
                        ? Text(message.content,
                        style: const TextStyle(color: Colors.white))
                        : GptMarkdown(message.content,
                        style:
                        const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type message",
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  controller.sendMessage(textController.text);
                  textController.clear();
                  scrollToBottom();
                },
              )
            ],
          )
        ],
      )),
    );
  }
}