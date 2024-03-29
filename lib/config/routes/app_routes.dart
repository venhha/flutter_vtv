import 'package:flutter/material.dart';
// import 'package:flutter_vtv/features/search/presentation/pages/search_products_page.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/pages/dev_page.dart';
import '../../core/presentation/pages/intro_page.dart';
import '../../core/presentation/pages/main_page.dart';
import '../../features/auth/domain/entities/user_info_entity.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/user_detail_page.dart';
import '../../features/auth/presentation/pages/user_home_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import 'extra_codec.dart';

part 'routes.dart';

// config bottom navigation bar in 'lib\core\presentation\pages\main_page.dart'

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE: Only set this to true for debugging
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    extraCodec: const MyExtraCodec(),
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      // Application Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainPage(child: child);
        },
        routes: _routes, // config in routes.dart
      ),
      // Other Route not in Shell (not in bottom navigation bar)
      GoRoute(
        path: '/intro',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroPage();
        },
      ),
      GoRoute(
        path: DevPage.routeName, // '/dev'
        builder: (context, state) => const DevPage(),
      ),
    ],
  );
}
