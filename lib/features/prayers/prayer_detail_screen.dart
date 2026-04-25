import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/sharing/share_card.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/app_controller.dart';

class PrayerDetailScreen extends ConsumerStatefulWidget {
  const PrayerDetailScreen({
    super.key,
    required this.prayerId,
  });

  final String prayerId;

  @override
  ConsumerState<PrayerDetailScreen> createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends ConsumerState<PrayerDetailScreen> {
  int chantCount = 0;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(appControllerProvider.notifier);
    final prayer = controller.prayerById(widget.prayerId);
    final appState = ref.watch(appControllerProvider).requireValue;
    final deity = controller.deityById(prayer.deityId);
    final profile = appState.profile;

    return Scaffold(
      appBar: AppBar(title: Text(prayer.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${deity.emoji} ${deity.name}'),
                  const SizedBox(height: 12),
                  Text(prayer.hindiText, style: const TextStyle(height: 1.7)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DetailSection(
              title: 'English transliteration', body: prayer.transliteration),
          const SizedBox(height: 14),
          _DetailSection(title: 'Meaning', body: prayer.meaning),
          const SizedBox(height: 14),
          _DetailSection(title: 'Audio', body: prayer.audioLabel),
          const SizedBox(height: 14),
          _DetailSection(title: 'Video', body: prayer.videoLabel),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Text('Chant counter: $chantCount')),
                  FilledButton(
                    onPressed: () => setState(() => chantCount += 1),
                    child: const Text('Count Chant'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(appControllerProvider.notifier)
                  .completeTodayPrayer(prayer.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prayer marked as completed.')),
                );
              }
            },
            child: const Text('Complete prayer'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await ref
                  .read(analyticsServiceProvider)
                  .logShareClicked('prayer_detail');
              final template = controller.shareTemplate('proud_shanatani');
              await ref.read(shareServiceProvider).shareToWhatsAppFirst(
                    card: ShareCardWidget(
                      title: template.title,
                      subtitle: prayer.title,
                      name: profile?.name ?? 'Bhakt',
                      highlight: deity.name,
                      watermark: template.watermark,
                      emoji: deity.emoji,
                    ),
                    message: 'I offered ${prayer.title} on Shanatani 🙏',
                    fileName: '${prayer.id}_completion.png',
                  );
              await ref
                  .read(appControllerProvider.notifier)
                  .incrementShareCount();
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share completion card CTA'),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
