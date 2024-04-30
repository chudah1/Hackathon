import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';

class OpportunityForm extends StatefulWidget {
  final String uid;
  const OpportunityForm({super.key, required this.uid});

  @override
  _OpportunityFormState createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  bool createOpportunity(String name, String description, String reason) {
    return DatabaseService()
        .createOpportunity(widget.uid, name, description, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Opportunity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = createOpportunity(_nameController.text,
                    _descriptionController.text, _reasonController.text);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.purpleAccent,
                        title: Text(success ? "Success" : "Failure"),
                        content: Text(success
                            ? "Added Opportunity Successfully"
                            : "Could not add Opprtunity"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                if (success) {
                                  Navigator.pop(context);
                                }
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"))
                        ],
                      );
                    });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
