import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Course {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final List<String> topics;

  @HiveField(5)
  final int totalQuestions;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.topics,
    required this.totalQuestions,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
      totalQuestions: json['total_questions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'topics': topics,
      'total_questions': totalQuestions,
    };
  }
}
