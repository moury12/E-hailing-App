class ChatMessage {
  final String content;
  final String time;
  final bool isFromDriver;
  final bool isTyping;

  ChatMessage({
    required this.content,
    required this.time,
    required this.isFromDriver,
    this.isTyping = false,
  });
}