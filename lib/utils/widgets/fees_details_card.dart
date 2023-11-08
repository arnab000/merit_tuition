import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:merit_tuition_v1/constants/icons.dart';
import 'package:merit_tuition_v1/utils/svg_to_icon.dart';

class FeesDetailsCard extends StatelessWidget {
  final String feesType;
  final String amount;
  final String paymentStatus;
  final void Function() ontap;
  const FeesDetailsCard(
      {super.key,
      required this.feesType,
      required this.amount,
      required this.paymentStatus,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      height: 165,
      decoration: ShapeDecoration(
        color: Color(0xFFF5F5F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: SvgIcon(path: bankIcon),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              feesType,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              children: [
                Text(
                  '£${amount}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  paymentStatus ,
                  style: TextStyle(
                    color: Color(0xFF898989),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          //   child: GestureDetector(
          //     onTap: ontap,
          //     child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          //       SvgPicture.asset(
          //         arrowRightIcon1,
          //         height: 20,
          //         width: 20,
          //         fit: BoxFit.contain,
          //       ),
          //       Text(
          //         'Pay Now',
          //         style: TextStyle(
          //           color: Color(0xFFFB95E1),
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       )
          //     ]),
          //   ),
          // ),
        ],
      ),
    );
  }
}
