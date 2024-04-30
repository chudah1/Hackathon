import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> signupUser(String email, String password, String fname, String lname,
      bool isFaculty, BuildContext context) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseService()
          .saveUser(credential.user!.uid, fname, lname, email, isFaculty);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Registration successful")));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("the password is too weak")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("the email is already in use")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not create User")));
    }
    return false;

  }

  Future<bool> signinUser(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  // Check if the user is logged in
  User? currUser() {
    bool loggedIn = _auth.currentUser == null;
    if (loggedIn == true) return _auth.currentUser;
    return null;
  }
}
