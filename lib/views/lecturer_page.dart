import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/views/faculty_requests_received.dart';

class LecturerPage extends StatelessWidget {
  final String uid;

  const LecturerPage({super.key, required this.uid});

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
              title: const Text('Requests'),
              children: [
                ListTile(
                  title: const Text('Requests Received'),
                  onTap: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestReceived(facultyEmail: FirebaseAuth.instance.currentUser!.email!)));
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
      body: const Center(
        child: Text('Main Content'),
      ),
    );
  }
}
