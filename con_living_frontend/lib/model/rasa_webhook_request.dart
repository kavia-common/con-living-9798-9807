/// Model for requests sent to a Rasa REST webhook.
///
/// Typically posted to: `{RASA_BASE_URL}/webhooks/rest/webhook`.
class RasaWebhookRequest {
  /// The message text from the user.
  final String message;

  /// Optional sender identifier (user id / session id) used by Rasa to keep a
  /// conversation context.
  final String? sender;

  const RasaWebhookRequest({
    required this.message,
    this.sender,
  });

  /// Convert this model to JSON for Rasa REST API.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      if (sender != null) 'sender': sender,
    };
  }
}
