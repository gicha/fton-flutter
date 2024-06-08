import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_view.dart';

mixin StartViewPageWm on State<StartViewPage> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }
}
