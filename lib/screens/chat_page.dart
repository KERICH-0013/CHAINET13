import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_controller.dart';
import '../services/chat_service.dart';
import 'pest_detection_page.dart'; // <-- already added

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(
        chatService: ChatService(
          apiKey: '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',
        ),
      ),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatController>(context);
    final textController = TextEditingController();
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Assistant'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PestDetectionPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => controller.clearChat(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chatbot.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),

            // Loading indicator
            if (controller.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),

            // Input area
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Ask about tea farming...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(
                        context,
                        textController,
                        scrollController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.green.shade800,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(
                        context,
                        textController,
                        scrollController,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 New button for Pest Detection
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PestDetectionPage()),
                  );
                },
                icon: const Icon(Icons.bug_report),
                label: const Text('Pest & Disease Detection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48), // full width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(
      BuildContext context,
      TextEditingController controller,
      ScrollController scrollController,
      ) {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final chatController = Provider.of<ChatController>(
      context,
      listen: false,
    );

    controller.clear();
    chatController.sendMessage(text);

    // Scroll to bottom after message is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.smart_toy, size: 20, color: Colors.green),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.green.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.text.isEmpty && !message.isUser
                    ? 'Thinking...'
                    : message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}