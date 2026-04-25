import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/models/app_models.dart';
import '../../core/sharing/share_card.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/app_controller.dart';
import '../premium/premium_widgets.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appControllerProvider).requireValue;
    final profile = appState.profile;
    final deity = ref.read(appControllerProvider.notifier).deityById(
          profile?.favouriteDeityId ?? 'ram',
        );
    final prayer = appState.seedContent.prayers.firstWhere(
      (item) => item.deityId == deity.id,
      orElse: () => appState.seedContent.prayers.first,
    );
    final nextFestival = _nextFestival(appState.seedContent.festivals);
    final countdown = nextFestival.date.difference(DateTime.now()).inDays;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _TodayHero(
          title: 'Jai Shri Ram, ${profile?.name ?? 'Bhakt'} 🙏',
          subtitle: appState.hasCompletedPrayerToday
              ? 'Your daily prayer is complete. Keep the blessings moving.'
              : 'Your blessings are waiting. Start today’s prayer flow.',
          streak: appState.prayerStreak,
        ),
        const SizedBox(height: 18),
        _InfoCard(
          title: 'Aaj ka mantra',
          child: Text(prayer.verses.take(2).join('\n')),
        ),
        const SizedBox(height: 14),
        const _InfoCard(
          title: 'Aaj ka Panchang',
          child: Text('Shubh samay, tithi aur nakshatra placeholders for MVP.'),
        ),
        const SizedBox(height: 14),
        _InfoCard(
          title: 'Aaj ka vrat / festival',
          child: Text('${nextFestival.title} is coming in $countdown day(s).'),
        ),
        const SizedBox(height: 14),
        _InfoCard(
          title: 'Festival countdown',
          child: Text(
            '${nextFestival.title}\n${nextFestival.date.day}-${nextFestival.date.month}-${nextFestival.date.year}',
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: () async {
            await ref
                .read(analyticsServiceProvider)
                .logGreetingGenerated('good_morning');
            final template = ref
                .read(appControllerProvider.notifier)
                .shareTemplate('good_morning');
            final result = await ref
                .read(shareServiceProvider)
                .shareToWhatsAppFirst(
                  card: ShareCardWidget(
                    title: template.title,
                    subtitle: deity.blessing,
                    name: profile?.name ?? 'Bhakt',
                    highlight: deity.name,
                    watermark: template.watermark,
                    emoji: deity.emoji,
                  ),
                  message: 'Good morning from Shanatani 🙏\n${deity.blessing}',
                  fileName: 'good_morning_card.png',
                );
            if (result == ShareFlowResult.whatsappOpened) {
              await ref
                  .read(analyticsServiceProvider)
                  .logWhatsAppShareClicked('good_morning');
            }
            await ref
                .read(analyticsServiceProvider)
                .logGreetingShared('good_morning');
            await ref
                .read(appControllerProvider.notifier)
                .incrementShareCount();
          },
          icon: const Icon(Icons.share_rounded),
          label: const Text('Share blessing card'),
        ),
        const SizedBox(height: 12),
        const PremiumWaitlistButton(label: 'Join Premium Waitlist'),
      ],
    );
  }

  Festival _nextFestival(List<Festival> festivals) {
    final now = DateTime.now();
    final upcoming = festivals
        .where((festival) => !festival.date.isBefore(now))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isNotEmpty ? upcoming.first : festivals.first;
  }
}

class _TodayHero extends StatelessWidget {
  const _TodayHero({
    required this.title,
    required this.subtitle,
    required this.streak,
  });

  final String title;
  final String subtitle;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.local_fire_department_rounded),
                const SizedBox(width: 8),
                Text('Today’s streak: $streak day(s)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
