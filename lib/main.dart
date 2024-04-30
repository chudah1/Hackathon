import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:referency_application/routes/routes.dart';

void main() async {
  /// `WidgetsFlutterBinding.ensureInitialized();` ensures that the Flutter binding is initialized before
  /// any other operation is performed. This is necessary to ensure that the Flutter framework is properly
  /// set up and ready to handle interactions with the platform.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyC2dh2qWt-9e__fcbatlSzKhP2LB3X25ZQ",
     appId: "1:1056727623601:web:a3564af50ceb9db7813f90", 
     storageBucket: "referency-79556.appspot.com",
     messagingSenderId: "1056727623601", projectId: "referency-79556")
  );
  Routes route = Routes();

  runApp(MaterialApp.router(
      title: "Referency", routerConfig: route.router));
}

