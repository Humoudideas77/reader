import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/document.dart';

/// Repository for managing documents with Hive local storage
/// TODO: In production, sync with backend API for multi-device support
class DocumentRepository {
  Box<Map>? _documentsBox;

  /// Initialize Hive and open documents box
  Future<void> initialize() async {
    await Hive.initFlutter();

    // TODO: Register Hive adapters when using generated code
    // Hive.registerAdapter(DocumentAdapter());

    _documentsBox = await Hive.openBox<Map>(AppConstants.hiveBoxDocuments);
  }

  /// Get all documents for a user
  Future<List<Document>> getDocuments(String userId) async {
    final box = _documentsBox!;
    final documents = <Document>[];

    for (var key in box.keys) {
      final data = box.get(key) as Map<dynamic, dynamic>;
      final docMap = Map<String, dynamic>.from(data);

      if (docMap['userId'] == userId) {
        documents.add(Document.fromJson(docMap));
      }
    }

    // Sort by last opened (most recent first)
    documents.sort((a, b) => b.lastOpenedAt.compareTo(a.lastOpenedAt));

    return documents;
  }

  /// Get a single document by ID
  Future<Document?> getDocumentById(String documentId) async {
    final box = _documentsBox!;
    final data = box.get(documentId);

    if (data == null) return null;

    final docMap = Map<String, dynamic>.from(data as Map);
    return Document.fromJson(docMap);
  }

  /// Save or update a document
  Future<void> saveDocument(Document document) async {
    final box = _documentsBox!;
    await box.put(document.id, document.toJson());
  }

  /// Delete a document
  Future<void> deleteDocument(String documentId) async {
    final box = _documentsBox!;
    await box.delete(documentId);
  }

  /// Update document's last opened time
  Future<void> updateLastOpened(String documentId) async {
    final doc = await getDocumentById(documentId);
    if (doc != null) {
      await saveDocument(doc.copyWith(lastOpenedAt: DateTime.now()));
    }
  }

  /// Toggle star/favorite status
  Future<void> toggleStar(String documentId) async {
    final doc = await getDocumentById(documentId);
    if (doc != null) {
      await saveDocument(doc.copyWith(isStarred: !doc.isStarred));
    }
  }

  /// Update AI processed status
  Future<void> markAsAiProcessed(String documentId) async {
    final doc = await getDocumentById(documentId);
    if (doc != null) {
      await saveDocument(doc.copyWith(aiProcessed: true));
    }
  }

  /// Get documents by filter
  Future<List<Document>> getDocumentsByFilter(
    String userId, {
    bool? starred,
    List<String>? tags,
    String? searchQuery,
  }) async {
    var documents = await getDocuments(userId);

    if (starred != null && starred) {
      documents = documents.where((doc) => doc.isStarred).toList();
    }

    if (tags != null && tags.isNotEmpty) {
      documents = documents.where((doc) {
        return tags.any((tag) => doc.tags.contains(tag));
      }).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      documents = documents.where((doc) {
        return doc.title.toLowerCase().contains(query) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return documents;
  }

  /// Get starred documents
  Future<List<Document>> getStarredDocuments(String userId) async {
    return getDocumentsByFilter(userId, starred: true);
  }

  /// Get recent documents (last 7 days)
  Future<List<Document>> getRecentDocuments(String userId) async {
    final documents = await getDocuments(userId);
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return documents
        .where((doc) => doc.lastOpenedAt.isAfter(sevenDaysAgo))
        .toList();
  }

  /// Get all unique tags from user's documents
  Future<List<String>> getAllTags(String userId) async {
    final documents = await getDocuments(userId);
    final tagSet = <String>{};

    for (var doc in documents) {
      tagSet.addAll(doc.tags);
    }

    return tagSet.toList()..sort();
  }

  /// Add tags to a document
  Future<void> addTags(String documentId, List<String> newTags) async {
    final doc = await getDocumentById(documentId);
    if (doc != null) {
      final updatedTags = {...doc.tags, ...newTags}.toList();
      await saveDocument(doc.copyWith(tags: updatedTags));
    }
  }

  /// Remove tags from a document
  Future<void> removeTags(String documentId, List<String> tagsToRemove) async {
    final doc = await getDocumentById(documentId);
    if (doc != null) {
      final updatedTags = doc.tags
          .where((tag) => !tagsToRemove.contains(tag))
          .toList();
      await saveDocument(doc.copyWith(tags: updatedTags));
    }
  }

  /// Get document count for a user
  Future<int> getDocumentCount(String userId) async {
    final documents = await getDocuments(userId);
    return documents.length;
  }

  /// Close the Hive box
  Future<void> close() async {
    await _documentsBox?.close();
  }
}
