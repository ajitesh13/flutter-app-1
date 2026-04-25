import 'package:flutter/material.dart';

import '../../app/theme.dart';

class ShareCardWidget extends StatelessWidget {
  const ShareCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.name,
    required this.highlight,
    required this.watermark,
    required this.emoji,
    this.square = false,
  });

  final String title;
  final String subtitle;
  final String name;
  final String highlight;
  final String watermark;
  final String emoji;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: square ? 1080 : 1080,
      height: square ? 1080 : 1920,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF0D0),
            Color(0xFFFDB356),
            Color(0xFFB13B1B),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 0.9,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: ShanataniColors.maroon,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withOpacity(0.24)),
                  ),
                  child: Text(
                    '$name • $highlight',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  watermark,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
