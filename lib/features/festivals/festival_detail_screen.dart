import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/sharing/share_card.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/app_controller.dart';
import '../premium/premium_widgets.dart';

class FestivalDetailScreen extends ConsumerWidget {
  const FestivalDetailScreen({
    super.key,
    required this.festivalId,
  });

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appControllerProvider.notifier);
    final festival = controller.festivalById(festivalId);
    final prayer = controller.prayerById(festival.recommendedPrayerId);
    final profile = ref.watch(appControllerProvider).requireValue.profile;
    final countdown = festival.date.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(title: Text(festival.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$countdown days to go',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(DateFormat('dd MMM yyyy').format(festival.date)),
                  const SizedBox(height: 12),
                  Text(festival.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puja checklist',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ...festival.checklist.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Recommended mantra/aarti: ${prayer.title}'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final template = ref
                  .read(appControllerProvider.notifier)
                  .shareTemplate('festival_wishes');
              await ref
                  .read(analyticsServiceProvider)
                  .logGreetingGenerated('festival_wishes');
              await ref.read(shareServiceProvider).shareToWhatsAppFirst(
                    card: ShareCardWidget(
                      title: template.title,
                      subtitle: festival.title,
                      name: profile?.name ?? 'Bhakt',
                      highlight: DateFormat('dd MMM').format(festival.date),
                      watermark: template.watermark,
                      emoji: '🎉',
                    ),
                    message:
                        'Festival wishes from Shanatani for ${festival.title} 🙏',
                    fileName: '${festival.id}_festival_card.png',
                  );
              await ref
                  .read(analyticsServiceProvider)
                  .logGreetingShared('festival_wishes');
              await ref
                  .read(appControllerProvider.notifier)
                  .incrementShareCount();
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share on WhatsApp CTA'),
          ),
          const SizedBox(height: 12),
          const PremiumWaitlistButton(
              label: 'Premium Festival Pack waitlist CTA'),
        ],
      ),
    );
  }
}
