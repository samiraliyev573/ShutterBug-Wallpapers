import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wallpaperApp/constants.dart';
import 'package:wallpaperApp/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final firestoreReference = Firestore.instance;

  String name;
  String email;
  String subject;
  String message;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    _signInAnonymously();
    print('Auth anonymus');
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ModalProgressHUD(
        dismissible: true,
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            title: Text('FeedBack'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                }),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        maxLength: 15,
                        keyboardType: TextInputType.text,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Your Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Your Email'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Email is required';
                          }

                          if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Please enter a valid email Address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        maxLength: 80,
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: 'Subject'),
                        onChanged: (value) {
                          subject = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Subject is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        maxLines: 8,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Message body is required';
                          }
                          return null;
                        },
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: 'Message'),
                        onChanged: (value) {
                          message = value;
                        },
                      ),
                    ),
                    RoundedButton(
                        color: Color(0xCC5ea3a3),
                        title: 'Send FeedBack',
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          try {
                            setState(() {
                              showSpinner = true;
                            });
                            DocumentReference ref = await firestoreReference
                                .collection('feedbacks')
                                .add({
                              'name': name,
                              'email': email,
                              'subject': subject,
                              'message': message
                            });
                            print('added reference ${ref.documentID}');
                            setState(() {
                              showSpinner = false;
                            });
                            Fluttertoast.showToast(
                                msg:
                                    "We have received your feedback. We will get back to you as soon as possible",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0);

                            Navigator.pushNamed(context, '/drawer3d');
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("Opps"),
                                  content: new Text(
                                      "There was a problem with submitting your feedback. Please check network connection and try again"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {
                              showSpinner = false;
                            });
                            print(e);
                          }
                        }),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
