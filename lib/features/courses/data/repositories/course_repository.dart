import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/course_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(Supabase.instance.client);
});

class CourseRepository {
  final SupabaseClient _supabaseClient;

  CourseRepository(this._supabaseClient);

  Future<List<Course>> getCourses() async {
    final response = await _supabaseClient
        .from('courses')
        .select('id, title, description, image_url, topics, total_questions');

    return (response as List).map((course) => Course.fromJson(course)).toList();
  }

  Future<List<String>> getTopics(String courseId) async {
    final response = await _supabaseClient
        .from('topics')
        .select('title')
        .eq('course_id', courseId);

    return (response as List).map((topic) => topic['title'] as String).toList();
  }

  Future<List<String>> getSubtopics(String topicId) async {
    final response = await _supabaseClient
        .from('subtopics')
        .select('title')
        .eq('topic_id', topicId);

    return (response as List).map((subtopic) => subtopic['title'] as String).toList();
  }
}
