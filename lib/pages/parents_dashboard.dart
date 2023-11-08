import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:merit_tuition_v1/constants/colors.dart';
import 'package:merit_tuition_v1/constants/icons.dart';
import 'package:merit_tuition_v1/constants/text.dart';
import 'package:merit_tuition_v1/pages/addStudentByParent.dart';
import 'package:merit_tuition_v1/utils/svg_to_icon.dart';
import 'package:merit_tuition_v1/utils/widgets/parent_appbar.dart';
import 'package:merit_tuition_v1/utils/widgets/parents_bottom_navbar.dart';
import 'package:merit_tuition_v1/utils/widgets/students_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentsHome extends StatefulWidget {
  const ParentsHome({super.key});

  @override
  State<ParentsHome> createState() => _ParentsHomeState();
}

class _ParentsHomeState extends State<ParentsHome> {
  List<String> items = ['1', '2', '3', '5'];
  bool isNewNotification = true;
  bool isListEmpty = false;
  int notificationCount = 3;
  String name = '';

  Future<void> _getName() async {
    // Simulated authentication logic - Replace with actual authentication
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url =
        Uri.parse('http://admin.merittutors.co.uk/api/profile?userType=parent');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token', // Add the authorization header
      },
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> result = jsonDecode(response.body);

        setState(() {
          var user = result['user'];
          name = user['first_name'];
        });
      } catch (e) {
        print(response);
      }
      return;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong,please try again'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    _getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ParentsAppBar(
        notificationAvailable: true,
        notificationCount: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddStudentPage()))
        },
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(16),
          decoration:
              const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          child: const SvgIcon(path: homeIcon),
        ),
      ),
      body: isListEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Center(
                child: Material(
                  elevation: 1.5,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border()),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        welcomeText, /////  WELCOME BACK TEXT
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(welcomeTextColor)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        name,

                        /// NAME OF PARENT
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          "Students",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  Students(rootcontext: context)
                ],
              ),
            ),
      drawer: const Drawer(),
      bottomNavigationBar: ParentsBottomNavBar(context),
    );
  }
}
