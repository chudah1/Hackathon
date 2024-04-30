import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:referency_application/services/database.dart';
import 'package:referency_application/utils/extract_table_data.dart';
import 'package:referency_application/views/custom_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StudentForm extends StatefulWidget {
  final String uid;

  const StudentForm({super.key, required this.uid});
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  String _major = "";
  String _graduationYear = "";
  String _cgpa = "";
  String _selected_resume_url = "";
  String _selected_transcript_url = "";
  DataTable? capstoneTable;
  Map<String, dynamic> capstoneInfo = {};
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  Future<void> _uploadFile(Uint8List file, String fileType) async {
    try {
      // Upload file to Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('$fileType/${DateTime.now().millisecondsSinceEpoch}.pdf');
      await ref.putData(file, firebase_storage.SettableMetadata(contentType: 'application/pdf'));

      // Get the download URL of the uploaded file
      if (fileType == "resume") {
        _selected_resume_url = await ref.getDownloadURL();
      } else {
        _selected_transcript_url = await ref.getDownloadURL();
      }

      setState(() {});
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: 'Graduation year',
                    prefixIcon: Icons.date_range,
                    onSaved: (value) {
                      _graduationYear = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your graudation year';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    hintText: 'Major',
                    prefixIcon: Icons.person,
                    onSaved: (value) {
                      _major = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your major';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    hintText: 'CGPA',
                    prefixIcon: Icons.grade,
                    onSaved: (value) {
                      _cgpa = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your cgpa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      capstoneTable = DataTable(
                          border:
                              TableBorder.all(width: 2, color: Colors.black12),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Capstone Advisor',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Project worked on',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                numeric: true),
                            DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Grade Acheived',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                numeric: true),
                          ],
                          rows: <DataRow>[
                            DataRow(cells: <DataCell>[
                              DataCell(TextField(controller: controller1),
                                  showEditIcon: true, placeholder: true),
                              DataCell(
                                  TextField(
                                    controller: controller2,
                                  ),
                                  showEditIcon: true,
                                  placeholder: true),
                              DataCell(
                                  TextField(
                                    controller: controller3,
                                  ),
                                  showEditIcon: true,
                                  placeholder: true)
                            ])
                          ]),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                          onPressed: () {
                            if (capstoneTable != null) {
                              capstoneInfo = extractCapstoneInfo(capstoneTable);
                            } else {
                              print("Table not initialized");
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save')),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          _uploadFile(result.files.first.bytes!, "resume");
                        }
                      },
                      child: const Text("Upload Resume")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          _uploadFile(result.files.first.bytes!, "transcript");
                        }
                      },
                      child: const Text("Upload Transcript")),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          bool success = await DatabaseService().updateProfile(
                              widget.uid,
                              capstoneInfo,
                              _selected_resume_url,
                              _selected_transcript_url,
                              _cgpa,
                              _graduationYear,
                              _major);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.purpleAccent,
                                  title: Text(success ? "Success" : "Failure"),
                                  content: Text(success
                                      ? "Updated Profile Successfully"
                                      : "Could not update Profile"),
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
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

  
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Update Profile'),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(20.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextFormField(
  //               controller: _gpaController,
  //               keyboardType: TextInputType.numberWithOptions(decimal: true),
  //               decoration: InputDecoration(labelText: 'GPA'),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter your GPA';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             TextFormField(
  //               controller: _majorController,
  //               decoration: InputDecoration(labelText: 'Major'),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter your major';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             TextFormField(
  //               controller: _graduationYearController,
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //           hintText: "Graduation Year",
  //           prefixIcon: const Icon(Icons.school),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           )),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter your graduation year';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             ListTile(
  //               title: Text('Date of Request/Completing Form'),
  //               subtitle: Text(
  //                   '${_dateOfRequest.day}/${_dateOfRequest.month}/${_dateOfRequest.year}'),
  //               onTap: () async {
  //                 final selectedDate = await showDatePicker(
  //                   context: context,
  //                   initialDate: _dateOfRequest,
  //                   firstDate: DateTime(2000),
  //                   lastDate: DateTime(2100),
  //                 );
  //                 if (selectedDate != null) {
  //                   setState(() {
  //                     _dateOfRequest = selectedDate;
  //                   });
  //                 }
  //               },
  //             ),
  //             ListTile(
  //               title: Text('Date by which reference must be submitted'),
  //               subtitle: Text(
  //                   '${_dateOfSubmission.day}/${_dateOfSubmission.month}/${_dateOfSubmission.year}'),
  //               onTap: () async {
  //                 final selectedDate = await showDatePicker(
  //                   context: context,
  //                   initialDate: _dateOfSubmission,
  //                   firstDate: DateTime(2000),
  //                   lastDate: DateTime(2100),
  //                 );
  //                 if (selectedDate != null) {
  //                   setState(() {
  //                     _dateOfSubmission = selectedDate;
  //                   });
  //                 }
  //               },
  //             ),
  //             SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (_formKey.currentState!.validate()) {
  //                   // Process the form data
  //                   // For example, submit the form to a database
  //                   // and navigate to the next screen
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(content: Text('Form submitted')),
  //                   );
  //                 }
  //               },
  //               child: Text('Submit'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

