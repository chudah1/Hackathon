import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/utils/extract_table_data.dart';
import 'package:referency_application/views/custom_form_field.dart';

class RequestForm extends StatefulWidget {
  final String uid;

  const RequestForm({super.key, required this.uid});

  @override
  RequestFormState createState() => RequestFormState();
}

class RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedOppId;
  String _facultyEmail = "";
  String _facultyName = "";
  String _focusArea = "";
  String _facultyPosition = "";
  String _facultySchool = "";
  String _conversationsHad = "";
  DataTable? classesTable;
  DataTable? projectsTable;

  List<Map<String, dynamic>> projectsDone = [];
  List<Map<String, dynamic>> classesTaken = [];
  List<DataRow> rows = [];
  List<DataRow> rows2 = [];

  void _addRow() {
    List<DataCell> cells = [];
    setState(() {
      TextEditingController controller1 = TextEditingController();
      TextEditingController controller2 = TextEditingController();
      TextEditingController controller3 = TextEditingController();
      TextEditingController controller4 = TextEditingController();
      TextEditingController controller5 = TextEditingController();

      cells.add(
          DataCell(TextField(controller: controller1), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller2), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller3), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller4), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller5), showEditIcon: true));

      rows.add(DataRow(cells: cells));
    });
  }

  void _addRow2() {
    List<DataCell> cells = [];
    setState(() {
      TextEditingController controller1 = TextEditingController();
      TextEditingController controller2 = TextEditingController();
      TextEditingController controller3 = TextEditingController();

      cells.add(
          DataCell(TextField(controller: controller1), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller2), showEditIcon: true));
      cells.add(
          DataCell(TextField(controller: controller3), showEditIcon: true));
      rows2.add(DataRow(cells: cells));
    });
  }

  Future<bool> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final opportunity = DatabaseService().getOpportunity(selectedOppId!);
      if (await DatabaseService().saveRequest(
          widget.uid,
          _facultyEmail,
          _facultyPosition,
          _facultySchool,
          _conversationsHad,
          _focusArea,
          classesTaken,
          projectsDone,
          opportunity)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200),
            height: MediaQuery.of(context).size.height * 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DropdownMenu(
                      stream:
                          DatabaseService().studentOpportunities(widget.uid),
                      selectedOppId: selectedOppId,
                      onSelectedOppIdChanged: (value) {
                        setState(() {
                          selectedOppId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'Faculty Name',
                      prefixIcon: Icons.person,
                      onSaved: (value) {
                        _facultyName = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: 'Faculty Email',
                      prefixIcon: Icons.email,
                      onSaved: (value) {
                        _facultyEmail = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: 'Faculty Position',
                      prefixIcon: Icons.school,
                      onSaved: (value) {
                        _facultyPosition = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the faculty position';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: 'Faculty School',
                      prefixIcon: Icons.school,
                      onSaved: (value) {
                        _facultySchool = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the faculty\'s school';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 650,
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 3,
                        onSaved: (newValue) {
                          _conversationsHad = newValue!;
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Conversations with Faculty",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 650,
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 3,
                        onSaved: (newValue) {
                          _focusArea = newValue!;
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Focus area of the letter",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Classes taken with Faculty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            classesTable = DataTable(
                                border: TableBorder.all(
                                    width: 2, color: Colors.black12),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Class',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Year',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      numeric: true),
                                  DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Sem',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      numeric: true),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Grade',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Class Project (if applicable)',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: rows)
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            ElevatedButton.icon(
                                onPressed: _addRow,
                                label: const Text("Add Row"),
                                icon: const Icon(Icons.add)),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  if (classesTable != null) {
                                    classesTaken =
                                        extractDataTableData(classesTable);
                                  } else {
                                    print("Table not initalized");
                                  }
                                },
                                label: const Text("Save data"),
                                icon: const Icon(Icons.save)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Projects taken with Faculty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            projectsTable = DataTable(
                              border: TableBorder.all(
                                  width: 2, color: Colors.black12),
                              columnSpacing: 100,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Activity/Project Name',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Year',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Description of activity/project/your role',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                              rows: rows2,
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            ElevatedButton.icon(
                                onPressed: _addRow2,
                                label: const Text("Add Row"),
                                icon: const Icon(Icons.add)),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  if (projectsTable != null) {
                                    projectsDone =
                                        extractDataTableData(projectsTable);
                                  } else {
                                    print("Table not initalized");
                                  }
                                },
                                label: const Text("Save data"),
                                icon: const Icon(Icons.save)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              bool success = await _submitForm();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.purpleAccent,
                                      title:
                                          Text(success ? "Success" : "Failure"),
                                      content: Text(success
                                          ? "Added Request Successfully"
                                          : "Could not add Request"),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenu extends StatelessWidget {
  final String? selectedOppId;
  final ValueChanged<String?> onSelectedOppIdChanged;
  final Stream<QuerySnapshot> stream;

  const _DropdownMenu({
    required this.selectedOppId,
    required this.onSelectedOppIdChanged,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<DropdownMenuItem<String>> oppNames = [];
        for (var doc in snapshot.data!.docs) {
          oppNames.add(DropdownMenuItem(
            value: doc.id,
            child: Text(doc['name']),
          ));
        }

        return DropdownButton<String>(
          hint: const Text('Select Opportunity'),
          value: selectedOppId,
          items: oppNames,
          onChanged: onSelectedOppIdChanged,
          isExpanded: false,
        );
      },
    );
  }
}
