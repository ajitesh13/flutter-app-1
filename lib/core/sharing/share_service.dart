import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';

final shareServiceProvider = Provider<ShareService>((ref) => ShareService());

enum ShareFlowResult {
  whatsappOpened,
  sharedSheet,
}

class ShareService {
  final ScreenshotController _controller = ScreenshotController();

  Future<Uint8List> captureCard(Widget card) async {
    return _controller.captureFromWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildShanataniTheme(),
        home: Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: card),
          ),
        ),
      ),
      pixelRatio: 3,
    );
  }

  Future<File> saveCard(Uint8List bytes,
      {String fileName = 'shanatani_share.png'}) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<ShareFlowResult> shareToWhatsAppFirst({
    required Widget card,
    required String message,
    required String fileName,
  }) async {
    final bytes = await captureCard(card);
    final file = await saveCard(bytes, fileName: fileName);

    final whatsappUri =
        Uri.parse('whatsapp://send?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return ShareFlowResult.whatsappOpened;
    }

    await Share.shareXFiles(
      [XFile(file.path)],
      text: message,
      subject: 'Shanatani',
    );
    return ShareFlowResult.sharedSheet;
  }
}
