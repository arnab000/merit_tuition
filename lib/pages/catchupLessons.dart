// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:merit_tuition_v1/pages/SignUpPage.dart';
import 'package:merit_tuition_v1/pages/parents_dashboard.dart';
import 'package:merit_tuition_v1/pages/teacherDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merit_tuition_v1/constants/textstyles.dart';

class CatchupLesson extends StatefulWidget {
  final dynamic studentId;
  const CatchupLesson({required this.studentId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CatchupLessonState createState() => _CatchupLessonState();
}

class _CatchupLessonState extends State<CatchupLesson> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController changedLessonDate = TextEditingController();
  final TextEditingController dateInput = TextEditingController();
  String selectedDropDownItem = '';
  String selectedDropDownItemCatchUp = "";
  List<String> list = [];
  List<String> allLessons =[];

  bool _isAuthenticated = false; // Simulated authentication status

  Future<void> _getStudentLessonByDate() async {
    // Simulated authentication logic - Replace with actual authentication

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse(
        'http://admin.merittutors.co.uk/api/student-lessons/${widget.studentId}?date=${dateInput.text}');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token', // Add the authorization header
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        dynamic result = jsonDecode(response.body);
        print(result);
        // ignore: use_build_context_synchronously
        setState(() {
          list.clear();
          for (int i = 0; i < result.length; i++) {
            list.add(result[i]['lesson']['name']);
          }
          selectedDropDownItem = list.first;
        });
      } catch (e) {
        print(response);
      }
      return;
    } else {
      // ignore: use_build_context_synchronously
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong,please try again'),
        backgroundColor: Colors.red,
      ));
    }
  }
   Future<void> _getAllLessonByDate() async {
    // Simulated authentication logic - Replace with actual authentication

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse(
        'http://admin.merittutors.co.uk/api/student-lessons/${widget.studentId}?date=${dateInput.text}');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token', // Add the authorization header
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        dynamic result = jsonDecode(response.body);
        print(result);
        // ignore: use_build_context_synchronously
        setState(() {
          list.clear();
          for (int i = 0; i < result.length; i++) {
            list.add(result[i]['lesson']['name']);
          }
          selectedDropDownItem = list.first;
        });
      } catch (e) {
        print(response);
      }
      return;
    } else {
      // ignore: use_build_context_synchronously
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong,please try again'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text(
            'Welcome Back',
            style: headerStyle,
          ),
          const SizedBox(
            width: 16,
          ),
          Image.asset('assets/welcome.png')
        ]),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter your email address and password to login to your account',
                  style: disabledTextStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Enter Email Address',
                  style: normalTextStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width / 3,
                    child: Center(
                        child: TextField(
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                          _getStudentLessonByDate();
                        } else {}
                      },
                    ))),
                DropdownButton<String>(
                  value: selectedDropDownItem,
                  icon: const Icon(Icons.arrow_downward_rounded),
                  isExpanded: true,
                  elevation: 16,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 118, 114, 124)),
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 133, 130, 143),
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedDropDownItem = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width / 3,
                    child: Center(
                        child: TextField(
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                          _getStudentLessonByDate();
                        } else {}
                      },
                    ))),
                DropdownButton<String>(
                  value: selectedDropDownItem,
                  icon: const Icon(Icons.arrow_downward_rounded),
                  isExpanded: true,
                  elevation: 16,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 118, 114, 124)),
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 133, 130, 143),
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedDropDownItem = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Opacity(
                          opacity: 0.3, child: Icon(Icons.email_outlined)),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  'Enter Password',
                  style: normalTextStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      prefixIcon:
                          Opacity(opacity: 0.3, child: Icon(Icons.lock)),
                      border: OutlineInputBorder()),
                  obscureText: true, // Hide password characters
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: smallerDisabledTextStyle,
                  ),
                ),
                const SizedBox(height: 72),
                Container(
                  width: screenWidth,
                  height: screenHeight / 15,
                  //  heightFactor: 1.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary:
                          const Color(0xFF3AD4E1), // Background color (#3AD4E1)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Border radius (5px)
                      ), // Button color
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                    child: Text(
                  "Don't have a account?",
                  style: normalTextStyle,
                )),
              ]),
        ),
      ]),
    );
  }
}
