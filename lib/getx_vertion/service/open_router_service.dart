import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = "YOUR_OPENROUTER_KEY";
  static const String _apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4.1-mini",
        "messages": [
          {"role": "system", "content": "You are a helpful AI Assistant."},
          {"role": "user", "content": message},
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? "No response";
    } else {
      return "API Error: ${response.statusCode}";
    }
  }
}