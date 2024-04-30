import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:referency_application/services/database.dart';

class RequestSent extends StatelessWidget {
  final String uid;

  const RequestSent({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().studentRequestsSent(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No requests sent yet.'),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var request = snapshot.data!.docs[index];
            return RequestSentItem(
              opportunityName: request['opportunity']['name'],
              facultyEmail: request['facultyEmail'],
            );
          },
        );
      },
    );
  }
}

class RequestSentItem extends StatelessWidget {
  final String opportunityName;
  final String facultyEmail;

  const RequestSentItem({super.key, 
    required this.opportunityName,
    required this.facultyEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            opportunityName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            'Faculty Email: $facultyEmail',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.school,
              color: Colors.white,
            ),
          ),
          onTap: () {
            // Handle tap
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
