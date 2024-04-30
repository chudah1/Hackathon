
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //database
  final database = FirebaseFirestore.instance;

  //save a user (student or lecturer)
  Future<bool> saveUser(String uid, String fname, String lname, String email,
      bool isFaculty) async {
    try {
      await database.collection('users').doc(uid).set({
        "lname": lname,
        "fname": fname,
        "email": email,
        "isFaculty": isFaculty
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfile(
      String uid,
      Map<String, dynamic> capstoneInfo,
      String resumeUrl,
      String transcriptUrl,
      String cgpa,
      String gradYear,
      String major) async {
    try {
      await database.collection('users').doc(uid).update({
        "capstoneInfo": capstoneInfo,
        "resume_url": resumeUrl,
        "transcript_url": transcriptUrl,
        "CGPA": cgpa,
        "grad_Year": gradYear,
        "major": major
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> getUser(String uid) async {
    DocumentSnapshot snapshot =
        await database.collection('users').doc(uid).get();

    if (snapshot.exists) {
      final userInfo = snapshot.data() as Map<String, dynamic>;
      String fullName = '${userInfo['fname']} ${userInfo['lname']}';
      return fullName;
    } else {
      return null;
    }
  }

  // check if user is a student
  Future<bool> isFaculty(String uid) async {
    var userDoc = await database.collection('users').doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (userData['isFaculty'] == true) {
        return true;
      }
      return false;
    }
    return false;
  }

  // create an opportuinity
  bool createOpportunity(
      String studentID, String name, String description, String reason) {
    try {
      database.collection('opportuinities').add({
        "name": name,
        "description": description,
        "reason": reason,
        "studentID": studentID
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //get a student's list of opportunities
  Stream<QuerySnapshot> studentOpportunities(String studentID) {
    return database
        .collection('opportuinities')
        .where("studentID", isEqualTo: studentID)
        .snapshots();
  }

  Future<Map<String, dynamic>> getOpportunity(String oppID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await database.collection('opportuinities').doc(oppID).get();
    if (snapshot.exists) {
      return snapshot.data()!;
    } else {
      return {};
    }
  }

  //get a student's list of requests
  Stream<QuerySnapshot> studentRequests(String studentID) {
    return database
        .collection('requests')
        .where("studentID", isEqualTo: studentID)
        .snapshots();
  }

  Future<bool> updateSent(String reqUID) async {
    try {
      await database.collection('requests').doc(reqUID).update({"sent": true});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveRequest(
      String studentUID,
      String facultyEmail,
      String facultyPosition,
      String facultySchool,
      String conversationsHad,
      String focusArea,
      List<Map<String, dynamic>> classes,
      List<Map<String, dynamic>> projects,
      Future<Map<String, dynamic>> opportunityFuture) async {
    try {
      Map<String, dynamic> opportunity = await opportunityFuture;
      await database.collection('requests').add({
        "studentID": studentUID,
        "facultyEmail": facultyEmail,
        "facultySchool": facultySchool,
        "facultyPosition": facultyPosition,
        "conversationsHad":conversationsHad,
        "focusArea":focusArea,
        "classes": classes,
        "projects": projects,
        "opportunity": opportunity,
        "sent": false
      });
      return true;
    } catch (e) {
      return false;
    }
  }


  //get a student's list of requests
  Stream<QuerySnapshot> studentRequestsSent(String studentID) {
    return database
        .collection('requests')
        .where("studentID", isEqualTo: studentID)
        .where("sent", isEqualTo: true)
        .snapshots();
  }

  //see all requests sent from the lecturer's view
  Stream<QuerySnapshot> viewRequestsReceived(String facultyEmail){
    return database
        .collection('requests')
        .where("facultyEmail", isEqualTo: facultyEmail)
        .where("sent", isEqualTo: true)
        .snapshots();
  }


}
