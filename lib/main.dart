import 'package:flutter/material.dart';
import 'package:fton/ui/app/app.dart';
import 'package:provider/provider.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() {
  runApp(
    Provider(
      create: (context) {
        final isTgMiniApp = TelegramWebApp.instance.isSupported;
        if (isTgMiniApp) {
          return TelegramWebApp.instance;
        } else {
          return TelegramWebAppFake();
        }
      },
      builder: (context, child) => const App(),
    ),
  );
}
