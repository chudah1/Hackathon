import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:go_router/go_router.dart';
import 'package:referency_application/services/authentication.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/views/custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  final _userController = AuthenticationService();

  /// This function validates user input and signs in the user if the input is valid.
  _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await _userController.signinUser(_email, _password);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.purpleAccent,
              title: Text(success ? "Success" : "Failure"),
              content: Text(success
                  ? "Logged In successfully"
                  : "Wrong email or Password"),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (success) {
                        String? idNumber =
                            auth.FirebaseAuth.instance.currentUser?.uid;
                        if (await DatabaseService().isFaculty(idNumber!)) {
                          context.goNamed("facultyView",
                              pathParameters: {"uid": idNumber});
                        } else {
                          context.goNamed("userProfile",
                              pathParameters: {"uid": idNumber});
                        }
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
              color: const Color(0xff764abc), child: const Text("Referency")),
          backgroundColor: const Color(0xff764abc),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.only(left: 40, right: 20, top: 10),
            child: Center(
                child: SizedBox(
                    width: double.maxFinite,
                    child: Row(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Image.asset("assets/images/secure.png")],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 700),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 50, top: 10),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    )),
                                Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomTextFormField(
                                            hintText: "Email",
                                            prefixIcon: Icons.email,
                                            onSaved: (value) => _email = value!,
                                            validator: (value) {
                                              return (value == null ||
                                                      value.isEmpty ||
                                                      !value.contains("@"))
                                                  ? 'Please enter a valid email'
                                                  : null;
                                            },
                                          ),
                                          CustomTextFormField(
                                            hintText: "password",
                                            prefixIcon: Icons.password,
                                            onSaved: (value) =>
                                                _password = value!,
                                            validator: (value) {
                                              return (value == null ||
                                                      value.isEmpty)
                                                  ? 'Please enter a password'
                                                  : null;
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: _login,
                                            icon: const Icon(
                                                Icons.app_registration),
                                            label: const Text("Submit"),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              backgroundColor:
                                                  const Color(0xff764abc),
                                              foregroundColor: Colors.black,
                                            ),
                                          )
                                        ]))
                              ]))
                    ]))
                    ))
                    );
  }
}
