import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/analytics/analytics_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/app_controller.dart';

class PremiumWaitlistButton extends ConsumerWidget {
  const PremiumWaitlistButton({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () async {
        await ref.read(analyticsServiceProvider).logPremiumButtonClicked(label);
        await ref.read(appControllerProvider.notifier).joinPremiumWaitlist();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppConstants.premiumInterestMessage)),
          );
        }
      },
      icon: const Icon(Icons.workspace_premium_rounded,
          color: ShanataniColors.gold),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        foregroundColor: ShanataniColors.maroon,
        side: const BorderSide(color: ShanataniColors.gold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
