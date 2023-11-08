// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merit_tuition_v1/pages/loginPage.dart';
import 'package:merit_tuition_v1/pages/parents_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merit_tuition_v1/constants/textstyles.dart';
import 'package:merit_tuition_v1/utils/modifiedTextField.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _login() async {
    // Simulated authentication logic - Replace with actual authentication
    final String firstName = _firstNameController.text;
    final String lastname = _lastNameController.text;
    final String dob = _dobController.text;
    final String phone = _phoneController.text;
    final String level = _levelController.text;
    final String postCode = _postCodeController.text;
    final String address = _addressController.text;
    final String school = _schoolController.text;
    final String branch = _branchController.text;
    final String date = _dateController.text;
    final String time = _timeController.text;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('http://admin.merittutors.co.uk/api/parent-student');
    http.Response response = await http.post(url, headers: {
      'Authorization': 'Token $token', // Add the authorization header
    }, body: {
      'branch': branch,
      'firstName': firstName,
      'lastName': lastname,
      'phone': phone,
      'address': address,
      'postcode': postCode,
      'dob': dob,
      'level': level,
      'assessment_date': date,
      'school': school,
      'assessment_time': time
    });

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> result = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result['response']),
          backgroundColor: Colors.green,
        ));
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ParentsHome()));

        print(result);
      } catch (e) {
        print(response);
      }
      return;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      print(jsonDecode(response.body));
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text(result['response']),
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
            'Register Student!',
            style: headerStyle,
          ),
          const SizedBox(
            width: 16,
          ),
          Image.asset(
            'assets/register.png',
            height: 20,
            width: 20,
          )
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
                  "Enter student's all the manadatory details to get registered",
                  style: disabledTextStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.person_outlined),
                  controller: _firstNameController,
                  obscureText: false,
                  header: 'First Name',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.person_outlined),
                  controller: _lastNameController,
                  obscureText: false,
                  header: 'Last Name',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.phone),
                  controller: _phoneController,
                  obscureText: false,
                  header: 'Phone Number',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.place),
                  controller: _postCodeController,
                  obscureText: false,
                  header: 'Post Code',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.place),
                  controller: _addressController,
                  obscureText: false,
                  header: 'Address',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.calendar_month),
                  controller: _dobController,
                  obscureText: false,
                  header: 'Date of birth',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.phone),
                  controller: _branchController,
                  obscureText: false,
                  header: 'Brnach',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.person),
                  controller: _levelController,
                  obscureText: false,
                  header: 'Level',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.badge),
                  controller: _schoolController,
                  obscureText: false,
                  header: 'School',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.badge),
                  controller: _dateController,
                  obscureText: false,
                  header: 'Assignment Date',
                ),
                ModifiedTextField(
                  icon: const Icon(Icons.verified_user),
                  controller: _timeController,
                  obscureText: false,
                  header: 'Assignment Time',
                ),
                const SizedBox(height: 20),
                
                const SizedBox(height: 72),
                Container(
                  width: screenWidth,
                  height: screenHeight / 15,
                  //  heightFactor: 1.0,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      primary:
                          const Color(0xFF3AD4E1), // Background color (#3AD4E1)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Border radius (5px)
                      ), // Button color
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
        ),
      ]),
    );
  }
}
