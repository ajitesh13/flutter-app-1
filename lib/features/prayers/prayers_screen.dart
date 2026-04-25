import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/app_controller.dart';

class PrayersScreen extends ConsumerWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayers =
        ref.watch(appControllerProvider).requireValue.seedContent.prayers;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: prayers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(18),
            title: Text(prayer.title),
            subtitle: Text(prayer.isPlaceholder
                ? 'Prayer text ready, audio/video coming soon'
                : 'Hindi text with transliteration and meaning'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/prayers/${prayer.id}'),
          ),
        );
      },
    );
  }
}
