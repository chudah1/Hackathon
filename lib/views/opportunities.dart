import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/utils/opportunity_form.dart';

class Opportunities extends StatefulWidget {
  final String uid;

  const Opportunities({super.key,required this.uid});

  @override
  _OpportunitiesState createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<Opportunities> {
  bool _opportunitiesExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().studentOpportunities(widget.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
          _opportunitiesExist =
              snapshot.hasData && snapshot.data!.docs.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.data!.docs.isEmpty)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "No opportunities yet",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name']),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Add functionality to edit the opportunity
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: _opportunitiesExist
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: !_opportunitiesExist,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityForm(uid:widget.uid)),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Opportunity'),
        ),
      ),
    );
  }
}
