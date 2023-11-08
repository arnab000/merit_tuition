import 'package:flutter/material.dart';
import 'package:merit_tuition_v1/components/student.dart';
import 'package:merit_tuition_v1/constants/colors.dart';
import 'package:merit_tuition_v1/constants/icons.dart';
import 'package:merit_tuition_v1/pages/studentProfile.dart';
import 'package:merit_tuition_v1/utils/widgets/student_card_status.dart';
import 'package:merit_tuition_v1/utils/widgets/student_card_status_with_icon.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});
   dynamic _getImage(){
    if(this.student.user.photo!=null){
      return NetworkImage(this.student.user.photo);
    }
    return AssetImage('assets/parent.png');
  }

  dynamic _getId(){
    return student.id;
  }

  @override
  Widget build(BuildContext context) {
    print(this.student.id);
    return GestureDetector(
      onTap: () {
                    Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  StudentProfile(studentId: _getId(), name: '${student.user.firstName}  ${student.user.lastName}' , email: student.user.email)));
                  },
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Container(
              height: 81,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                          child: CircleAvatar(
                            backgroundImage: _getImage(),
                            backgroundColor: Colors.white,
                            radius: 26,
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                this.student.user.firstName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                this.student.user.lastName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$56",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Due Fee",
                            style: TextStyle(
                                color: Color(lightColorForCard),
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 165,
              decoration: BoxDecoration(color: Colors.white),
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StudentCardDetails(
                          heading: "PRIMARY", status: this.student.level),
                      StudentCardDetails(
                          heading: "BRANCH", status: this.student.branch),
                      StudentCardDetails(
                          heading: "STATUS", status: this.student.status)
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StudentCardDetailsWithIcon(
                        heading: this.student.assessmentDate,
                        status: 'ASSESMENT DATE',
                        path: calendarIcon,
                      ),
                      StudentCardDetailsWithIcon(
                        heading: this.student.assessmentTime,
                        status: 'ASSESMENT TIME',
                        path: timerIcon,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
