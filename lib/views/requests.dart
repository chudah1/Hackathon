import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';
import 'package:http/http.dart' as http;

class RequestListPage extends StatelessWidget {
  final String uid;

  const RequestListPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().studentRequests(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final requests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final String facultyEmail = requests[index]['facultyEmail'];
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      // Navigate to the view request page
                      // You can use Navigator.push to navigate to the view request page
                    },
                    child: Text(facultyEmail),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await http.get(Uri.parse(
                          'https://us-central1-email-messenger-8212c.cloudfunctions.net/sendMail?dest=$facultyEmail'));
                      DatabaseService().updateSent(requests[index].id);
                    },
                    child: const Text('Send'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
