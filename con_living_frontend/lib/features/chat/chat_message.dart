import 'package:flutter/foundation.dart';

/// Represents a single chat message in the UI.
///
/// This is a UI/domain model (not the Rasa API model) used to render the chat
/// conversation consistently for both user and assistant messages.
@immutable
class ChatMessage {
  /// Stable id for list rendering.
  final String id;

  /// Message text to display.
  final String text;

  /// Whether this message is from the user (true) or assistant (false).
  final bool isUser;

  /// When the message was created (local time).
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });
}
