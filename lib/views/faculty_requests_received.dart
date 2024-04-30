import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/views/faculty_view_detailed_request.dart';

class RequestReceived extends StatelessWidget {
  final String facultyEmail;

  const RequestReceived({super.key, required this.facultyEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().viewRequestsReceived(facultyEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  "No requests received yet",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var request = snapshot.data!.docs[index];
            var studentID = request['studentID'];
            String studentName = "";
            DatabaseService().getUser(studentID);

            return RequestReceivedItem(
              opportunityDesc: request['opportunity']['description'],
              requestID: request.id,
            );
          },
        );
      },
    );
  }
}

class RequestReceivedItem extends StatelessWidget {
  final String opportunityDesc;
  final String requestID;
  

  const RequestReceivedItem(
      {super.key, required this.opportunityDesc, required this.requestID});

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
            opportunityDesc,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RequestDetail(requestID: requestID)));
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
