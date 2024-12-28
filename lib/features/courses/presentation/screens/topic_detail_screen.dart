import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meb_akademi_app/features/courses/domain/models/topic_model.dart';
import 'package:meb_akademi_app/features/courses/domain/models/subtopic_model.dart';
import 'package:meb_akademi_app/features/courses/presentation/screens/subtopic_cards_screen.dart';

class TopicDetailScreen extends ConsumerWidget {
  final Topic topic;

  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

  // Örnek alt konu kartları oluştur
  List<SubTopic> _createSampleSubTopics(String title) {
    return [
      SubTopic(
        id: '1',
        title: '$title - Giriş',
        content: 'Bu bölümde konunun temel kavramlarını öğreneceğiz.',
        bulletPoints: [
          'Temel tanımlar',
          'Konunun önemi',
          'Günlük hayattaki yeri',
        ],
      ),
      SubTopic(
        id: '2',
        title: '$title - Temel Kavramlar',
        content: 'Konuyla ilgili bilmemiz gereken temel kavramları inceleyelim.',
        imageUrl: 'https://picsum.photos/seed/math1/400/300',
        bulletPoints: [
          'Kavram 1 ve açıklaması',
          'Kavram 2 ve açıklaması',
          'Kavramlar arası ilişkiler',
        ],
      ),
      SubTopic(
        id: '3',
        title: '$title - Örnekler',
        content: 'Şimdi öğrendiklerimizi örnekler üzerinde pekiştirelim.',
        imageUrl: 'https://picsum.photos/seed/math2/400/300',
        bulletPoints: [
          'Örnek 1: Temel seviye uygulama',
          'Örnek 2: Orta seviye uygulama',
          'Örnek 3: İleri seviye uygulama',
        ],
      ),
      SubTopic(
        id: '4',
        title: '$title - Problemler',
        content: 'Bu bölümde çözümlü problemleri inceleyeceğiz.',
        bulletPoints: [
          'Problem çözme stratejileri',
          'Çözümlü örnek problemler',
          'Dikkat edilmesi gereken noktalar',
        ],
      ),
      SubTopic(
        id: '5',
        title: '$title - Özet',
        content: 'Öğrendiklerimizi özetleyelim ve tekrar edelim.',
        imageUrl: 'https://picsum.photos/seed/math3/400/300',
        bulletPoints: [
          'Önemli noktaların özeti',
          'Formüller ve kurallar',
          'Sık yapılan hatalar',
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Konuyu kaydet
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Konu İçeriği
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                topic.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // Önemli Noktalar
            if (topic.keyPoints.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Önemli Noktalar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...topic.keyPoints.map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(point)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Alt Konular
            if (topic.subTopics.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Alt Konular',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topic.subTopics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(topic.subTopics[index]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubTopicCardsScreen(
                            topicTitle: topic.subTopics[index],
                            subTopics: _createSampleSubTopics(topic.subTopics[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],

            // Örnekler
            if (topic.examples.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Örnekler',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...topic.examples.map((example) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Örnek',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(example),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Quiz'e git
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Alıştırma Yap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
