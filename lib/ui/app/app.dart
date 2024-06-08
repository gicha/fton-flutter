import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartViewPage(),
      );
    } else {
      return const CupertinoApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [DefaultMaterialLocalizations.delegate],
        home: ScaffoldMessenger(
          child: StartViewPage(),
        ),
      );
    }
  }
}
