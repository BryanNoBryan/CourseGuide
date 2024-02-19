import 'dart:developer';

import 'package:course_guide/content/auth_gate.dart';
import 'package:course_guide/content/placeholder.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'NavigationLoginPage.dart';

class MyNavigator {
  static final MyNavigator _instance = MyNavigator._internal();

  static MyNavigator get instance => _instance;
  factory MyNavigator() {
    return _instance;
  }

  static late StatefulNavigationShell _navigationShell;
  static StatefulNavigationShell get shell => _navigationShell;

  static late final GoRouter router;

  static late int _navigationbarIndex;
  static int get navigationbarIndex => _navigationbarIndex;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> loginNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> forgotPasswordNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> adminHomeNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> userHomeNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> adminEventNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> userEventNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> profileNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String loginPath = '/login';
  static const String forgotPasswordPath = '/login/forgot-password';

  static const String adminHomePath = '/adminHome';
  static const String userHomePath = '/userHome';

  static const String adminEventPath = '/adminEvent';
  static const String userEventPath = '/userEvent';

  static const String profilePath = '/profile';

  static const String adminAnnouncementPath = '/AdminAnnouncementPage';
  static const String userAnnouncementPath = '/announcementPage';

  static const String adminViewAttendance = '/AdminViewAttendance';
  static const String adminViewSignUp = '/AdminViewSignUp';

  MyNavigator._internal() {
    final routes = [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
              navigatorKey: loginNavigatorKey,
              initialLocation: loginPath,
              routes: [
                GoRoute(
                    path: loginPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const AuthGate(),
                        state: state,
                      );
                    }),
                GoRoute(
                    path: forgotPasswordPath,
                    pageBuilder: (context, GoRouterState state) {
                      final arguments = state.uri.queryParameters;
                      return getPage(
                        child: ForgotPasswordScreen(
                          email: arguments['email'],
                          headerMaxExtent: 200,
                        ),
                        state: state,
                      );
                    }),
              ]),
          StatefulShellBranch(
              navigatorKey: adminHomeNavigatorKey,
              initialLocation: adminHomePath,
              routes: [
                GoRoute(
                  path: adminHomePath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const temptest(),
                      state: state,
                    );
                  },
                ),
                GoRoute(
                    path: adminAnnouncementPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
                GoRoute(
                    path: adminViewAttendance,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
                GoRoute(
                    path: adminViewSignUp,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: temptest(),
                        state: state,
                      );
                    }),
              ]),
          StatefulShellBranch(
              navigatorKey: userHomeNavigatorKey,
              initialLocation: userHomePath,
              routes: [
                GoRoute(
                    path: userHomePath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
                GoRoute(
                    path: userAnnouncementPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
              ]),
          StatefulShellBranch(
              navigatorKey: adminEventNavigatorKey,
              initialLocation: adminEventPath,
              routes: [
                GoRoute(
                    path: adminEventPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
              ]),
          StatefulShellBranch(
              navigatorKey: userEventNavigatorKey,
              initialLocation: userEventPath,
              routes: [
                GoRoute(
                    path: userEventPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
              ]),
          StatefulShellBranch(
              navigatorKey: profileNavigatorKey,
              initialLocation: profilePath,
              routes: [
                GoRoute(
                    path: profilePath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const temptest(),
                        state: state,
                      );
                    }),
              ]),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          _navigationShell = navigationShell;
          return getPage(
            child: NavigationLoginPage(child: navigationShell),
            state: state,
          );
        },
      )
    ];
    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: loginPath,
      routes: routes,
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
