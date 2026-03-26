import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey;
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  ChatService({required this.apiKey});

  // Stream for real-time AI responses
  Stream<String> sendMessageStream(String message) async* {
    final request = http.Request('POST', Uri.parse(baseUrl));
    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://your-app-name.com', // Replace with your app
      'X-Title': 'CHAINET',
    });

    request.body = json.encode({
      'model': 'meta-llama/llama-3-8b-instruct:nitro', // Free model
      'messages': [
        {
          'role': 'system',
          'content':
          'You are a helpful farming assistant for tea farmers in Kenya. Provide practical advice about tea farming, weather, pests, and market prices. Keep responses concise and friendly.'
        },
        {'role': 'user', 'content': message}
      ],
      'stream': true,
    });

    final response = await request.send();
    print('Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();
      print('Error body: $errorBody');
      throw Exception('Failed to get response: $response.statusCode');
    }

    await for (var chunk
    in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (chunk.startsWith('data: ')) {
        final data = chunk.substring(6);
        if (data == '[DONE]') break;

        try {
          final jsonData = json.decode(data);
          final content = jsonData['choices'][0]['delta']['content'];
          if (content != null) {
            yield content;
          }
        } catch (e) {
          // Ignore parsing errors for incomplete chunks
        }
      }
    }
  }
}