import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/sharing/share_card.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/app_controller.dart';

class MandirScreen extends ConsumerStatefulWidget {
  const MandirScreen({super.key});

  @override
  ConsumerState<MandirScreen> createState() => _MandirScreenState();
}

class _MandirScreenState extends ConsumerState<MandirScreen> {
  String? _selectedDeityId;
  int _chantCounter = 0;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider).requireValue;
    final deities = appState.seedContent.deities;
    final profile = appState.profile;
    _selectedDeityId ??= profile?.favouriteDeityId ?? deities.first.id;
    final selectedDeity =
        ref.read(appControllerProvider.notifier).deityById(_selectedDeityId!);

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
                  'Virtual Mandir',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedDeityId,
                  items: deities
                      .map(
                        (deity) => DropdownMenuItem(
                          value: deity.id,
                          child: Text('${deity.emoji} ${deity.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedDeityId = value),
                  decoration: const InputDecoration(labelText: 'Select deity'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    selectedDeity.emoji,
                    style: const TextStyle(fontSize: 96),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () async {
                await ref.read(analyticsServiceProvider).logDiyaLit();
                await ref
                    .read(appControllerProvider.notifier)
                    .recordMandirVisit();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Diya lit in your virtual mandir.')),
                  );
                }
              },
              icon: const Icon(Icons.local_fire_department_rounded),
              label: const Text('Light diya'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(analyticsServiceProvider).logFlowerOffered();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Flower offered with devotion.')),
                  );
                }
              },
              icon: const Icon(Icons.local_florist_rounded),
              label: const Text('Offer flower'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(analyticsServiceProvider).logBellRang();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mandir bell rang.')),
                  );
                }
              },
              icon: const Icon(Icons.notifications_active_rounded),
              label: const Text('Ring bell'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: Text('Chant counter: $_chantCounter')),
                FilledButton(
                  onPressed: () => setState(() => _chantCounter += 1),
                  child: const Text('Add chant'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Daily mandir streak: ${appState.mandirStreak}'),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final template = ref
                .read(appControllerProvider.notifier)
                .shareTemplate('diya_lit');
            await ref
                .read(analyticsServiceProvider)
                .logShareClicked('diya_lit');
            await ref.read(shareServiceProvider).shareToWhatsAppFirst(
                  card: ShareCardWidget(
                    title: template.title,
                    subtitle: 'I lit a diya today',
                    name: profile?.name ?? 'Bhakt',
                    highlight: selectedDeity.name,
                    watermark: template.watermark,
                    emoji: selectedDeity.emoji,
                  ),
                  message: 'I lit a diya today on Shanatani 🙏',
                  fileName: 'diya_lit_card.png',
                );
            await ref
                .read(appControllerProvider.notifier)
                .incrementShareCount();
          },
          icon: const Icon(Icons.share_rounded),
          label: const Text('Share on WhatsApp CTA'),
        ),
      ],
    );
  }
}
