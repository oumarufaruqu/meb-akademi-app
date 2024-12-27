import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meb_akademi_app/core/constants/app_constants.dart';
import 'package:meb_akademi_app/features/courses/domain/models/course_model.dart';
import 'package:meb_akademi_app/features/courses/presentation/screens/course_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Örnek dersler
    final List<Course> courses = [
      Course(
        id: '1',
        title: 'Matematik',
        description: 'Temel matematik konuları ve problem çözme teknikleri',
        imageUrl: '',
        topics: ['Sayılar', 'Cebir', 'Geometri', 'Veri Analizi'],
        totalQuestions: 50,
      ),
      Course(
        id: '2',
        title: 'Türkçe',
        description: 'Dil bilgisi ve anlam bilgisi konuları',
        imageUrl: '',
        topics: ['Dil Bilgisi', 'Anlam Bilgisi', 'Yazım Kuralları', 'Noktalama'],
        totalQuestions: 40,
      ),
      Course(
        id: '3',
        title: 'Fen Bilimleri',
        description: 'Fizik, Kimya ve Biyoloji temel konuları',
        imageUrl: '',
        topics: ['Madde', 'Enerji', 'Canlılar', 'Dünya ve Uzay'],
        totalQuestions: 45,
      ),
      Course(
        id: '4',
        title: 'Sosyal Bilgiler',
        description: 'Tarih, Coğrafya ve Vatandaşlık konuları',
        imageUrl: '',
        topics: ['Tarih', 'Coğrafya', 'Vatandaşlık', 'Güncel Konular'],
        totalQuestions: 35,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: course),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.book,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
