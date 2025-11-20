import 'package:equatable/equatable.dart';

class AiSearchHit extends Equatable {
  final String documentId;
  final int pageNumber;
  final String snippet;
  final double score; // relevance score 0.0 to 1.0
  final List<String>? highlights; // highlighted phrases within the snippet

  const AiSearchHit({
    required this.documentId,
    required this.pageNumber,
    required this.snippet,
    required this.score,
    this.highlights,
  });

  AiSearchHit copyWith({
    String? documentId,
    int? pageNumber,
    String? snippet,
    double? score,
    List<String>? highlights,
  }) {
    return AiSearchHit(
      documentId: documentId ?? this.documentId,
      pageNumber: pageNumber ?? this.pageNumber,
      snippet: snippet ?? this.snippet,
      score: score ?? this.score,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'pageNumber': pageNumber,
      'snippet': snippet,
      'score': score,
      'highlights': highlights,
    };
  }

  factory AiSearchHit.fromJson(Map<String, dynamic> json) {
    return AiSearchHit(
      documentId: json['documentId'] as String,
      pageNumber: json['pageNumber'] as int,
      snippet: json['snippet'] as String,
      score: (json['score'] as num).toDouble(),
      highlights: json['highlights'] != null
          ? List<String>.from(json['highlights'] as List)
          : null,
    );
  }

  @override
  List<Object?> get props => [documentId, pageNumber, snippet, score, highlights];
}
