import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/utils/opportunity_form.dart';
import 'package:referency_application/utils/request_form.dart';
import 'package:referency_application/views/opportunities.dart';
import 'package:referency_application/views/profile_form.dart';
import 'package:referency_application/views/requests.dart';
import 'package:referency_application/views/student_requests.dart';
import 'package:referency_application/views/view_student_profile.dart';

class MyHomePage extends StatelessWidget {
  final String uid;

  const MyHomePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referency Application'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              accountName: FutureBuilder<String?>(
                future: DatabaseService().getUser(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    );
                  }
                },
              ),
              currentAccountPicture:
                  Image.asset("assets/images/avatar_image.jpg"),
              decoration: const BoxDecoration(
                color: Color(0xff764abc),
              ),
            ),
            ExpansionTile(
              title: const Text('Opportunities'),
              children: [
                ListTile(
                  title: const Text('Create an Opportunity'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpportunityForm(uid: uid)));
                  },
                ),
                ListTile(
                  title: const Text('View All Opportunities'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Opportunities(uid: uid)));
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Requests'),
              children: [
                ListTile(
                  title: const Text('Create a Request'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestForm(uid: uid)));
                  },
                ),
                ListTile(
                  title: const Text('View All Requests'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestListPage(uid: uid)));
                  },
                ),
                ListTile(
                  title: const Text('View Sent Requests'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestSent(uid: uid)));
                  },
                )
              ],
            ),
              ExpansionTile(
              title: const Text('Profile'),
              children: [
            ListTile(
              title: const Text('Update Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentForm(uid: uid)));
              },
              ),
                ListTile(
                  title: const Text('View Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentProfile(uid: uid)));
                  },
                ),
              ],
            ),

            ListTile(
              title: const Text('Sign Out'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.goNamed('login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.asset('assets/images/llm_gen.png'),
      ),
    );
  }
}
