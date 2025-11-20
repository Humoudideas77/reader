import 'package:equatable/equatable.dart';

class SubscriptionPlan extends Equatable {
  final String id; // 'free', 'subscriber', 'pro'
  final String name;
  final String nameLocalized; // For Arabic names
  final String description;
  final String descriptionLocalized;
  final double monthlyPriceUsd;
  final String monthlyPriceLocal; // e.g., "2.25 KWD"
  final int maxDocuments;
  final int maxPagesPerMonth;
  final int maxAiQuestionsPerDay;
  final int maxConversionsPerMonth; // -1 for unlimited
  final List<String> features;
  final List<String> featuresLocalized;
  final bool isPopular;
  final bool isBestValue;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameLocalized,
    required this.description,
    required this.descriptionLocalized,
    required this.monthlyPriceUsd,
    required this.monthlyPriceLocal,
    required this.maxDocuments,
    required this.maxPagesPerMonth,
    required this.maxAiQuestionsPerDay,
    required this.maxConversionsPerMonth,
    required this.features,
    required this.featuresLocalized,
    this.isPopular = false,
    this.isBestValue = false,
  });

  bool get isFree => id == 'free';
  bool get isSubscriber => id == 'subscriber';
  bool get isPro => id == 'pro';
  bool get hasUnlimitedConversions => maxConversionsPerMonth == -1;

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? nameLocalized,
    String? description,
    String? descriptionLocalized,
    double? monthlyPriceUsd,
    String? monthlyPriceLocal,
    int? maxDocuments,
    int? maxPagesPerMonth,
    int? maxAiQuestionsPerDay,
    int? maxConversionsPerMonth,
    List<String>? features,
    List<String>? featuresLocalized,
    bool? isPopular,
    bool? isBestValue,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      nameLocalized: nameLocalized ?? this.nameLocalized,
      description: description ?? this.description,
      descriptionLocalized: descriptionLocalized ?? this.descriptionLocalized,
      monthlyPriceUsd: monthlyPriceUsd ?? this.monthlyPriceUsd,
      monthlyPriceLocal: monthlyPriceLocal ?? this.monthlyPriceLocal,
      maxDocuments: maxDocuments ?? this.maxDocuments,
      maxPagesPerMonth: maxPagesPerMonth ?? this.maxPagesPerMonth,
      maxAiQuestionsPerDay: maxAiQuestionsPerDay ?? this.maxAiQuestionsPerDay,
      maxConversionsPerMonth: maxConversionsPerMonth ?? this.maxConversionsPerMonth,
      features: features ?? this.features,
      featuresLocalized: featuresLocalized ?? this.featuresLocalized,
      isPopular: isPopular ?? this.isPopular,
      isBestValue: isBestValue ?? this.isBestValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameLocalized': nameLocalized,
      'description': description,
      'descriptionLocalized': descriptionLocalized,
      'monthlyPriceUsd': monthlyPriceUsd,
      'monthlyPriceLocal': monthlyPriceLocal,
      'maxDocuments': maxDocuments,
      'maxPagesPerMonth': maxPagesPerMonth,
      'maxAiQuestionsPerDay': maxAiQuestionsPerDay,
      'maxConversionsPerMonth': maxConversionsPerMonth,
      'features': features,
      'featuresLocalized': featuresLocalized,
      'isPopular': isPopular,
      'isBestValue': isBestValue,
    };
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      nameLocalized: json['nameLocalized'] as String,
      description: json['description'] as String,
      descriptionLocalized: json['descriptionLocalized'] as String,
      monthlyPriceUsd: (json['monthlyPriceUsd'] as num).toDouble(),
      monthlyPriceLocal: json['monthlyPriceLocal'] as String,
      maxDocuments: json['maxDocuments'] as int,
      maxPagesPerMonth: json['maxPagesPerMonth'] as int,
      maxAiQuestionsPerDay: json['maxAiQuestionsPerDay'] as int,
      maxConversionsPerMonth: json['maxConversionsPerMonth'] as int,
      features: List<String>.from(json['features'] as List),
      featuresLocalized: List<String>.from(json['featuresLocalized'] as List),
      isPopular: json['isPopular'] as bool? ?? false,
      isBestValue: json['isBestValue'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameLocalized,
        description,
        descriptionLocalized,
        monthlyPriceUsd,
        monthlyPriceLocal,
        maxDocuments,
        maxPagesPerMonth,
        maxAiQuestionsPerDay,
        maxConversionsPerMonth,
        features,
        featuresLocalized,
        isPopular,
        isBestValue,
      ];
}
