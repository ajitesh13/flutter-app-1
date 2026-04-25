import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/models/app_models.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/storage/app_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appControllerProvider).requireValue;
    final controller = ref.read(appControllerProvider.notifier);
    final deity =
        controller.deityById(appState.profile?.favouriteDeityId ?? 'ram');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appState.profile?.name ?? 'Bhakt',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text('Language: ${appState.profile?.language ?? 'Hindi'}'),
                const SizedBox(height: 6),
                Text('Favourite deity: ${deity.name}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _StatTile(label: 'Prayer streak', value: '${appState.prayerStreak}'),
        _StatTile(label: 'Mandir streak', value: '${appState.mandirStreak}'),
        _StatTile(label: 'Share stats', value: '${appState.shareCount}'),
        _StatTile(
          label: 'Premium waitlist status',
          value: appState.premiumWaitlistJoined ? 'Joined' : 'Not joined',
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder preferences',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: appState.reminderPreferences.morningPrayer,
                  title: const Text('Morning prayer'),
                  onChanged: (value) => _updateReminder(
                    ref,
                    context,
                    appState.reminderPreferences.copyWith(morningPrayer: value),
                    'morning_prayer',
                  ),
                ),
                SwitchListTile(
                  value: appState.reminderPreferences.eveningAarti,
                  title: const Text('Evening aarti'),
                  onChanged: (value) => _updateReminder(
                    ref,
                    context,
                    appState.reminderPreferences.copyWith(eveningAarti: value),
                    'evening_aarti',
                  ),
                ),
                SwitchListTile(
                  value: appState.reminderPreferences.festivalReminders,
                  title: const Text('Festival reminders'),
                  onChanged: (value) => _updateReminder(
                    ref,
                    context,
                    appState.reminderPreferences
                        .copyWith(festivalReminders: value),
                    'festival',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const _PlaceholderTile(
            title: 'Privacy Policy', body: 'Privacy policy placeholder'),
        const SizedBox(height: 10),
        const _PlaceholderTile(title: 'Terms', body: 'Terms placeholder'),
      ],
    );
  }

  Future<void> _updateReminder(
    WidgetRef ref,
    BuildContext context,
    ReminderPreferences reminders,
    String key,
  ) async {
    await ref.read(appControllerProvider.notifier).updateReminders(reminders);
    await ref.read(notificationServiceProvider).syncPreferences(reminders);
    await ref.read(analyticsServiceProvider).logReminderEnabled(
          key,
          key == 'morning_prayer'
              ? reminders.morningPrayer
              : key == 'evening_aarti'
                  ? reminders.eveningAarti
                  : reminders.festivalReminders,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder preferences updated.')),
      );
    }
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }
}
