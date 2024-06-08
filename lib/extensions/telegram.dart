import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

extension TelegramWebAppExt on BuildContext {
  TelegramWebApp get app => read<TelegramWebApp>();
}
