import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meb_akademi_app/features/courses/domain/models/course_model.dart';
import 'package:meb_akademi_app/features/courses/domain/models/topic_model.dart';
import 'package:meb_akademi_app/features/courses/presentation/screens/topic_detail_screen.dart';

class CourseDetailScreen extends ConsumerWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  // Örnek konu içeriği oluştur
  Topic _createSampleTopic(String title, int index) {
    return Topic(
      id: 'topic_$index',
      title: title,
      content: '''
Bu konu başlığında öğrencilerin kavraması gereken temel kavramlar ve önemli noktalar ele alınmaktadır. 
Konunun detaylı açıklaması ve öğrencilerin anlayabileceği şekilde basitleştirilmiş anlatımı burada yer alır.

Konu anlatımı sırasında görsel öğeler, tablolar ve grafikler kullanılarak öğrenme süreci desteklenir. 
Öğrencilerin konuyu daha iyi kavramaları için günlük hayattan örnekler verilir.''',
      subTopics: [
        'Alt Başlık 1',
        'Alt Başlık 2',
        'Alt Başlık 3',
      ],
      examples: [
        'Örnek 1: Konuyla ilgili çözümlü bir problem ve açıklaması.',
        'Örnek 2: Günlük hayattan bir uygulama örneği.',
        'Örnek 3: Pekiştirici bir alıştırma.',
      ],
      keyPoints: [
        'Bu konudaki en önemli nokta 1',
        'Unutulmaması gereken kural 2',
        'Sınavlarda sıkça sorulan konu 3',
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ders Kapak Resmi
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.book,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            
            // Ders Bilgileri
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  // Konu Başlıkları
                  Text(
                    'Konu Başlıkları',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: course.topics.length,
                    itemBuilder: (context, index) {
                      final topic = _createSampleTopic(course.topics[index], index);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(topic.title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicDetailScreen(topic: topic),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quiz Butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Quiz ekranına git
                      },
                      icon: const Icon(Icons.quiz),
                      label: const Text('Konuyu Test Et'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
