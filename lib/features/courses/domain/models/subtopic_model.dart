import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class SubTopic {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final List<String> bulletPoints;

  SubTopic({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.bulletPoints,
  });
}
