/// A single message item returned from the Rasa REST webhook.
///
/// Rasa commonly returns a list of objects like:
/// `{ "recipient_id": "...", "text": "...", "image": "...", "buttons": [...] }`
class RasaWebhookResponse {
  /// Optional recipient id echoed by Rasa.
  final String? recipientId;

  /// Assistant text.
  final String? text;

  /// Optional image URL.
  final String? image;

  const RasaWebhookResponse({
    this.recipientId,
    this.text,
    this.image,
  });

  /// Parse a response item from JSON.
  factory RasaWebhookResponse.fromJson(Map<String, dynamic> json) {
    return RasaWebhookResponse(
      recipientId: json['recipient_id'] as String?,
      text: json['text'] as String?,
      image: json['image'] as String?,
    );
  }
}
