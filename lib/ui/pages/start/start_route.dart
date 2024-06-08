import 'package:fton/ui/pages/start/start_page.dart';
import 'package:go_router/go_router.dart';

class StartRoute extends GoRoute {
  StartRoute()
      : super(
          path: '/start',
          name: 'start',
          builder: (context, state) => const StartPage(),
          routes: [],
        );
}
