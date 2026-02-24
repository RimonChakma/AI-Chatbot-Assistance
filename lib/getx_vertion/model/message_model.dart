class MessageModel {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String id;

  MessageModel({
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.id,
  });
}