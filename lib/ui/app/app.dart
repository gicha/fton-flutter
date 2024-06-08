import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fton/extensions/telegram.dart';
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
    final app = context.app;
    final isAndroid = app.platform == 'android';
    final isLight = app.colorScheme.value == 'light';
    final theme = TelegramThemeUtil.getTheme(app);
    Locale? locale;
    try {
      locale = Locale(app.initData.user.languageCode);
    } catch (e) {
      locale = const Locale('en');
    }
    if (isAndroid) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'FTON',
        themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
        locale: locale,
        home: const StartViewPage(),
      );
    } else {
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: theme == null
            ? null
            : MaterialBasedCupertinoThemeData(materialTheme: theme),
        title: 'FTON',
        locale: locale,
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
