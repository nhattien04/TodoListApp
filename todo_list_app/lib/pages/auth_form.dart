import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //------------------------------------------
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  //------------------------------------------

  startauthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';
      if (err.message != null) {
        message = err.message!;
      }

      var snackBar = SnackBar(
        content: Text(
          message,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (err) {
      print(err);
    }
  }

  //------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 30 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Image.asset('assets/images/logo_image_todo_list_app.png'),
            ),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoginPage)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập Tên người dùng!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide()),
                              labelText: "Tên người dùng",
                              labelStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold)),
                        ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Vui lòng nhập Email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Email",
                            labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập Mật khẩu!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Mật khẩu",
                            labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton(
                              child: isLoginPage
                                  ? Text('Đăng nhập',
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                  : Text('Đăng ký',
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.green),
                              ),
                              onPressed: () {
                                startauthentication();
                              })),
                      SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLoginPage = !isLoginPage;
                              });
                            },
                            child: isLoginPage
                                ? Text(
                                    'Bạn chưa có tài khoản?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text('Bạn đã có tài khoản?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
