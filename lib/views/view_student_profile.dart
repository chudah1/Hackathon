import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentProfile extends StatelessWidget {
  final String uid;

  const StudentProfile({Key? key, required this.uid});

  Future<void> _launchUrl(String url) async {
    if (!(await canLaunchUrl(Uri.parse(url)))) {
      throw Exception('Could not launch $url');
    } else {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: DatabaseService().getUser(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(
                '${snapshot.data} Profile',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              );
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('User Profile does not exist yet'),
            );
          }
          // Document exists, display its contents
          var documentData = snapshot.data;
          if (documentData == null) {
            return const Center(
              child: Text('User Profile data is null'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileInfoRow(
                      label: 'Name',
                      value: '${documentData['fname']} ${documentData['lname']}',
                    ),
                    const SizedBox(width: 100),
                  ProfileInfoRow(
                    label: 'Major',
                    value: documentData['major'],
                  ),
                   const SizedBox(width: 100),
                    ProfileInfoRow(
                  label: 'Graduation Year',
                  value: documentData['grad_Year'],
                ),
                const SizedBox(width: 100),
                  ProfileInfoRow(
                  label: 'CGPA',
                  value: documentData['CGPA'],
                ),
                  ],
                ),
             
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileInfoRow(
                      label: 'Capstone Project',
                      value: documentData['capstoneInfo']['Project worked on'],
                    ),
                    ProfileInfoRow(
                      label: 'Capstone Advisor',
                      value: documentData['capstoneInfo']['Capstone Advisor'],
                    ),
                    ProfileInfoRow(
                      label: 'Capstone Grade',
                      value: documentData['capstoneInfo']['Grade Acheived'],
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                ElevatedButton.icon(
                  onPressed: () {
                    _launchUrl(documentData['resume_url']);
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View Resume'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    _launchUrl(documentData['transcript_url']);
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View Transcript'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
