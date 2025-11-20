import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'document.g.dart';

@HiveType(typeId: 1)
class Document extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final String fileType; // 'pdf', 'docx', 'txt', 'imageScan'

  @HiveField(4)
  final int pageCount;

  @HiveField(5)
  final int sizeBytes;

  @HiveField(6)
  final DateTime importedAt;

  @HiveField(7)
  final DateTime lastOpenedAt;

  @HiveField(8)
  final List<String> tags;

  @HiveField(9)
  final bool isStarred;

  @HiveField(10)
  final bool aiProcessed;

  @HiveField(11)
  final String? thumbnailPath;

  @HiveField(12)
  final String userId;

  const Document({
    required this.id,
    required this.title,
    required this.filePath,
    required this.fileType,
    required this.pageCount,
    required this.sizeBytes,
    required this.importedAt,
    required this.lastOpenedAt,
    required this.tags,
    required this.isStarred,
    required this.aiProcessed,
    required this.userId,
    this.thumbnailPath,
  });

  Document copyWith({
    String? id,
    String? title,
    String? filePath,
    String? fileType,
    int? pageCount,
    int? sizeBytes,
    DateTime? importedAt,
    DateTime? lastOpenedAt,
    List<String>? tags,
    bool? isStarred,
    bool? aiProcessed,
    String? thumbnailPath,
    String? userId,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      pageCount: pageCount ?? this.pageCount,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      importedAt: importedAt ?? this.importedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      tags: tags ?? this.tags,
      isStarred: isStarred ?? this.isStarred,
      aiProcessed: aiProcessed ?? this.aiProcessed,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      userId: userId ?? this.userId,
    );
  }

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'fileType': fileType,
      'pageCount': pageCount,
      'sizeBytes': sizeBytes,
      'importedAt': importedAt.toIso8601String(),
      'lastOpenedAt': lastOpenedAt.toIso8601String(),
      'tags': tags,
      'isStarred': isStarred,
      'aiProcessed': aiProcessed,
      'thumbnailPath': thumbnailPath,
      'userId': userId,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      title: json['title'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      pageCount: json['pageCount'] as int,
      sizeBytes: json['sizeBytes'] as int,
      importedAt: DateTime.parse(json['importedAt'] as String),
      lastOpenedAt: DateTime.parse(json['lastOpenedAt'] as String),
      tags: List<String>.from(json['tags'] as List),
      isStarred: json['isStarred'] as bool,
      aiProcessed: json['aiProcessed'] as bool,
      thumbnailPath: json['thumbnailPath'] as String?,
      userId: json['userId'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        filePath,
        fileType,
        pageCount,
        sizeBytes,
        importedAt,
        lastOpenedAt,
        tags,
        isStarred,
        aiProcessed,
        thumbnailPath,
        userId,
      ];
}
