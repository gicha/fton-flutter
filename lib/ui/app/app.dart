import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_view.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TelegramThemeUtil.getTheme(TelegramWebApp.instance),
        home: const StartViewPage(),
      );
}
