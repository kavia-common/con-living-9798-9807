import 'dart:convert';

import 'package:con_living_frontend/model/rasa_webhook_request.dart';
import 'package:con_living_frontend/model/rasa_webhook_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// A lightweight Rasa REST client.
///
/// Expects an environment variable in `.env`:
/// - `RASA_BASE_URL` (example: `http://10.0.2.2:5005` for Android emulator)
///
/// Endpoint used:
/// - POST `{RASA_BASE_URL}/webhooks/rest/webhook`
///
/// This client is intentionally small and UI-agnostic; it can be used later
/// by providers/view-models.
class RasaClient {
  final http.Client _httpClient;
  final Uri _webhookUri;

  /// Create a RasaClient.
  ///
  /// If [baseUrl] is not provided, it will be loaded from `.env` via
  /// `RASA_BASE_URL`.
  RasaClient({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _webhookUri = Uri.parse(
          _normalizeBaseUrl(baseUrl ?? dotenv.env['RASA_BASE_URL']) +
              '/webhooks/rest/webhook',
        );

  static String _normalizeBaseUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      throw StateError(
        'Missing RASA_BASE_URL. Please set RASA_BASE_URL in the .env file.',
      );
    }
    // Remove trailing slashes for consistent concatenation.
    return raw.trim().replaceAll(RegExp(r'/*$'), '');
  }

  // PUBLIC_INTERFACE
  Future<List<RasaWebhookResponse>> sendMessage({
    required String message,
    String? sender,
  }) async {
    /// Send a message to Rasa and parse the list of assistant responses.
    ///
    /// Params:
    /// - [message]: the user message text
    /// - [sender]: optional sender/session id for conversation tracking
    ///
    /// Returns: list of [RasaWebhookResponse] items.
    final request = RasaWebhookRequest(message: message, sender: sender);

    final response = await _httpClient.post(
      _webhookUri,
      headers: const <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Rasa webhook call failed: ${response.statusCode} ${response.reasonPhrase}. '
        'Body: ${response.body}',
        _webhookUri,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException(
        'Unexpected Rasa response format: expected a JSON list.',
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(RasaWebhookResponse.fromJson)
        .toList(growable: false);
  }

  // PUBLIC_INTERFACE
  void dispose() {
    /// Dispose the underlying HTTP client.
    _httpClient.close();
  }
}
