import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Công việc mới',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: 'Việc sẽ làm...',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Chi tiết công việc...',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.lightGreen;
                      return Colors.green;
                    })),
                    child: Text(
                      'Thêm',
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (titleController.text != '' &&
                          descriptionController.text != '') {
                        addtasktofirebase();
                        Navigator.pop(context);
                      }
                    },
                  ))
            ],
          )),
    );
  }
}
