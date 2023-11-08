import 'package:merit_tuition_v1/constants/colors.dart';
import 'package:flutter/material.dart';

class studentPersonalInfo extends StatelessWidget {
  final String studentImagePath;
  final String studentName;
  final String studentEmail;
  final String enrolledStatus;
  const studentPersonalInfo({
    super.key,
    required this.size,
    required this.studentImagePath,
    required this.studentName,
    required this.studentEmail,
    required this.enrolledStatus,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.072,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.072,
            width: size.width * 0.170,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Image.asset(studentImagePath, fit: BoxFit.fill),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: size.height * 0.072,
            // width: size.width ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
                Text(
                  studentEmail,
                  style: const TextStyle(
                    color: Color(0xFF898989),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )
              ],
            ),
          ),
          const Spacer(),
         
        ],
      ),
    );
  }
}