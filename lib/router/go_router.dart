import 'package:fton/ui/pages/start/start_page.dart';
import 'package:fton/ui/pages/start/start_route.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter() => GoRouter(
        debugLogDiagnostics: true,
        redirect: (context, state) async => '/',
        errorBuilder: (context, state) => const StartPage(),
        routes: [StartRoute()],
      );
}
