import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referency_application/views/home.dart';
import 'package:referency_application/views/lecturer_page.dart';
import 'package:referency_application/views/login.dart';
import 'package:referency_application/views/student_menu.dart';
import 'package:referency_application/views/register_page.dart';

class Routes {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        name: "home",
        path: "/",
        builder: (BuildContext context, GoRouterState state) => const Home(),
      ),
      GoRoute(
        name: "userProfile",
        path: "/users/students/:uid",
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return MyHomePage(uid: uid);
        },
      ),

      GoRoute(
        name: "facultyView",
        path: "/users/faculty/:uid",
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return LecturerPage(uid: uid);
        },
      ),

      GoRoute(
        name: "register",
        path: "/register",
        builder: ((context, state) => const RegisterPage()),
      ),
      GoRoute(
        name: "login",
        path: "/login",
        builder: ((context, state) => const LoginPage()),
      ),
    ],
  );

  GoRouter get router => _router;
}
