import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AiServices {
  static late String _apiUrl;
  static late String _apiKey;

  // Método para inicializar las variables de entorno
  static void init() {
    _apiUrl = dotenv.env['BASE_URL'] ?? '';
    _apiKey = dotenv.env['AI_API_KEY'] ?? '';

    if (_apiUrl.isEmpty || _apiKey.isEmpty) {
      throw Exception(
        "Error: Variables de entorno no definidas correctamente.",
      );
    }
  }

  static Future<String> generateCode(String description) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-r1:free",
          "messages": [
            {
              "role": "system",
              "content":
                  "Eres un asistente de inteligencia artificial capaz de responder preguntas sobre diversos temas, incluyendo Flutter y programación en general. Puedes generar código, resolver dudas y conversar sobre diferentes temas.",
            },
            {"role": "user", "content": description},
          ],
          "max_tokens": 800,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        return data["choices"][0]["message"]["content"];
      } else if (response.statusCode == 429) {
        final data = jsonDecode(response.body);
        return 'Error: Código: ${response.statusCode} - ${data['error']['message']}.';
      } else {
        return 'Error: No se pudo generar el código. Código: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
