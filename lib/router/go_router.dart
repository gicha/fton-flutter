import 'package:fton/ui/pages/start/start_route.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter(String initLocation) => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: initLocation,
        routes: [
          StartRoute(),
        ],
      );
}
