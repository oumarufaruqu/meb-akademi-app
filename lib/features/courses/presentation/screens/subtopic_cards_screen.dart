import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meb_akademi_app/features/courses/domain/models/subtopic_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SubTopicCardsScreen extends ConsumerStatefulWidget {
  final String topicTitle;
  final List<SubTopic> subTopics;

  const SubTopicCardsScreen({
    super.key,
    required this.topicTitle,
    required this.subTopics,
  });

  @override
  ConsumerState<SubTopicCardsScreen> createState() => _SubTopicCardsScreenState();
}

class _SubTopicCardsScreenState extends ConsumerState<SubTopicCardsScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isCompleted = false;
  late ThemeData _theme;
  final CardSwiperController _cardController = CardSwiperController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  Future<bool> _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) async {
    if (currentIndex != null) {
      setState(() {
        _currentIndex = currentIndex;
        if (currentIndex >= widget.subTopics.length - 1) {
          _isCompleted = true;
        }
      });
    }
    return true;
  }

  void _resetCards() {
    setState(() {
      _isCompleted = false;
      _currentIndex = 0;
    });
    _cardController.swipe(CardSwiperDirection.right);
  }

  Widget _buildCard(BuildContext context, SubTopic subtopic) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: _theme.brightness == Brightness.dark
                ? _theme.cardColor.withOpacity(0.8)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: _theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: _theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (subtopic.imageUrl != null)
                Hero(
                  tag: 'image_${subtopic.imageUrl}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            _theme.brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: subtopic.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: _theme.brightness == Brightness.dark
                        ? _theme.cardColor.withOpacity(0.9)
                        : Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: const Radius.circular(20),
                      top: subtopic.imageUrl == null
                          ? const Radius.circular(20)
                          : Radius.zero,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _theme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                subtopic.title,
                                style: _theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _theme.brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subtopic.content,
                            style: _theme.textTheme.bodyLarge?.copyWith(
                              color: _theme.brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.black87.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (subtopic.bulletPoints.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _theme.brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Önemli Noktalar',
                                  style: _theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...subtopic.bulletPoints.map(
                                  (point) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.only(
                                            top: 8,
                                            right: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _theme.primaryColor
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            point,
                                            style: _theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: _theme.brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                      .withOpacity(0.85)
                                                  : Colors.black87
                                                      .withOpacity(0.75),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.topicTitle),
        centerTitle: true,
        backgroundColor: _theme.scaffoldBackgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            color: _theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              '${_currentIndex + 1}/${widget.subTopics.length}',
              style: _theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _isCompleted
          ? Center(
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.celebration,
                        size: 64,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tebrikler!',
                        style: _theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tüm kartları başarıyla tamamladınız.',
                        style: _theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _resetCards,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Başla'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : CardSwiper(
              controller: _cardController,
              cardsCount: widget.subTopics.length,
              onSwipe: _onSwipe,
              numberOfCardsDisplayed: 1,
              backCardOffset: const Offset(0, 0),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              cardBuilder: (
                context,
                index,
                horizontalThresholdPercentage,
                verticalThresholdPercentage,
              ) {
                final subtopic = widget.subTopics[index];
                return Center(
                  child: _buildCard(context, subtopic),
                );
              },
            ),
    );
  }
}
