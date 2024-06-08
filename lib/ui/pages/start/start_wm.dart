import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_page.dart';

mixin StartPageWm on State<StartPage> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }
}
