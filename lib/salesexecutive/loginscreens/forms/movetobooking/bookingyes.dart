import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/salesexecutive/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class BookingformYes extends StatefulWidget {
  final int enquiryid;
  const BookingformYes({
    super.key,
    required this.enquiryid
  });

  @override
  State<BookingformYes> createState() => _BookingformYesState();
}

class _BookingformYesState extends State<BookingformYes> {

  final TextEditingController bookingamount = TextEditingController();
  final TextEditingController bookingreceiptno = TextEditingController();
  final TextEditingController vehiclename = TextEditingController();
  final TextEditingController vehiclecolour = TextEditingController();
  final TextEditingController chassisno = TextEditingController();
  final TextEditingController engineno = TextEditingController();
  final TextEditingController keyno = TextEditingController();
  final TextEditingController batteryno = TextEditingController();
  final TextEditingController tyremake = TextEditingController();
  final TextEditingController rrtyreno = TextEditingController();
  final TextEditingController fttyreno = TextEditingController();
  final TextEditingController addapprovedname = TextEditingController();
  final TextEditingController allotedby = TextEditingController();
  final TextEditingController deliverydate = TextEditingController();
  final TextEditingController deliverytime = TextEditingController();

  String bookingamounte = '';
  String bookingreceiptnoe = '';
  String vehiclenamee = '';
  String vehiclecoloure = '';
  String chassisnoe = '';
  String enginenoe = '';
  String keynoe = '';
  String batterynoe = '';
  String tyremakee = '';
  String rrtyrenoe = '';
  String fttyrenoe = '';
  String addapprovednamee = '';
  String allotedbye = '';
  String deliverydatee = '';
  String deliverytimee = '';

  Future<void> movetobooking() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/${widget.enquiryid}/move-to-booking/full');

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
          'chassis_no': chassisno.text.toString(),
          'engine_no': engineno.text.toString(),
          'key_no': keyno.text.toString(),
          'battery_no': batteryno.text.toString(),
          'tyre_make': tyremake.text.toString(),
          'RR_tyre_no': rrtyreno.text.toString(),
          'FT_tyre_no': fttyreno.text.toString(),
          'add_approved_name': addapprovedname.text.toString(),
          'alloted_by': allotedby.text.toString(),
          'delivery_date' : deliverydate.text.toString(),
          'delivery_time' : deliverytime.text.toString()
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
          chassisnoe = errors['chassis_no']?.toString() ?? '';
          enginenoe = errors['engine_no']?.toString() ?? '';
          keynoe = errors['key_no']?.toString() ?? '';
          batterynoe = errors['battery_no']?.toString() ?? '';
          tyremakee = errors['tyre_make']?.toString() ?? '';
          rrtyrenoe = errors['RR_tyre_no']?.toString() ?? '';
          fttyrenoe = errors['FT_tyre_no']?.toString() ?? '';
          addapprovednamee = errors['add_approved_name']?.toString() ?? '';
          allotedbye = errors['alloted_by']?.toString() ?? '';
          deliverydatee = errors['delivery_date']?.toString() ?? '';
          deliverytimee = errors['delivery_time']?.toString() ?? '';
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.h(20)),
                    back(context, Navigation(initialIndex: 1)),
                    Center(
                      child: Text(
                        'In Stock Form',
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
                      'Chassis No',
                      chassisno,
                    ),
                    if(chassisnoe.isNotEmpty)
                    errormessage(chassisnoe),
                    textfieldy(
                      'Engine No',
                      engineno,
                    ),
                    if(enginenoe.isNotEmpty)
                    errormessage(enginenoe),
                    textfieldy(
                      'Key No',
                      keyno,
                    ),
                    if(keynoe.isNotEmpty)
                    errormessage(keynoe),
                    textfieldy(
                      'Battery No',
                      batteryno,
                    ),
                    if(batterynoe.isNotEmpty)
                    errormessage(batterynoe),
                    textfieldy(
                      'Tyre Make',
                      tyremake,
                    ),
                    if(tyremakee.isNotEmpty)
                    errormessage(tyremakee),
                    textfieldy(
                      'RR Tyre No',
                      rrtyreno,
                    ),
                    if(rrtyrenoe.isNotEmpty)
                    errormessage(rrtyrenoe),
                    textfieldy(
                      'FT Tyre No',
                      fttyreno,
                    ),
                    if(fttyrenoe.isNotEmpty)
                    errormessage(fttyrenoe),
                    textfieldy(
                      'Add Approved Name',
                      addapprovedname,
                    ),
                    if(addapprovednamee.isNotEmpty)
                    errormessage(addapprovednamee),
                    textfieldy(
                      'Alloted By',
                      allotedby,
                    ),
                    if(allotedbye.isNotEmpty)
                    errormessage(allotedbye),
                    Followupdate(
                      title: 'Delivery Date',
                      datecontroller: deliverydate,
                    ),
                    if(deliverydatee.isNotEmpty)
                    errormessage(deliverydatee),
                    TimeField(
                      title: 'Delivery Time',
                      timeController: deliverytime,
                    ),
                    if(deliverytimee.isNotEmpty)
                    errormessage(deliverytimee),
                  ],
                ),
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
      ),
    );
  }
}