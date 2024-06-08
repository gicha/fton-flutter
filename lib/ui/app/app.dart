import 'package:flutter/cupertino.dart';
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
  Widget build(BuildContext context) {
    final isAndroid = TelegramWebApp.instance.platform == 'android';
    final isLight = TelegramWebApp.instance.colorScheme.value == 'light';
    final theme = TelegramThemeUtil.getTheme(TelegramWebApp.instance);
    if (isAndroid) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'FTON',
        themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
        home: const StartViewPage(),
      );
    } else {
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: theme == null
            ? null
            : MaterialBasedCupertinoThemeData(materialTheme: theme),
        title: 'FTON',
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: const StartViewPage(),
      );
    }
  }
}
