import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class BookingformNo extends StatefulWidget {
  final int enquiryid;
  const BookingformNo({
    super.key,
    required this.enquiryid
  });

  @override
  State<BookingformNo> createState() => _BookingformNoState();
}

class _BookingformNoState extends State<BookingformNo> {

  final TextEditingController bookingamount = TextEditingController();
  final TextEditingController bookingreceiptno = TextEditingController();
  final TextEditingController vehiclename = TextEditingController();
  final TextEditingController vehiclecolour = TextEditingController();
  final TextEditingController tyremake = TextEditingController();
  final TextEditingController deliverydate = TextEditingController();

  String bookingamounte = '';
  String bookingreceiptnoe = '';
  String vehiclenamee = '';
  String vehiclecoloure = '';
  String tyremakee = '';
  String deliverydatee = '';

  Future<void> movetobooking() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/${widget.enquiryid}/move-to-booking/simple');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'booking_amount': bookingamount.text.toString(),
          'booking_receipt_no': bookingreceiptno.text.toString(),
          'vehicle_name': vehiclename.text.toString(),
          'vehicle_colour': vehiclecolour.text.toString(),
          'tyre_make': tyremake.text.toString(),
          'expected_delivery_date' : deliverydate.text.toString(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Navigation(initialIndex: 1),
              ),
            );
          }
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          bookingamounte = errors['booking_amount']?.toString() ?? '';
          bookingreceiptnoe = errors['booking_receipt_no']?.toString() ?? '';
          vehiclenamee = errors['vehicle_name']?.toString() ?? '';
          vehiclecoloure = errors['vehicle_colour']?.toString() ?? '';
          tyremakee = errors['tyre_make']?.toString() ?? '';
          deliverydatee = errors['delivery_date']?.toString() ?? '';
        });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Status code: ${response.statusCode}');
        print(response.body);
      } else {
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          }
        );
        print('Failed to move to booking. Status code: ${response.statusCode}');
        print(response.body);
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.h(20)),
                back(context, Navigation(initialIndex: 1)),
                Center(
                  child: Text(
                    'Out of the Stock Form',
                    style: customtext(fs18, kred, FontWeight.bold),
                  ),
                ),
                SizedBox(height: SizeConfig.h(20)),
                textfieldy(
                  'Booking Amount',
                  bookingamount,
                ),
                if(bookingamounte.isNotEmpty)
                errormessage(bookingamounte),
                textfieldy(
                  'Booking Receipt No',
                  bookingreceiptno,
                  star: false
                ),
                if(bookingreceiptnoe.isNotEmpty)
                errormessage(bookingreceiptnoe),
                textfieldy(
                  'Vehicle Name',
                  vehiclename,
                ),
                if(vehiclenamee.isNotEmpty)
                errormessage(vehiclenamee),
                textfieldy(
                  'Vehicle Colour',
                  vehiclecolour,
                ),
                if(vehiclecoloure.isNotEmpty)
                errormessage(vehiclecoloure),
                textfieldy(
                  'Tyre Make',
                  tyremake,
                ),
                if(tyremakee.isNotEmpty)
                errormessage(tyremakee),
                Followupdate(
                  title: 'Expected Delivery Date',
                  datecontroller: deliverydate,
                ),
                if(deliverydatee.isNotEmpty)
                errormessage(deliverydatee),
                SizedBox(height: SizeConfig.h(20)),
                button(
                  'Move to Booking',
                  () {
                    movetobooking();
                  }
                ),
                
                SizedBox(height: SizeConfig.h(40)),
              ],
            ),
          ),
        ),
      )
    );
  }
}