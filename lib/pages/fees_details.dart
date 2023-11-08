import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:merit_tuition_v1/components/stripe_api.dart';
import 'package:merit_tuition_v1/constants/colors.dart';
import 'package:merit_tuition_v1/constants/icons.dart';
import 'package:merit_tuition_v1/pages/paymentType.dart';
import 'package:merit_tuition_v1/utils/widgets/fees_details_card.dart';
import 'package:merit_tuition_v1/utils/widgets/fees_details_screen_appbar.dart';
import 'package:merit_tuition_v1/utils/widgets/fees_overview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeesDetails extends StatefulWidget {
  final dynamic studentId;
  const FeesDetails({required this.studentId, super.key});

  @override
  State<FeesDetails> createState() => _FeesDetailsState();
}

class _FeesDetailsState extends State<FeesDetails> {
  final ScrollController _feesScrollController = ScrollController();
  double totalFees = 0.0;
  double totalPaid = 0.0;
  double totalDue = 0.0;
  String feesType = "all";

  Future<List<dynamic>> getStudentBills() async {
    totalFees = 0.0;
    totalPaid = 0.0;
    totalDue = 0.0;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = feesType == "all"
        ? Uri.parse(
            'http://admin.merittutors.co.uk/api/student-bills/${widget.studentId}')
        : Uri.parse(
            'http://admin.merittutors.co.uk/api/student-bills/49?month=${feesType.split('-')[1]}&& year=${feesType.split('-')[0]}');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization':
            'Token cad630c784379382520b9b37b4e2bd5b1f63ebc4', // Add the authorization header
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      try {
        List<dynamic> result = jsonDecode(response.body);
        print(result);
        result.forEach((element) {
          totalFees += double.parse(element["fee"]);
          totalPaid += double.parse(element["paid"]);
          totalDue += double.parse(element["due"]);
        });

        return result;
      } catch (e) {
        print(response);
        throw e;
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong,please try again'),
        backgroundColor: Colors.red,
      ));
      throw Exception(
          'API call failed'); // Throwing an exception in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<dynamic>>(
      future: getStudentBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, you can show a loading indicator.
          return Scaffold(
              appBar: FeesAppBar(title: "Fees Details", onTap: () {}),
              body: Center(
                child: Container(
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue), // Customize the color
                    strokeWidth: 6, // Customize the thickness
                  ),
                ),
              ));
        } else if (snapshot.hasError) {
          // Handle error state.
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully fetched.

          final studentBills = snapshot.data!;

          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: GestureDetector(
                onTap: () {
                  
                  // StripeAPI.createStripeCustomer().then((value) =>  StripeAPI.makePayment("65", "USD", context));
                  if (totalDue != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentType(amount: (totalDue.abs()*100).toInt().toString())));
                  }
                },
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SvgPicture.asset(
                    arrowRightIcon1,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Color(0xFFFB95E1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ]),
              ),
            ),
            appBar: FeesAppBar(title: "Fees Details", onTap: () {}),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 170,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 125,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, -1.00),
                                end: Alignment(0, 1),
                                colors: [Color(0xFF4346A3), Color(0xFF4B4FCD)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Amount To Be Paid',
                                    style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '£$totalDue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          OverflowBox(
                            alignment: Alignment(1.0, -2.0),
                            maxHeight:
                                150, // Adjust this value to control the overflow
                            child: Image.asset(
                              "assets/images/fees_details.png",
                              fit: BoxFit
                                  .cover, // You can adjust the fit as needed
                              width: 140, // Adjust the width as needed
                              height: 140, // Adjust the height as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        feesOverview(
                            amount: totalFees,
                            descText: "Total Fees",
                            color: primaryColor),
                        feesOverview(
                            amount: totalPaid,
                            descText: "Total Paid",
                            color: secondaryColor),
                        feesOverview(
                            amount: totalDue,
                            descText: "Total Due",
                            color: Color(dueColor))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Fees Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Add your logic for the "All" button here
                                setState(() {
                                  feesType = "all";
                                });
                              },
                              child: Text("All"),
                            ),
                            SizedBox(
                                width:
                                    10), // Add some spacing between the buttons
                            ElevatedButton(
                              onPressed: () {
                                // Add your logic for the "This Month" button here
                                setState(() {
                                  feesType =
                                      "${DateTime.now().year}-${DateTime.now().month}";
                                });
                              },
                              child: Text(
                                  DateFormat.MMMM().format(DateTime.now())),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: height * 0.4,
                      width: double.infinity,
                      child: Expanded(
                        child: Scrollbar(
                          thickness: 5,
                          trackVisibility: false,
                          interactive: true,
                          thumbVisibility: true,
                          controller: _feesScrollController,
                          radius: const Radius.circular(5),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: studentBills.length,
                              itemBuilder: (context, index) {
                                return FeesDetailsCard(
                                  feesType: studentBills[index]["title"],
                                  amount: studentBills[index]["fee"],
                                  paymentStatus: studentBills[index]["status"],
                                  ontap: () {},
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
