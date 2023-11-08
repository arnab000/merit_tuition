import 'package:flutter/material.dart';
import 'package:merit_tuition_v1/pages/loginPage.dart';


class UserType extends StatefulWidget {
  const UserType({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool isTeacherButtonSelected = false;
  bool isStudentButtonSelected = false;

  @override
  Widget build(BuildContext context) {
    
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Role Selection ',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000), // Replace with the desired color value
            fontFamily: 'Manrope',
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 21.0),
            Container(
              width: 370.0, // Set the width to 370 pixels
              height: 52.0,
              child: const Text(
                'Please select user type to Continue using this application',
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                  color:
                      Color(0xFF898989), // Replace with the desired color value
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.normal,
                  height:
                      1.36842, // This corresponds to a line height of 26px for a 19px font size
                ),
              ),
            ),
            const SizedBox(height: 42.0),
            Row(
              children: [
                Container(
                  width: 150.0,
                  height: 188.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(
                      0xFFFFFFFF, // Replace with the desired background color
                    ),
                    border: Border.all(
                      color: isStudentButtonSelected
                          ? Colors.green
                          : Colors.grey, // Border color change
                      width: 2.0, // Border thickness
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isTeacherButtonSelected = false;
                        isStudentButtonSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set the button's background to transparent
                      elevation: 0, // Remove button elevation
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/parent.png', // Replace with your image asset path
                          width: 80.0, // Adjust the image width as needed
                          height: 80.0, // Adjust the image height as needed
                        ),
                        Text(
                          'parent',
                          style: TextStyle(
                            fontSize: 16.0, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Make the text bold
                            color: isStudentButtonSelected
                                ? Colors.green
                                : Colors.grey, // Text color change
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 19.0),
                Container(
                  width: 150.0,
                  height: 188.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(
                      0xFFFFFFFF, // Replace with the desired background color
                    ),
                    border: Border.all(
                      color: isTeacherButtonSelected
                          ? Colors.green
                          : Colors.grey, // Border color change
                      width: 2.0, // Border thickness
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isTeacherButtonSelected = true;
                        isStudentButtonSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set the button's background to transparent
                      elevation: 0, // Remove button elevation
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/teacher.png', // Replace with your image asset path
                          width: 80.0, // Adjust the image width as needed
                          height: 80.0, // Adjust the image height as needed
                        ),
                        Text(
                          'teacher',
                          style: TextStyle(
                            fontSize: 16.0, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Make the text bold
                            color: isTeacherButtonSelected
                                ? Colors.green
                                : Colors.grey, // Text color change
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 90.0),
            Container(
              width: screenWidth,
              height: screenHeight / 15,
              //  heightFactor: 1.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
            MaterialPageRoute(builder: (context) => isTeacherButtonSelected ? LoginPage(userType: 'teacher',) : LoginPage(userType: 'parent',) ));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
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
          ],
        ),
      ),
    );
  }
}