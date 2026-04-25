import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/analytics/analytics_service.dart';
import '../../core/models/app_models.dart';
import '../../core/sharing/share_card.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/app_controller.dart';

class DailyPrayerScreen extends ConsumerStatefulWidget {
  const DailyPrayerScreen({super.key});

  @override
  ConsumerState<DailyPrayerScreen> createState() => _DailyPrayerScreenState();
}

class _DailyPrayerScreenState extends ConsumerState<DailyPrayerScreen>
    with SingleTickerProviderStateMixin {
  bool _started = false;
  bool _completed = false;
  bool _sharePreviewReady = false;
  int _secondsElapsed = 0;
  Timer? _timer;
  Timer? _scrollTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(analyticsServiceProvider).logPrayerScreenShown(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPrayer(PrayerContent prayer) {
    ref.read(analyticsServiceProvider).logPrayerStarted(prayer.id);
    setState(() {
      _started = true;
      _secondsElapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() => _secondsElapsed = timer.tick);
    });
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (_scrollController.hasClients) {
        final next = _scrollController.offset + 0.7;
        if (next < _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(next);
        }
      }
    });
  }

  Future<void> _completePrayer(PrayerContent prayer) async {
    _timer?.cancel();
    _scrollTimer?.cancel();
    await ref
        .read(appControllerProvider.notifier)
        .completeTodayPrayer(prayer.id);
    await ref
        .read(analyticsServiceProvider)
        .logSharePromptShown('daily_prayer_completed');
    setState(() {
      _completed = true;
      _sharePreviewReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider).requireValue;
    final profile = appState.profile;
    final deity = ref.read(appControllerProvider.notifier).deityById(
          profile?.favouriteDeityId ?? 'ram',
        );
    final prayer = appState.seedContent.prayers.firstWhere(
      (item) => item.deityId == deity.id,
      orElse: () => appState.seedContent.prayers.first,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF7EC),
              Color(0xFFFFC870),
              Color(0xFFBE5A26),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _completed
                ? _PrayerRewardView(
                    key: const ValueKey('reward'),
                    deity: deity,
                    name: profile?.name ?? 'Bhakt',
                    onShare: () async {
                      final template = ref
                          .read(appControllerProvider.notifier)
                          .shareTemplate(
                            'daily_prayer_completed',
                          );
                      await ref
                          .read(analyticsServiceProvider)
                          .logShareClicked('daily_prayer_completed');
                      final result = await ref
                          .read(shareServiceProvider)
                          .shareToWhatsAppFirst(
                            card: ShareCardWidget(
                              title: template.title,
                              subtitle:
                                  "I completed today's prayer on Shanatani 🙏",
                              name: profile?.name ?? 'Bhakt',
                              highlight: deity.name,
                              watermark: template.watermark,
                              emoji: deity.emoji,
                            ),
                            message:
                                "I completed today's prayer on Shanatani 🙏\n${deity.blessing}",
                            fileName: 'daily_prayer_card.png',
                          );
                      if (result == ShareFlowResult.whatsappOpened) {
                        await ref
                            .read(analyticsServiceProvider)
                            .logWhatsAppShareClicked('daily_prayer_completed');
                      }
                      await ref
                          .read(appControllerProvider.notifier)
                          .incrementShareCount();
                    },
                    onSkip: () async {
                      await ref
                          .read(analyticsServiceProvider)
                          .logShareSkipped('daily_prayer_completed');
                      if (context.mounted) {
                        context.go('/today');
                      }
                    },
                    sharePreview: _sharePreviewReady
                        ? ShareCardWidget(
                            title: 'Daily Prayer Completed',
                            subtitle:
                                "I completed today's prayer on Shanatani 🙏",
                            name: profile?.name ?? 'Bhakt',
                            highlight: deity.name,
                            watermark: 'Made with Shanatani 🙏',
                            emoji: deity.emoji,
                          )
                        : null,
                  )
                : _started
                    ? _PrayerSessionView(
                        key: const ValueKey('session'),
                        deity: deity,
                        prayer: prayer,
                        secondsElapsed: _secondsElapsed,
                        scrollController: _scrollController,
                        onComplete: _secondsElapsed >= 5
                            ? () => _completePrayer(prayer)
                            : null,
                      )
                    : _PrayerStartView(
                        key: const ValueKey('start'),
                        deity: deity,
                        onStart: () => _startPrayer(prayer),
                        onSkip: () => context.go('/today'),
                      ),
          ),
        ),
      ),
    );
  }
}

class _PrayerStartView extends StatelessWidget {
  const _PrayerStartView({
    super.key,
    required this.deity,
    required this.onStart,
    required this.onSkip,
  });

  final Deity deity;
  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            deity.emoji,
            style: const TextStyle(fontSize: 108),
          ),
          const SizedBox(height: 18),
          Text(
            'Start your day with blessings 🙏',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Begin today’s short prayer flow in under a minute and build your streak with ${deity.name}.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onStart,
            child: const Text("Start Today's Prayer"),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: onSkip,
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerSessionView extends StatelessWidget {
  const _PrayerSessionView({
    super.key,
    required this.deity,
    required this.prayer,
    required this.secondsElapsed,
    required this.scrollController,
    required this.onComplete,
  });

  final Deity deity;
  final PrayerContent prayer;
  final int secondsElapsed;
  final ScrollController scrollController;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final completionReady = secondsElapsed >= 5;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Text(deity.emoji, style: const TextStyle(fontSize: 52)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prayer.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1.05),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: ShanataniColors.gold,
              size: 120,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('Bell / sound placeholder'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: prayer.verses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return Text(
                      prayer.verses[index],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(height: 1.7),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onComplete,
            child: Text(completionReady
                ? 'Mark as Completed'
                : 'Preparing blessings...'),
          ),
        ],
      ),
    );
  }
}

class _PrayerRewardView extends StatelessWidget {
  const _PrayerRewardView({
    super.key,
    required this.deity,
    required this.name,
    required this.onShare,
    required this.onSkip,
    required this.sharePreview,
  });

  final Deity deity;
  final String name;
  final Future<void> Function() onShare;
  final Future<void> Function() onSkip;
  final Widget? sharePreview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'You completed today’s prayer 🙏',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: sharePreview,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: ShanataniColors.whatsapp,
              foregroundColor: Colors.white,
            ),
            onPressed: onShare,
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share on WhatsApp'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onSkip,
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
