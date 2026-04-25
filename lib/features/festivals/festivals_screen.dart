import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/storage/app_controller.dart';
import '../premium/premium_widgets.dart';

class FestivalsScreen extends ConsumerWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivals = [
      ...ref.watch(appControllerProvider).requireValue.seedContent.festivals,
    ]..sort((a, b) => a.date.compareTo(b.date));

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: festivals.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == festivals.length) {
          return const PremiumWaitlistButton(
              label: 'Festival Pack Coming Soon');
        }
        final festival = festivals[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(18),
            title: Text(festival.title),
            subtitle: Text(DateFormat('dd MMM yyyy').format(festival.date)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/festivals/${festival.id}'),
          ),
        );
      },
    );
  }
}
