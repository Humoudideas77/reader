import 'package:equatable/equatable.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

class AiChatMessage extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final String? sourceReference; // e.g., "Based on pages 3-5"
  final List<int>? referencedPages;

  const AiChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.sourceReference,
    this.referencedPages,
  });

  AiChatMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    String? sourceReference,
    List<int>? referencedPages,
  }) {
    return AiChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sourceReference: sourceReference ?? this.sourceReference,
      referencedPages: referencedPages ?? this.referencedPages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sourceReference': sourceReference,
      'referencedPages': referencedPages,
    };
  }

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      id: json['id'] as String,
      role: MessageRole.values.firstWhere((e) => e.name == json['role']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sourceReference: json['sourceReference'] as String?,
      referencedPages: json['referencedPages'] != null
          ? List<int>.from(json['referencedPages'] as List)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, sourceReference, referencedPages];
}
