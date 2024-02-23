import 'dart:developer';

import 'package:course_guide/content/CRUDView.dart';
import 'package:course_guide/content/CourseView.dart';
import 'package:course_guide/login/VerifyEmail.dart';
import 'package:course_guide/login/WelcomeLogin.dart';
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

  //

  static final GlobalKey<NavigatorState> loginNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> CRUDViewSuperAdminKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> CRUDViewAdminKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> CourseViewKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> userEventNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> profileNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String defaultPath = '/';
  static const String loginPath = '/login';
  static const String verifyEmailPath = '/login/verify-email';
  static const String forgotPasswordPath = '/login/forgot-password';

  static const String CRUDViewSuperAdminPath = '/adminHome';
  static const String CRUDViewAdminPath = '/userHome';

  static const String CourseViewPath = '/adminEvent';
  static const String userEventPath = '/userEvent';

  static const String profilePath = '/profile';

  static const String adminAnnouncementPath = '/AdminAnnouncementPage';
  static const String userAnnouncementPath = '/announcementPage';

  static const String adminViewAttendancePath = '/AdminViewAttendance';
  static const String adminViewSignUpPath = '/AdminViewSignUp';

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
                    path: defaultPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const AuthGate(),
                        state: state,
                      );
                    }),
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
                GoRoute(
                    path: verifyEmailPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const VerifyEmail(),
                        state: state,
                      );
                    }),
              ]),
          //SUPER ADMIN
          StatefulShellBranch(
              navigatorKey: CRUDViewSuperAdminKey,
              initialLocation: CRUDViewSuperAdminPath,
              routes: [
                GoRoute(
                  path: CRUDViewSuperAdminPath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const CRUDView(),
                      state: state,
                    );
                  },
                ),
              ]),
          //ADMIN
          StatefulShellBranch(
              navigatorKey: CRUDViewAdminKey,
              initialLocation: CRUDViewAdminPath,
              routes: [
                GoRoute(
                    path: CRUDViewAdminPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const CRUDView(),
                        state: state,
                      );
                    }),
              ]),
          //REGULAR USER
          StatefulShellBranch(
              navigatorKey: CourseViewKey,
              initialLocation: CourseViewPath,
              routes: [
                GoRoute(
                    path: CourseViewPath,
                    pageBuilder: (context, GoRouterState state) {
                      return getPage(
                        child: const CourseView(),
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

// import 'dart:developer';

// import 'package:course_guide/content/CRUDView.dart';
// import 'package:course_guide/content/CourseView.dart';
// import 'package:course_guide/login/VerifyEmail.dart';
// import 'package:course_guide/login/WelcomeLogin.dart';
// import 'package:course_guide/content/placeholder.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'NavigationLoginPage.dart';

// class MyNavigator {
//   static final MyNavigator _instance = MyNavigator._internal();

//   static MyNavigator get instance => _instance;
//   factory MyNavigator() {
//     return _instance;
//   }

//   static late StatefulNavigationShell _navigationShell;
//   static StatefulNavigationShell get shell => _navigationShell;

//   static late final GoRouter router;

//   static late int _navigationbarIndex;
//   static int get navigationbarIndex => _navigationbarIndex;

//   static final GlobalKey<NavigatorState> parentNavigatorKey =
//       GlobalKey<NavigatorState>();

//   //

//   static final GlobalKey<NavigatorState> loginNavigatorKey =
//       GlobalKey<NavigatorState>();

//   static final GlobalKey<NavigatorState> courseViewKey =
//       GlobalKey<NavigatorState>();

//   static final GlobalKey<NavigatorState> CRUDViewKeySuperAdmin =
//       GlobalKey<NavigatorState>();

//   static final GlobalKey<NavigatorState> CRUDViewKeyAdmin =
//       GlobalKey<NavigatorState>();

//   static final GlobalKey<NavigatorState> permissionsViewKey =
//       GlobalKey<NavigatorState>();

//   static final GlobalKey<NavigatorState> profileKey =
//       GlobalKey<NavigatorState>();

//   static const String defaultPath = '/';
//   static const String loginPath = '/login';
//   static const String verifyEmailPath = '/login/verify-email';
//   static const String forgotPasswordPath = '/login/forgot-password';

//   //NEW TO IMPLEMENT
//   static const String courseViewPath = '/course-view';
//   static const String CRUDViewPath = '/crud-view';
//   static const String permissionsViewPath = '/permissions-view';
//   static const String profilePath = '/profile';

//   MyNavigator._internal() {
//     final routes = [
//       StatefulShellRoute.indexedStack(
//         parentNavigatorKey: parentNavigatorKey,
//         branches: [
//           //LOGIN
//           StatefulShellBranch(
//               navigatorKey: loginNavigatorKey,
//               initialLocation: loginPath,
//               routes: [
//                 GoRoute(
//                     path: defaultPath,
//                     pageBuilder: (context, GoRouterState state) {
//                       return getPage(
//                         child: const AuthGate(),
//                         state: state,
//                       );
//                     }),
//                 GoRoute(
//                     path: loginPath,
//                     pageBuilder: (context, GoRouterState state) {
//                       return getPage(
//                         child: const AuthGate(),
//                         state: state,
//                       );
//                     }),
//                 GoRoute(
//                     path: forgotPasswordPath,
//                     pageBuilder: (context, GoRouterState state) {
//                       final arguments = state.uri.queryParameters;
//                       return getPage(
//                         child: ForgotPasswordScreen(
//                           email: arguments['email'],
//                           headerMaxExtent: 200,
//                         ),
//                         state: state,
//                       );
//                     }),
//                 GoRoute(
//                     path: verifyEmailPath,
//                     pageBuilder: (context, GoRouterState state) {
//                       return getPage(
//                         child: const VerifyEmail(),
//                         state: state,
//                       );
//                     }),
//               ]),
//           //SUPER ADMIN
//           StatefulShellBranch(
//               navigatorKey: CRUDViewKeySuperAdmin,
//               initialLocation: CRUDViewPath,
//               routes: [
//                 GoRoute(
//                   path: CRUDViewPath,
//                   pageBuilder: (context, GoRouterState state) {
//                     return getPage(
//                       child: const CRUDView(),
//                       state: state,
//                     );
//                   },
//                 ),
//               ]),
//           //ADMIN
//           StatefulShellBranch(
//               navigatorKey: CRUDViewKeyAdmin,
//               initialLocation: CRUDViewPath,
//               routes: [
//                 GoRoute(
//                   path: CRUDViewPath,
//                   pageBuilder: (context, GoRouterState state) {
//                     return getPage(
//                       child: const CRUDView(),
//                       state: state,
//                     );
//                   },
//                 ),
//               ]),
//           //REGULAR USER
//           StatefulShellBranch(
//               navigatorKey: courseViewKey,
//               initialLocation: courseViewPath,
//               routes: [
//                 GoRoute(
//                   path: courseViewPath,
//                   pageBuilder: (context, GoRouterState state) {
//                     return getPage(
//                       child: const CourseView(),
//                       state: state,
//                     );
//                   },
//                 ),
//               ]),
//         ],
//         pageBuilder: (
//           BuildContext context,
//           GoRouterState state,
//           StatefulNavigationShell navigationShell,
//         ) {
//           _navigationShell = navigationShell;
//           return getPage(
//             child: NavigationLoginPage(child: navigationShell),
//             state: state,
//           );
//         },
//       )
//     ];
//     router = GoRouter(
//       navigatorKey: parentNavigatorKey,
//       initialLocation: loginPath,
//       routes: routes,
//     );
//   }

//   static Page getPage({
//     required Widget child,
//     required GoRouterState state,
//   }) {
//     log(shell.currentIndex.toString());
//     log(router.routeInformationProvider.toString());
//     return MaterialPage(
//       key: state.pageKey,
//       child: child,
//     );
//   }
// }
