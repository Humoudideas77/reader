import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'usage_stats.g.dart';

@HiveType(typeId: 2)
class UsageStats extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String month; // Format: "YYYY-MM"

  @HiveField(2)
  final int pagesProcessed;

  @HiveField(3)
  final int aiQuestionsAskedToday;

  @HiveField(4)
  final int documentsImported;

  @HiveField(5)
  final int conversionsUsed;

  @HiveField(6)
  final DateTime lastResetDate; // For daily limits like AI questions

  const UsageStats({
    required this.userId,
    required this.month,
    required this.pagesProcessed,
    required this.aiQuestionsAskedToday,
    required this.documentsImported,
    required this.conversionsUsed,
    required this.lastResetDate,
  });

  UsageStats copyWith({
    String? userId,
    String? month,
    int? pagesProcessed,
    int? aiQuestionsAskedToday,
    int? documentsImported,
    int? conversionsUsed,
    DateTime? lastResetDate,
  }) {
    return UsageStats(
      userId: userId ?? this.userId,
      month: month ?? this.month,
      pagesProcessed: pagesProcessed ?? this.pagesProcessed,
      aiQuestionsAskedToday: aiQuestionsAskedToday ?? this.aiQuestionsAskedToday,
      documentsImported: documentsImported ?? this.documentsImported,
      conversionsUsed: conversionsUsed ?? this.conversionsUsed,
      lastResetDate: lastResetDate ?? this.lastResetDate,
    );
  }

  /// Reset daily counters if it's a new day
  UsageStats resetIfNewDay() {
    final now = DateTime.now();
    final isNewDay = now.day != lastResetDate.day ||
        now.month != lastResetDate.month ||
        now.year != lastResetDate.year;

    if (isNewDay) {
      return copyWith(
        aiQuestionsAskedToday: 0,
        lastResetDate: now,
      );
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'month': month,
      'pagesProcessed': pagesProcessed,
      'aiQuestionsAskedToday': aiQuestionsAskedToday,
      'documentsImported': documentsImported,
      'conversionsUsed': conversionsUsed,
      'lastResetDate': lastResetDate.toIso8601String(),
    };
  }

  factory UsageStats.fromJson(Map<String, dynamic> json) {
    return UsageStats(
      userId: json['userId'] as String,
      month: json['month'] as String,
      pagesProcessed: json['pagesProcessed'] as int,
      aiQuestionsAskedToday: json['aiQuestionsAskedToday'] as int,
      documentsImported: json['documentsImported'] as int,
      conversionsUsed: json['conversionsUsed'] as int,
      lastResetDate: DateTime.parse(json['lastResetDate'] as String),
    );
  }

  @override
  List<Object?> get props => [
        userId,
        month,
        pagesProcessed,
        aiQuestionsAskedToday,
        documentsImported,
        conversionsUsed,
        lastResetDate,
      ];
}
