import 'dart:convert';

class TopicProgress {
  final String topicId;
  final List<SubTopicProgress> subTopics;
  final DateTime lastAccessDate;
  final double completionPercentage;

  TopicProgress({
    required this.topicId,
    required this.subTopics,
    required this.lastAccessDate,
    required this.completionPercentage,
  });

  factory TopicProgress.fromJson(Map<String, dynamic> json) {
    return TopicProgress(
      topicId: json['topicId'] as String,
      subTopics: (json['subTopics'] as List)
          .map((e) => SubTopicProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastAccessDate: DateTime.parse(json['lastAccessDate'] as String),
      completionPercentage: json['completionPercentage'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'subTopics': subTopics.map((e) => e.toJson()).toList(),
        'lastAccessDate': lastAccessDate.toIso8601String(),
        'completionPercentage': completionPercentage,
      };

  TopicProgress copyWith({
    String? topicId,
    List<SubTopicProgress>? subTopics,
    DateTime? lastAccessDate,
    double? completionPercentage,
  }) {
    return TopicProgress(
      topicId: topicId ?? this.topicId,
      subTopics: subTopics ?? this.subTopics,
      lastAccessDate: lastAccessDate ?? this.lastAccessDate,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}

class SubTopicProgress {
  final String subTopicId;
  final bool isCompleted;
  final DateTime? completionDate;
  final int viewCount;

  SubTopicProgress({
    required this.subTopicId,
    required this.isCompleted,
    this.completionDate,
    required this.viewCount,
  });

  factory SubTopicProgress.fromJson(Map<String, dynamic> json) {
    return SubTopicProgress(
      subTopicId: json['subTopicId'] as String,
      isCompleted: json['isCompleted'] as bool,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      viewCount: json['viewCount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'subTopicId': subTopicId,
        'isCompleted': isCompleted,
        'completionDate': completionDate?.toIso8601String(),
        'viewCount': viewCount,
      };

  SubTopicProgress copyWith({
    String? subTopicId,
    bool? isCompleted,
    DateTime? completionDate,
    int? viewCount,
  }) {
    return SubTopicProgress(
      subTopicId: subTopicId ?? this.subTopicId,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}
