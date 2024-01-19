import 'package:chat/app/config/routes/named_routes.dart';
import 'package:chat/app/modules/auth/views/homepage_screen.dart';
import 'package:chat/app/modules/auth/views/location_screen.dart';
import 'package:chat/app/modules/auth/views/profile_screen.dart';
import 'package:chat/app/modules/auth/views/register.dart';
import 'package:chat/app/modules/auth/views/splash_screen.dart';
import 'package:chat/app/modules/chats/domain/models/user_model.dart';
import 'package:chat/app/modules/navbar/views/navbar_screen.dart';
import 'package:chat/app/modules/navbar/widgets/bottom_navbar_tabs.dart';
import 'package:chat/app/modules/one_to_one_chat/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///[rootNavigatorKey] used for global | general navigation
final rootNavigatorKey = GlobalKey<NavigatorState>();

///[shellNavigatorKey] used for nesting routes within bottom nav bar (stickey bottom nav bar)
final shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const SizedBox();

  /// use this in [MaterialApp.router]
  static final _router = GoRouter(
    initialLocation: MyNamedRoutes.root,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // outside the [ShellRoute] to make the screen on top of the [BottomNavBar]
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: MyNamedRoutes.root,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: "/${MyNamedRoutes.register}",
        name: MyNamedRoutes.register,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: RegisterScreen(),
        ),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(
            tabs: BottomNavBarTabs.tabs(context),
            child: child,
          );
        },
        routes: [
          // home
          GoRoute(
              path: "/${MyNamedRoutes.homePage}",
              name: MyNamedRoutes.homePage,
              pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const HomePage(),
                  ),
              routes: [
                //chatDetails
                GoRoute(
                  path: MyNamedRoutes.chatDetails,
                  name: MyNamedRoutes.chatDetails,
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child:
                        OneToOneMessagingScreen(user: state.extra as UserModel),
                  ),
                ),
              ]),
          // locations
          GoRoute(
            path: "/${MyNamedRoutes.locations}",
            name: MyNamedRoutes.locations,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LocationsScreen(),
            ),
          ),
          // profile
          GoRoute(
            path: "/${MyNamedRoutes.profile}",
            name: MyNamedRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: errorWidget,
  );

  static GoRouter get router => _router;
}
