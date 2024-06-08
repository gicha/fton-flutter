import 'package:flutter/material.dart';
import 'package:fton/ui/pages/home/home_wm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeWm {
  @override
  Widget build(BuildContext context) => const SizedBox();
}
