import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package.
import 'package:merit_tuition_v1/components/student.dart';
import 'package:merit_tuition_v1/constants/colors.dart';
import 'package:merit_tuition_v1/pages/addStudentByParent.dart';
import 'package:merit_tuition_v1/utils/widgets/student_card.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // Import for JSON parsing.

class Students extends StatefulWidget {
  final BuildContext rootcontext;

  const Students({Key? key, required this.rootcontext}) : super(key: key);

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  Future<List<Student>> fetchData() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');
      http.Response response = await http.get(
        Uri.parse('http://admin.merittutors.co.uk/api/parent-student'),
        headers: {
          'Authorization': 'Token $token', // Add the authorization header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonDataList = jsonDecode(response.body);

        print("printing json data");
        print(jsonDataList);

        final List<Student> students = jsonDataList.map((jsonData) {
          return Student(
            // Map JSON fields to Student class properties here.
            id: (jsonData['id']),
            user: User(
              firstName: jsonData['user']['first_name'],
              lastName: jsonData['user']['last_name'],
              email: jsonData['user']['email'],
              phone: jsonData['user']['phone'] ?? '',
              address: jsonData['user']['address'],
              postcode: jsonData['user']['postcode'],
              photo: jsonData['user']['photo'],
            ),
            branch: jsonData['branch'],
            level: jsonData['level'],
            school: jsonData['school'],
            yearGroup: jsonData['year_group'] ?? '',
            studentId: jsonData['student_id'],
            resourcesFee: (jsonData['resources_fee']),
            registrationFee: (jsonData['registration_fee']),
            refundableDepositAmount: (jsonData['refundable_deposit_amount']),
            hourlyFee: (jsonData['hourly_fee']),
            score: (jsonData['score']),
            assessmentDate: jsonData['assessment_date'],
            assessmentTime: jsonData['assessment_time'],
            status: jsonData['status'],
            ieduStudentId: jsonData['iedu_student_id'] ?? '',
            note: jsonData['note'] ?? '',
            createdAt: DateTime.parse(jsonData['created_at']),
            updatedAt: DateTime.parse(jsonData['updated_at']),
            parent: (jsonData['parent']),
          );
        }).toList();
        return students;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error i guess: $e');
      return []; // Return an empty list in case of an error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, you can show a loading indicator.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error state.
          return Text('Errorrrroooo: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle empty data state.
          return Text('No data available');
        } else {
          // Data has been successfully fetched.
          final studentsData = snapshot.data!;
          print("students in builder");
          print(studentsData);

          return Expanded(
            child: ListView.separated(
              itemCount: studentsData.length + 1,
              itemBuilder: (rootcontext, index) {
                if (index < studentsData.length) {
                  // Render StudentCard for each student
                  return StudentCard(student: studentsData[index]);
                } else {
                  // Render the button as the last item
                  return Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(
                          8), // Fix: Change 'border' to 'borderRadius'
                    ),
                    child: Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddStudentPage()));
                          // Add your button's functionality here
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "ADD A NEW STUDENT",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20,
                );
              },
            ),
          );
        }
      },
    );
  }
}
