import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:merit_tuition_v1/pages/catchupLessons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:merit_tuition_v1/constants/imageStrings.dart';
import 'package:merit_tuition_v1/utils/commonAppBar.dart';
import 'package:merit_tuition_v1/utils/widgets/basic_academic_info.dart';
import 'package:merit_tuition_v1/utils/widgets/current_lesson_card.dart';
import 'package:merit_tuition_v1/utils/widgets/feedback.dart';
import 'package:merit_tuition_v1/utils/widgets/homwork_card.dart';
import 'package:merit_tuition_v1/utils/widgets/student_info.dart';               




class StudentProfile extends StatefulWidget {
  final dynamic studentId;
  final dynamic name;
  final dynamic email;
  const StudentProfile({required this.studentId,required this.name, required this.email, super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  var lessonCount = 0;
  var  lessons = [];
  var feedbacks =[];
  var homeworks = [];

  var selectedLesson =0 ;
  var selectedLessonId ;
  bool feedbackLoading = true;
  bool homeworkLoading = true;
  bool lessonLoading = true;
  var homeworkCount = 0;
  var feedbackCount =0;

  Future<void> _getLessonDetails() async {
    print(widget.studentId);
    setState(() {
      lessonLoading =true;
    });
    // Simulated authentication logic - Replace with actual authentication
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('http://admin.merittutors.co.uk/api/student-lessons/${widget.studentId}');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Token $token', // Add the authorization header
    },);

    if (response.statusCode == 200) {
      try {
        dynamic result = jsonDecode(response.body);
        print(result);
        var lessonDetails = [];
        for(int i=0;i<result.length;i++){
          lessonDetails.add(result[i]['lesson']);
        }
        
        setState(() {
          lessonCount =  result.length;
          lessons = lessonDetails;
          selectedLessonId = result[0]['lesson']['id'];
          if(lessonCount<=0){
            feedbackCount= 0;
            homeworkCount =0;

          }
          lessonLoading =false;
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

  Future<void> _getFeedback(lessonId) async {
    setState(() {
      feedbackLoading =true;
    });
    print(widget.studentId);
    // Simulated authentication logic - Replace with actual authentication
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('http://admin.merittutors.co.uk/api/feedback/${widget.studentId}/$lessonId');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Token $token', // Add the authorization header
    },);

    if (response.statusCode == 200) {
      try {
        dynamic result = jsonDecode(response.body);
        print(result);
        
        setState(() {
          feedbacks =result;
          feedbackCount =result.length;
          feedbackLoading =false;
          
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

  Future<void> _getHomework(lessonId) async {
    print(widget.studentId);
    setState(() {
      homeworkLoading =true;
    });
    // Simulated authentication logic - Replace with actual authentication
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('http://admin.merittutors.co.uk/api/homework/${widget.studentId}/$lessonId');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Token $token', // Add the authorization header
    },);

    if (response.statusCode == 200) {
      try {
        dynamic result = jsonDecode(response.body);
        print(result);
        
        setState(() {
          homeworks= result;
          homeworkCount = result.length;
          homeworkLoading =false;
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
  final ScrollController _gridViewController = ScrollController();
  final ScrollController _listViewController = ScrollController();
  final ScrollController _listViewController2 = ScrollController();
   @override
  void initState() {
    _getLessonDetails().whenComplete(() => lessonCount>0 ? _getFeedback(lessons[0]['id'] ).whenComplete(() => _getHomework(lessons[0]['id'])) : (){});   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CommonAppBar(appBarText: "Profile"),
      drawer: Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: const Text('Catch-up Lessons'),
        onTap: () {
            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatchupLesson(studentId: widget.studentId,)));
        },
      ),
    ],
  ),
),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              studentPersonalInfo(
                size: size,
                studentImagePath: 'assets/parent.png',
                studentName: widget.name,
                studentEmail: widget.email,
                enrolledStatus: 'Enrolled',
              ),
              lessonLoading?  Center(child: CircularProgressIndicator()) : lessonCount <= 0 ? Center(child: Text("No Lessons found"),) :
              studentBasicAcademicInfo(
                size: size,
                selectedLessonName: lessons[selectedLesson]['name'],
                lessonCount: '$lessonCount Lessons',
                studentId: widget.studentId,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: size.height * 0.28,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(08),
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0x33A9ABAC),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lessons",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),

                        lessonLoading?  Center(child: CircularProgressIndicator()) : lessonCount <= 0 ? Center(child: Text("No Lessons found"),) :
                        Expanded(
                          child: Scrollbar(
                            thickness: 5,
                            trackVisibility: false,
                            interactive: true,
                            controller: _gridViewController,
                            thumbVisibility: true,
                            radius: const Radius.circular(5),
                            child: GridView.builder(
                              itemCount: lessonCount,
                              controller: _gridViewController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedLesson =index;
                                    });
                                    _getFeedback(lessons[index]['id']);
                                    _getHomework(lessons[index]['id']);
                                    
                                  },
                                  child: currentLessonCard(
                                    idx: index,
                                    size: size,
                                    lessonName: lessons[index]['name'],
                                    week_day: lessons[index]['week_day'],
                                    duration: lessons[index]['duration'],
                                    isSelected: selectedLesson == index ? true : false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ///FeedBacks
               
               Container(
                width: double.infinity,
                height: size.height * 0.23,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      width: 1.5,
                      color: Color(0x33A9ABAC),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Feedbacks",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                     feedbackLoading?  Center(child: CircularProgressIndicator()) : feedbackCount <= 0 ? Center(child: Text("No feedbacks found"),) :
                      Expanded(
                        child: Scrollbar(
                          thickness: 5,
                          controller: _listViewController,
                          thumbVisibility: true,
                          trackVisibility: false,
                          radius: const Radius.circular(5),
                          child: ListView.builder(
                            controller: _listViewController,
                            itemCount: feedbacks.length,
                            itemBuilder: (BuildContext context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  feedbackWidget(
                                    size: size,
                                    remarks: feedbacks[index]['remarks'],
                                    score: feedbacks[index]['score'],
                                  ),
                                  const SizedBox(
                                    height: 05,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ///Homwork

            
             Container(
                width: double.infinity,
                height: size.height * 0.35,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      width: 1.5,
                      color: Color(0x33A9ABAC),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 02, 05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Home Work",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      homeworkLoading? Center(child: CircularProgressIndicator()) :   homeworkCount <= 0 ? Center( child: Text("No homeworks found"),) :
                      Expanded(
                        child: Scrollbar(
                          thickness: 5,
                          controller: _listViewController2,
                          radius: const Radius.circular(5),
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: homeworks.length,
                            controller: _listViewController2,
                            itemBuilder: (context, index) {
                              return HomeworkCard(
                                descText:homeworks[index]['homework'],
                                lessonName: lessons[selectedLesson]['name'],
                                date: homeworks[index]['due_date'],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}