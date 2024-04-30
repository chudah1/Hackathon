import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:referency_application/views/generate_inference.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetail extends StatelessWidget {
  final String requestID;

  const RequestDetail({Key? key, required this.requestID});

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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('requests')
            .doc(requestID)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              child: Text('Request Details could not be retrieved'),
            );
          }
          // Document exists, display its contents
          var requestData = snapshot.data;
          if (requestData == null) {
            return const Center(
              child: Text('Request Details not found'),
            );
          }
          String studentID = requestData['studentID'];
          var classes = requestData['classes'] as List<dynamic>;
          var projects = requestData['projects'] as List<dynamic>;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(studentID)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        var studentData = snapshot.data;
                        if (studentData == null) {
                          return const Center(
                            child: Text('User Profile data is null'),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ProfileInfoRow(
                              label: 'Name',
                              value:
                                  '${studentData['fname']} ${studentData['lname']}',
                            ),
                            const SizedBox(width: 100),
                            ProfileInfoRow(
                              label: 'Major',
                              value: studentData['major'],
                            ),
                            const SizedBox(width: 100),
                            ProfileInfoRow(
                              label: 'Graduation Year',
                              value: studentData['grad_Year'],
                            ),
                            const SizedBox(width: 100),
                            ProfileInfoRow(
                              label: 'CGPA',
                              value: studentData['CGPA'],
                            ),
                              ],
                            ),
                            
                            const SizedBox(height: 30.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                       ProfileInfoRow(
                                  label: 'Capstone Project',
                                  value: studentData['capstoneInfo']
                                      ['Project worked on'],
                                ),
                                const SizedBox(width: 80,),
                                ProfileInfoRow(
                                  label: 'Capstone Advisor',
                                  value: studentData['capstoneInfo']
                                      ['Capstone Advisor'],
                                ),
                                 const SizedBox(width: 80,),
                                ProfileInfoRow(
                                  label: 'Capstone Grade',
                                  value: studentData['capstoneInfo']
                                      ['Grade Acheived'],
                                ),
                              ],
                            ),
                             const SizedBox(height: 15.0),
                             Row(
                              children: [
                                   ElevatedButton.icon(
                              onPressed: () {
                                _launchUrl(studentData['resume_url']);
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('View Resume'),
                            ),
                            const SizedBox(width: 20.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                _launchUrl(studentData['transcript_url']);
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('View Transcript'),
                            )
                              ],
                             )
                           
                          ],
                          
                          )
                         ,
                           
                           
                          ],
                        );
                      }),
                      const SizedBox(height: 50,),
                     Row(
                    children: [
                      ProfileInfoRow(
                          label: 'Opportunity Name',
                          value: requestData['opportunity']['name']),
                      const SizedBox(width: 100),
                      ProfileInfoRow(
                          label: 'Opportunity Description',
                          value: requestData['opportunity']['description']),
                      const SizedBox(width: 100),
                     
                    ],
                  ),
                  const SizedBox(height: 30,),
                   ProfileInfoRow(
                       label: 'Reason For Applying',
                       value: requestData['opportunity']['reason']),
                  const SizedBox(height: 50,),  
                   ProfileInfoRow(
                          label: 'Conversations Had with Faculty',
                          value: requestData['conversationsHad']),
                   const SizedBox(height: 50,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: classes.length,
                    itemBuilder: (BuildContext context, int index) {
                      var classData = classes[index] as Map<String, dynamic>;
                      return Row(
                        children: [
                          ProfileInfoRow(
                          label: 'Class ',
                          value: classData['Class']),
                          const SizedBox(width: 70),
                        ProfileInfoRow(
                          label: 'Class Project',
                          value: classData['Class Project (if applicable)']),
                           const SizedBox(width: 100),
                           ProfileInfoRow(label: 'Grade', value: classData['Grade']),
                           const SizedBox(width: 100),
                           ProfileInfoRow(label: 'Year', value: classData['Year']),
                           const SizedBox(width: 100),
                           ProfileInfoRow(label: 'Sem', value: classData['Sem']),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 50,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: classes.length,
                    itemBuilder: (BuildContext context, int index) {
                      var projectsData = projects[index] as Map<String, dynamic>;
                      return Row(
                        children: [
                          ProfileInfoRow(
                          label: 'Activity/Project Name ',
                          value: projectsData['Activity/Project Name']),
                          const SizedBox(width: 70),
                        ProfileInfoRow(
                          label: 'Description of activity/project/your role',
                          value: projectsData['Description of activity/project/your role']),
                           const SizedBox(width: 70),
                           ProfileInfoRow(label: 'Year', value: projectsData['Year']),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton.icon(onPressed: (){
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        InferencePage(requestId: requestID)));
                  }, icon: const Icon(Icons.forward), label: const Text("Next"))
                ],
              ),
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
          softWrap: true,
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
