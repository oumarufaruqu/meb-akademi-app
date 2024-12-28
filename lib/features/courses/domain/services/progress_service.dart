import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/progress_model.dart';

class ProgressService {
  static const String _progressKey = 'topic_progress';
  final SharedPreferences _prefs;

  ProgressService(this._prefs);

  Future<void> saveProgress(TopicProgress progress) async {
    final progressList = await getAllProgress();
    final index = progressList.indexWhere((p) => p.topicId == progress.topicId);
    
    if (index != -1) {
      progressList[index] = progress;
    } else {
      progressList.add(progress);
    }

    final jsonList = progressList.map((p) => p.toJson()).toList();
    await _prefs.setString(_progressKey, jsonEncode(jsonList));
  }

  Future<TopicProgress?> getProgress(String topicId) async {
    final progressList = await getAllProgress();
    return progressList.firstWhere(
      (p) => p.topicId == topicId,
      orElse: () => TopicProgress(
        topicId: topicId,
        subTopics: [],
        lastAccessDate: DateTime.now(),
        completionPercentage: 0,
      ),
    );
  }

  Future<List<TopicProgress>> getAllProgress() async {
    final jsonString = _prefs.getString(_progressKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => TopicProgress.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateSubTopicProgress(
    String topicId,
    String subTopicId,
    bool isCompleted,
  ) async {
    final progress = await getProgress(topicId);
    if (progress == null) return;

    final subTopics = List<SubTopicProgress>.from(progress.subTopics);
    final index = subTopics.indexWhere((s) => s.subTopicId == subTopicId);

    if (index != -1) {
      subTopics[index] = subTopics[index].copyWith(
        isCompleted: isCompleted,
        completionDate: isCompleted ? DateTime.now() : null,
        viewCount: subTopics[index].viewCount + 1,
      );
    } else {
      subTopics.add(
        SubTopicProgress(
          subTopicId: subTopicId,
          isCompleted: isCompleted,
          completionDate: isCompleted ? DateTime.now() : null,
          viewCount: 1,
        ),
      );
    }

    final completedCount = subTopics.where((s) => s.isCompleted).length;
    final completionPercentage = (completedCount / subTopics.length) * 100;

    final updatedProgress = progress.copyWith(
      subTopics: subTopics,
      lastAccessDate: DateTime.now(),
      completionPercentage: completionPercentage,
    );

    await saveProgress(updatedProgress);
  }

  Future<void> clearProgress(String topicId) async {
    final progressList = await getAllProgress();
    progressList.removeWhere((p) => p.topicId == topicId);
    
    final jsonList = progressList.map((p) => p.toJson()).toList();
    await _prefs.setString(_progressKey, jsonEncode(jsonList));
  }
}
