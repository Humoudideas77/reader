import '../../core/constants/app_constants.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_search_hit.dart';
import '../../domain/entities/ai_summary_result.dart';
import '../../domain/entities/document.dart';

/// Abstract interface for Document AI Service
/// This interface should be implemented with real AI backend API calls
abstract class DocumentAiService {
  Future<AiSummaryResult> summarizeDocument(
    Document doc,
    SummaryMode mode,
  );

  Future<List<AiSearchHit>> semanticSearch(
    Document doc,
    String query,
  );

  Future<AiChatMessage> chatWithDocument(
    Document doc,
    List<AiChatMessage> history,
    String userMessage,
  );

  Future<void> processDocumentForAi(Document doc);
}

/// Mock implementation of DocumentAiService
/// TODO: Replace with real backend API calls
/// Backend should:
/// - Process PDF/document embeddings for semantic search
/// - Use LLM for summarization and Q&A
/// - Return structured responses with source references
class MockDocumentAiService implements DocumentAiService {
  @override
  Future<AiSummaryResult> summarizeDocument(
    Document doc,
    SummaryMode mode,
  ) async {
    // Simulate API call delay
    await Future.delayed(AppConstants.aiMockDelayMedium);

    // TODO: Replace with actual API call
    // Example endpoint: POST /api/v1/documents/{docId}/summarize
    // Body: { "mode": "short" | "detailed" | "section" }

    final mockSummaries = {
      SummaryMode.short: _generateMockShortSummary(doc),
      SummaryMode.detailed: _generateMockDetailedSummary(doc),
      SummaryMode.section: _generateMockSectionSummary(doc),
    };

    return AiSummaryResult(
      documentId: doc.id,
      mode: mode,
      text: mockSummaries[mode]!,
      generatedAt: DateTime.now(),
      sectionReference: mode == SummaryMode.section ? 'pages 1-3' : null,
    );
  }

  @override
  Future<List<AiSearchHit>> semanticSearch(
    Document doc,
    String query,
  ) async {
    // Simulate API call delay
    await Future.delayed(AppConstants.aiMockDelayShort);

    // TODO: Replace with actual API call
    // Example endpoint: POST /api/v1/documents/{docId}/search
    // Body: { "query": "user search query", "semantic": true }

    return _generateMockSearchResults(doc, query);
  }

  @override
  Future<AiChatMessage> chatWithDocument(
    Document doc,
    List<AiChatMessage> history,
    String userMessage,
  ) async {
    // Simulate API call delay
    await Future.delayed(AppConstants.aiMockDelayLong);

    // TODO: Replace with actual API call
    // Example endpoint: POST /api/v1/documents/{docId}/chat
    // Body: { "history": [...], "message": "user question" }

    return _generateMockChatResponse(doc, userMessage, history.length);
  }

  @override
  Future<void> processDocumentForAi(Document doc) async {
    // Simulate document processing (OCR, embedding generation, etc.)
    await Future.delayed(AppConstants.aiMockDelayLong);

    // TODO: Replace with actual API call
    // Example endpoint: POST /api/v1/documents/{docId}/process
    // This would:
    // - Extract text from PDF (or run OCR if scanned)
    // - Generate embeddings for semantic search
    // - Store processed data for fast AI operations
  }

  // --- Mock Data Generators ---

  String _generateMockShortSummary(Document doc) {
    return '''This document "${doc.title}" provides comprehensive information across ${doc.pageCount} pages. The main topics covered include key concepts, detailed explanations, and practical applications. The content is well-structured and aims to provide readers with a thorough understanding of the subject matter.''';
  }

  String _generateMockDetailedSummary(Document doc) {
    return '''Document: ${doc.title}

📄 Overview:
This ${doc.pageCount}-page document presents a comprehensive examination of its subject matter. The content is organized systematically to guide readers through fundamental concepts to advanced applications.

🔑 Key Points:
• Introduction: Establishes foundational concepts and objectives
• Main Content: Explores core themes with supporting evidence and examples
• Analysis: Provides critical examination of key arguments
• Conclusions: Synthesizes findings and suggests future directions

💡 Significant Insights:
The document demonstrates thorough research and presents information in an accessible format. Multiple perspectives are considered, with clear explanations supporting each major point.

🎯 Target Audience:
The material is suitable for students, professionals, and researchers seeking in-depth knowledge of the subject area.

📊 Structure:
The document follows a logical progression, making it easy to follow and reference specific sections when needed.''';
  }

  String _generateMockSectionSummary(Document doc) {
    return '''Section Summary (Pages 1-3):

This opening section introduces the main themes and establishes the context for the document. Key definitions are provided, and the scope of coverage is clearly outlined. The author presents the rationale for the study and previews the structure of subsequent sections.

Main points covered:
• Background context
• Definitions of key terms
• Objectives and goals
• Methodology overview''';
  }

  List<AiSearchHit> _generateMockSearchResults(Document doc, String query) {
    // Generate 3-5 mock search results
    return [
      AiSearchHit(
        documentId: doc.id,
        pageNumber: 3,
        snippet:
            'The fundamental concept of $query is essential to understanding the broader framework. This principle underlies many of the subsequent discussions...',
        score: 0.92,
        highlights: [query],
      ),
      AiSearchHit(
        documentId: doc.id,
        pageNumber: 7,
        snippet:
            'Research has shown that $query plays a critical role in the application of these methods. Several studies have demonstrated...',
        score: 0.87,
        highlights: [query],
      ),
      AiSearchHit(
        documentId: doc.id,
        pageNumber: 12,
        snippet:
            'In conclusion, the implementation of $query requires careful consideration of various factors. Best practices suggest...',
        score: 0.78,
        highlights: [query],
      ),
    ];
  }

  AiChatMessage _generateMockChatResponse(
    Document doc,
    String userMessage,
    int historyLength,
  ) {
    final responses = [
      'Based on the document "${doc.title}", I can help answer that question. The relevant information appears primarily on pages 3-5, where the author discusses this topic in detail.',
      'That\'s an interesting question about the document. According to the content on pages 7-9, the key points related to your query include several important considerations.',
      'Let me provide you with insights from the document. The section on pages 4-6 addresses this topic directly and offers comprehensive explanations.',
      'From my analysis of "${doc.title}", I found that pages 2-4 contain information that directly relates to your question. The document suggests...',
    ];

    final responseIndex = historyLength % responses.length;

    return AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.assistant,
      content: responses[responseIndex],
      timestamp: DateTime.now(),
      sourceReference: 'Based on pages 3-5',
      referencedPages: [3, 4, 5],
    );
  }
}
