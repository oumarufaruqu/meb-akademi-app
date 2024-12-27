import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Topic {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final List<String> subTopics;

  @HiveField(4)
  final List<String> examples;

  @HiveField(5)
  final List<String> keyPoints;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.subTopics,
    required this.examples,
    required this.keyPoints,
  });
}
