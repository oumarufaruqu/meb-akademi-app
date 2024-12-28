import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://utduzppgtcnsvnpkoedv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0ZHV6cHBndGNuc3ZucGtvZWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNTAxNzcsImV4cCI6MjA1MDkyNjE3N30.Hb8e0OfpkR1D03EUNwBIHMyobSNFe_DWCIKBSWRY668',
    );
  }

  static Future<Map<String, dynamic>?> getProgress(String userId, String topicId) async {
    try {
      final response = await client
          .from('progress')
          .select()
          .eq('user_id', userId)
          .eq('topic_id', topicId)
          .single();
      return response;
    } catch (e) {
      print('Error getting progress: $e');  
      return null;
    }
  }

  static Future<void> updateProgress({
    required String userId,
    required String topicId,
    required String subTopicId,
    required int currentCardIndex,
    required bool isFirstTime,
  }) async {
    try {
      final existingProgress = await getProgress(userId, topicId);

      if (existingProgress != null) {
        final subTopics = List<Map<String, dynamic>>.from(existingProgress['sub_topics'] ?? []);
        final subTopicIndex = subTopics.indexWhere((s) => s['sub_topic_id'] == subTopicId);

        if (subTopicIndex != -1) {
          if (!subTopics[subTopicIndex]['completed'] && isFirstTime) {
            subTopics[subTopicIndex] = {
              'sub_topic_id': subTopicId,
              'completed': true,
              'last_card_index': currentCardIndex,
              'first_completion_date': DateTime.now().toIso8601String(),
            };
          } else {
            subTopics[subTopicIndex]['last_card_index'] = currentCardIndex;
          }
        } else {
          subTopics.add({
            'sub_topic_id': subTopicId,
            'completed': isFirstTime,
            'last_card_index': currentCardIndex,
            'first_completion_date': isFirstTime ? DateTime.now().toIso8601String() : null,
          });
        }

        await client.from('progress').upsert({
          'user_id': userId,
          'topic_id': topicId,
          'sub_topics': subTopics,
          'last_updated': DateTime.now().toIso8601String(),
        }).select();
      } else {
        await client.from('progress').insert({
          'user_id': userId,
          'topic_id': topicId,
          'sub_topics': [
            {
              'sub_topic_id': subTopicId,
              'completed': isFirstTime,
              'last_card_index': currentCardIndex,
              'first_completion_date': isFirstTime ? DateTime.now().toIso8601String() : null,
            }
          ],
          'last_updated': DateTime.now().toIso8601String(),
        }).select();
      }
    } catch (e) {
      print('Error updating progress: $e');  
    }
  }

  static Future<int?> getLastCardPosition(
    String userId,
    String topicId,
    String subTopicId,
  ) async {
    final progress = await getProgress(userId, topicId);
    if (progress != null) {
      final subTopics = List<Map<String, dynamic>>.from(progress['sub_topics'] ?? []);
      final subTopic = subTopics.firstWhere(
        (s) => s['sub_topic_id'] == subTopicId,
        orElse: () => {'last_card_index': 0},
      );
      return subTopic['last_card_index'] as int;
    }
    return null;
  }

  static Future<double> getCompletionPercentage(
    String userId,
    String topicId,
    int totalSubTopics,
  ) async {
    final progress = await getProgress(userId, topicId);
    if (progress != null) {
      final subTopics = List<Map<String, dynamic>>.from(progress['sub_topics'] ?? []);
      final completedCount = subTopics.where((s) => s['completed'] == true).length;
      return (completedCount / totalSubTopics) * 100;
    }
    return 0.0;
  }

  static Future<void> updateLearnedPoints({
    required String userId,
    required String topicId,
    required String subTopicId,
    required List<String> learnedPoints,
  }) async {
    try {
      await client
          .from('user_progress')
          .upsert({
            'user_id': userId,
            'topic_id': topicId,
            'subtopic_id': subTopicId,
            'learned_points': learnedPoints,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select();
    } catch (e) {
      print('Error updating learned points: $e');
    }
  }

  static Future<List<String>> getLearnedPoints({
    required String userId,
    required String topicId,
    required String subTopicId,
  }) async {
    try {
      final response = await client
          .from('user_progress')
          .select('learned_points')
          .eq('user_id', userId)
          .eq('topic_id', topicId)
          .eq('subtopic_id', subTopicId)
          .single();

      if (response != null) {
        return List<String>.from(response['learned_points'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error getting learned points: $e');
      return [];
    }
  }
}
