
import 'package:akane_vote/models/menu_data.dart';
import 'package:akane_vote/screens/anime_corner_screen.dart';
import 'package:akane_vote/screens/home_screen.dart';
import 'package:akane_vote/screens/login_screen.dart';
import 'package:akane_vote/screens/splash_screen.dart';
import 'package:akane_vote/screens/webview_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: "/splash",
        name: "splash",
        builder: (context, state) {
          return const SplashScreen();
        }
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) {
          return LoginScreen();
        }
      ),
      GoRoute(
        path: "/home",
        name: "home",
        builder: (context, state) {
          return HomeScreen();
        }
      ),
      GoRoute(
        path: "/webview",
        name: "webview",
        builder: (context, state) {
          final extra = state.extra as Map<dynamic, dynamic>;

          final menuData = extra["menuData"] as MenuData;

          return WebviewScreen(menuData: menuData);
        },
      ),
      GoRoute(
        path: "/anime-corner",
        name: "anime-corner",
        builder: (context, state) {
          return AnimeCornerScreen();
        },
      ),
    ]
  );

  GoRouter get router => _router;
}