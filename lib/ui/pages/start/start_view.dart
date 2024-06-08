import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_wm.dart';

class StartViewPage extends StatefulWidget {
  const StartViewPage({super.key});

  @override
  State<StartViewPage> createState() => _StartViewPageState();
}

class _StartViewPageState extends State<StartViewPage> with StartViewPageWm {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('FTON'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
