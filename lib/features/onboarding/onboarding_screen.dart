import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/analytics/analytics_service.dart';
import '../../core/models/app_models.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/storage/app_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  int _pageIndex = 0;
  String _language = 'Hindi';
  String _deityId = 'ram';
  bool _morningPrayer = true;
  bool _eveningAarti = true;
  bool _festivalReminders = true;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_pageIndex < 3) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    } else {
      final profile = UserProfile(
        name: _nameController.text.trim().isEmpty
            ? 'Bhakt'
            : _nameController.text.trim(),
        language: _language,
        favouriteDeityId: _deityId,
      );
      final reminders = ReminderPreferences(
        morningPrayer: _morningPrayer,
        eveningAarti: _eveningAarti,
        festivalReminders: _festivalReminders,
      );
      await ref.read(appControllerProvider.notifier).completeOnboarding(
            profile: profile,
            reminders: reminders,
          );
      await ref.read(notificationServiceProvider).requestPermission();
      await ref.read(notificationServiceProvider).syncPreferences(reminders);
      if (mounted) {
        context.go('/daily-prayer');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider).requireValue;
    final deities = appState.seedContent.deities;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5E6), Color(0xFFFFD49A), Color(0xFFF6A43F)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_pageIndex + 1) / 4,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(999),
                  color: ShanataniColors.saffron,
                  backgroundColor: Colors.white70,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) =>
                        setState(() => _pageIndex = value),
                    children: [
                      _OnboardingStep(
                        title: 'Choose your language',
                        subtitle:
                            'Hindi-first devotional experience for your daily prayer habit.',
                        child: Column(
                          children: ['Hindi', 'English']
                              .map(
                                (language) => RadioListTile<String>(
                                  value: language,
                                  groupValue: _language,
                                  title: Text(language),
                                  onChanged: (value) async {
                                    if (value == null) {
                                      return;
                                    }
                                    setState(() => _language = value);
                                    await ref
                                        .read(analyticsServiceProvider)
                                        .logLanguageSelected(value);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      _OnboardingStep(
                        title: 'Select your favourite deity',
                        subtitle:
                            'Your daily hook and blessings card will adapt around this choice.',
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: deities
                              .map(
                                (deity) => ChoiceChip(
                                  label: Text('${deity.emoji} ${deity.name}'),
                                  selected: deity.id == _deityId,
                                  onSelected: (_) async {
                                    setState(() => _deityId = deity.id);
                                    await ref
                                        .read(analyticsServiceProvider)
                                        .logDeitySelected(deity.id);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      _OnboardingStep(
                        title: 'What should we call you?',
                        subtitle:
                            'Your name will appear on share cards and today’s blessing screen.',
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            hintText: 'Enter your name',
                          ),
                        ),
                      ),
                      _OnboardingStep(
                        title: 'Choose reminders',
                        subtitle:
                            'We will ask for notification permission only after this step.',
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: _morningPrayer,
                              title: const Text('Morning prayer'),
                              onChanged: (value) =>
                                  setState(() => _morningPrayer = value),
                            ),
                            SwitchListTile(
                              value: _eveningAarti,
                              title: const Text('Evening aarti'),
                              onChanged: (value) =>
                                  setState(() => _eveningAarti = value),
                            ),
                            SwitchListTile(
                              value: _festivalReminders,
                              title: const Text('Festival reminders'),
                              onChanged: (value) =>
                                  setState(() => _festivalReminders = value),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child:
                      Text(_pageIndex == 3 ? 'Begin Daily Prayer' : 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(child: child)),
          ],
        ),
      ),
    );
  }
}
