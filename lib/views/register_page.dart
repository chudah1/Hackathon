import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referency_application/services/authentication.dart';
import 'package:referency_application/views/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userController = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String _fname = "";
  String _lname = "";
  String _email = "";
  String _password = "";
  bool _faculty = true;

  /// This function creates a user profile and saves it to the database.
  void _createProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await AuthenticationService()
          .signupUser(_email, _password, _fname, _lname, _faculty, context);

      /// The above code is showing an AlertDialog with a title and content based on whether a profile was
      /// successfully created or not. It also has an "OK" button that dismisses the dialog and navigates to
      /// the login screen if the profile was successfully created.
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.purpleAccent,
              title: Text(success ? "Success" : "Failure"),
              content: Text(success
                  ? "Profile created successfully"
                  : "Failed to create User"),
              actions: [
                TextButton(
                    onPressed: () {
                      if (success) {
                        print("Navigating to Login");
                        context.goNamed('login');
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
          title:
              Title(color: Colors.purpleAccent, child: const Text("Referency")),
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 20, top: 10),
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Row(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Image.asset("assets/images/collab.png")],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 50, top: 10),
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          )),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: [
                              CustomTextFormField(
                                hintText: "First name",
                                prefixIcon: Icons.person,
                                onSaved: (value) => _fname = value!,
                                validator: (value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Please enter your first name'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              CustomTextFormField(
                                hintText: "Last name",
                                prefixIcon: Icons.person,
                                onSaved: (value) => _lname = value!,
                                validator: (value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Please enter your last name'
                                      : null;
                                },
                              )
                            ]),
                            Row(children: [
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
                              const SizedBox(
                                width: 30,
                              ),
                              CustomTextFormField(
                                hintText: "password",
                                prefixIcon: Icons.password,
                                onSaved: (value) => _password = value!,
                                validator: (value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Please enter a password'
                                      : null;
                                },
                              )
                            ]),
                            Row(children: [
                              SizedBox(
                                height: 100,
                                child: SizedBox(
                                  width: 250,
                                  child: CheckboxListTile(
                                      title: const Text("Faculty"),
                                      value: _faculty,
                                      onChanged: ((value) {
                                        setState(() {
                                          _faculty = value ?? false;
                                        });
                                      })),
                                ),
                              )
                            ]),
                            const SizedBox(
                              height: 0,
                            ),
                            ElevatedButton.icon(
                              onPressed: _createProfile,
                              icon: const Icon(Icons.app_registration),
                              label: const Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: const Color(0xff764abc),
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        )));
        
  }
}
