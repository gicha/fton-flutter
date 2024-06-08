import 'package:flutter/material.dart';
import 'package:fton/ui/pages/home/home_wm.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({super.key});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> with HomeViewPageWm {
  @override
  Widget build(BuildContext context) => const SizedBox();
}
