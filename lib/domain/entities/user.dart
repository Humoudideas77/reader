import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String planType; // 'free', 'subscriber', 'pro'

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? profileImageUrl;

  @HiveField(6)
  final String? role; // 'student', 'professional', 'researcher', 'other'

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.planType,
    required this.createdAt,
    this.profileImageUrl,
    this.role,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? planType,
    DateTime? createdAt,
    String? profileImageUrl,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      planType: planType ?? this.planType,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'planType': planType,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      planType: json['planType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, email, name, planType, createdAt, profileImageUrl, role];
}
