import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:merit_tuition_v1/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeAPI {
  static createPaymentIntent(
      String amount, String currency, BuildContext context) async {
    try {
      var name = 'Arnab Saha';
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': "card",
        'customer': name.length.toString()
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${keys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print(response.body);
      return jsonDecode(response.body);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
  

  static Future<Map<String, String>> getAllSharedPreferencesValues() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var name = sharedPreferences.getString('name') ?? '';
    var email = sharedPreferences.getString('email') ?? '';

    return {'name': name, 'email': email};
  }

  static Future<void> createStripeCustomer() async {
// Usage
    var {'name': name, 'email': email} = await getAllSharedPreferencesValues();

    var url = 'https://api.stripe.com/v1/customers';

    Map<String, String> headers = {
      'Authorization': 'Bearer ${keys.secretKey}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, String> body = {
      'email': email,
      'name': name,
      'id': name.length.toString() // Replace with customer's email
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      // Customer created successfully
      print(response);
      print('Customer created successfully');
    } else {
      // Error in creating customer
      print('Error creating customer: ${response.reasonPhrase}');
    }
  }

   static Future<void> updatePaymentStatus(ids, context, amount,studentId) async {
    
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    print('http://35.176.201.155/api/student-payments/$studentId');
    print('Token $token');
    print('bill $ids');
    var url = Uri.parse('http://35.176.201.155/api/student-payments/$studentId');

    Map<String, dynamic> body = {
        'voucher': '',
        'paid': amount.toString(),
        'status': "Success",
        'method': 'Stripe',
        'payer_name': '',
        'payment_date': '2023-07-29',
        'bill': ids.join(','),
        'subtotal': "100",
        'used_balance': '0',
        'remarks': '',
        'discount_type': 'flat',
        'discount': '10',
        'reference_number': '',
        'bank': ''
      };
    http.Response response = await http.post(
      url,
      headers: {
        'Authorization':
            'Token $token', // Add the authorization header
      },
      body: body

    );
    print(response.body);

    if (response.statusCode == 200) {
       print('good job');
    } else {
      print('baaal');
      print(response);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong,please try again'),
        backgroundColor: Colors.red,
      ));
      throw Exception(
          'API call failed'); // Throwing an exception in case of an error
    }
  }


   static Future<void> makePayment(dynamic studentId, dynamic ids,
      String amount, String currency, BuildContext context) async {
    Map<String, dynamic>? paymentIntentData;
    try {
      paymentIntentData = await createPaymentIntent(amount, currency, context);

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                // applePay: const PaymentSheetApplePay(merchantCountryCode: "+1"),
                googlePay:
                    const PaymentSheetGooglePay(merchantCountryCode: "EU"),
                paymentIntentClientSecret: paymentIntentData["client_secret"],
                customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
                merchantDisplayName: "Arnab Saha",
                customerId: "12"));
        print("showing payment gateway");
        await Stripe.instance.presentPaymentSheet();
        



        // make api call to update payment
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Payment is successfull"),
          backgroundColor: Colors.green,
        ));
       
          updatePaymentStatus(ids, context, amount, studentId);
        
        
      }
    } catch (e) {
      print(e);
      LocalizedErrorMessage localizedErrorMessage =
          e.reactive.toJson()['error'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(localizedErrorMessage.message.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}
