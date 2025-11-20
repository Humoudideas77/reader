import 'package:equatable/equatable.dart';

enum SummaryMode {
  short,
  detailed,
  section,
}

class AiSummaryResult extends Equatable {
  final String documentId;
  final SummaryMode mode;
  final String text;
  final DateTime generatedAt;
  final String? sectionReference; // e.g., "pages 5-7" or "section 2"

  const AiSummaryResult({
    required this.documentId,
    required this.mode,
    required this.text,
    required this.generatedAt,
    this.sectionReference,
  });

  AiSummaryResult copyWith({
    String? documentId,
    SummaryMode? mode,
    String? text,
    DateTime? generatedAt,
    String? sectionReference,
  }) {
    return AiSummaryResult(
      documentId: documentId ?? this.documentId,
      mode: mode ?? this.mode,
      text: text ?? this.text,
      generatedAt: generatedAt ?? this.generatedAt,
      sectionReference: sectionReference ?? this.sectionReference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'mode': mode.name,
      'text': text,
      'generatedAt': generatedAt.toIso8601String(),
      'sectionReference': sectionReference,
    };
  }

  factory AiSummaryResult.fromJson(Map<String, dynamic> json) {
    return AiSummaryResult(
      documentId: json['documentId'] as String,
      mode: SummaryMode.values.firstWhere((e) => e.name == json['mode']),
      text: json['text'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      sectionReference: json['sectionReference'] as String?,
    );
  }

  @override
  List<Object?> get props => [documentId, mode, text, generatedAt, sectionReference];
}
