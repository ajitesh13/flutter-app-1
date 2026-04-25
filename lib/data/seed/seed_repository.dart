import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/app_models.dart';

final seedRepositoryProvider = Provider<SeedRepository>((ref) {
  return const SeedRepository();
});

class SeedRepository {
  const SeedRepository();

  Future<SeedContent> load() async {
    final deitiesJson =
        await rootBundle.loadString('lib/data/seed/deities.json');
    final prayersJson =
        await rootBundle.loadString('lib/data/seed/prayers.json');
    final festivalsJson =
        await rootBundle.loadString('lib/data/seed/festivals.json');
    final shareTemplatesJson =
        await rootBundle.loadString('lib/data/seed/share_templates.json');

    return SeedContent(
      deities: (jsonDecode(deitiesJson) as List<dynamic>)
          .map((item) => Deity.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      prayers: (jsonDecode(prayersJson) as List<dynamic>)
          .map((item) =>
              PrayerContent.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      festivals: (jsonDecode(festivalsJson) as List<dynamic>)
          .map((item) =>
              Festival.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      shareTemplates: (jsonDecode(shareTemplatesJson) as List<dynamic>)
          .map((item) =>
              ShareTemplate.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}
