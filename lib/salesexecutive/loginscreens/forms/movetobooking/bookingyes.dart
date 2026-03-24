import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class BookingformYes extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const BookingformYes({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<BookingformYes> createState() => _BookingformYesState();
}

class _BookingformYesState extends State<BookingformYes> {

  final TextEditingController bookingamount = TextEditingController();
  // final TextEditingController bookingreceiptno = TextEditingController();
  late TextEditingController vehiclename;
  late TextEditingController vehiclecolour;
  final TextEditingController chassisno = TextEditingController();
  final TextEditingController engineno = TextEditingController();
  final TextEditingController keyno = TextEditingController();
  final TextEditingController batteryno = TextEditingController();
  final TextEditingController tyremake = TextEditingController();
  final TextEditingController rrtyreno = TextEditingController();
  final TextEditingController fttyreno = TextEditingController();
  // final TextEditingController addapprovedname = TextEditingController();
  // final TextEditingController allotedby = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
    fetchChasisino();
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    vehiclename = TextEditingController(text: enquiry['model_name']);
    vehiclecolour = TextEditingController(text: enquiry['model_color']);
  }

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
          // 'booking_receipt_no': bookingreceiptno.text.toString(),
          'model_name': vehiclename.text.toString(),
          'model_color': vehiclecolour.text.toString(),
          'chassis_no': selectedchasisnoitems,
          // 'engine_no': engineno.text.toString(),
          // 'key_no': keyno.text.toString(),
          // 'battery_no': batteryno.text.toString(),
          // 'tyre_make': tyremake.text.toString(),
          // 'RR_tyre_no': rrtyreno.text.toString(),
          // 'FT_tyre_no': fttyreno.text.toString(),
          // 'add_approved_name': addapprovedname.text.toString(),
          // 'alloted_by': allotedby.text.toString(),
          'delivery_date' : deliverydate.text.toString(),
          'delivery_time' : deliverytime.text.toString()
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final vehicleData = responseData['data'];

        if (vehicleData != null) {
          engineno.text = vehicleData['engine_no'] ?? '';
          keyno.text = vehicleData['key_no'] ?? '';
          batteryno.text = vehicleData['battery_no'] ?? '';
          tyremake.text = vehicleData['tyre_make'] ?? '';
          rrtyreno.text = vehicleData['RR_tyre_no'] ?? '';
          fttyreno.text = vehicleData['FT_tyre_no'] ?? '';
        }

        await showMessageBookingPopup(
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
          },

          hasVehicleData: vehicleData != null,

          engineno: engineno,
          keyno: keyno,
          batteryno: batteryno,
          tyremake: tyremake,
          rrtyreno: rrtyreno,
          fttyreno: fttyreno,
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

  String? selectedchasisnoitems;

  List<Map<String, String>> chasisnoitems = [];

  Future<void> fetchChasisino() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/get-chassis');
    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model_name' : vehiclename.text,
          'model_color' : vehiclecolour.text
        })
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> chassisList =
            responseData['data']?['chassis_no'] ?? [];

        setState(() {
          chasisnoitems = chassisList.map((item) {
            return {
              'id': item.toString(),
              'name': item.toString(),
            };
          }).toList();
        });

        print(chasisnoitems);
      } else {
        print('Failed to fetch chassis. Status Code: ${response.statusCode}');
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
                    // textfieldy(
                    //   'Booking Receipt No',
                    //   bookingreceiptno,
                    //   star: false
                    // ),
                    // if(bookingreceiptnoe.isNotEmpty)
                    // errormessage(bookingreceiptnoe),
                    textfieldy(
                      'Vehicle Name',
                      vehiclename,
                      readonly: true
                    ),
                    if(vehiclenamee.isNotEmpty)
                    errormessage(vehiclenamee),
                    textfieldy(
                      'Vehicle Colour',
                      vehiclecolour,
                      readonly: true
                    ),
                    if(vehiclecoloure.isNotEmpty)
                    errormessage(vehiclecoloure),
                    CustomNVCDropdown(
                      title: 'Choose the Chasis No',
                      selectedCustomDropdown: selectedchasisnoitems,
                      customDropdownItems: chasisnoitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedchasisnoitems = newValue;
                        });
                      },
                    ),
                    if(chassisnoe.isNotEmpty)
                    errormessage(chassisnoe),
                    Followupdate(
                      title: 'Estimated Delivery Date',
                      datecontroller: deliverydate,
                    ),
                    if(deliverydatee.isNotEmpty)
                    errormessage(deliverydatee),
                    TimeField(
                      title: 'Estimated Delivery Time',
                      timeController: deliverytime,
                    ),
                    if(deliverytimee.isNotEmpty)
                    errormessage(deliverytimee),
                    SizedBox(height: SizeConfig.h(10)),
                    button(
                      'Move to Booking',
                      () {
                        movetobooking();
                      }
                    ),
                    SizedBox(height: SizeConfig.h(20)),
                    // textfieldy(
                    //   'Add Approved Name',
                    //   addapprovedname,
                    // ),
                    // if(addapprovednamee.isNotEmpty)
                    // errormessage(addapprovednamee),
                    // textfieldy(
                    //   'Alloted By',
                    //   allotedby,
                    // ),
                    // if(allotedbye.isNotEmpty)
                    // errormessage(allotedbye),
                  ],
                ),
                // SizedBox(height: SizeConfig.h(20)),
                // button(
                //   'Move to Booking',
                //   () {
                //     movetobooking();
                //   }
                // ),
                
                SizedBox(height: SizeConfig.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showMessageBookingPopup(
  BuildContext context,
  String message,
  VoidCallback onTap, {
  String nextpage = '',
  required bool hasVehicleData,

  required TextEditingController engineno,
  required TextEditingController keyno,
  required TextEditingController batteryno,
  required TextEditingController tyremake,
  required TextEditingController rrtyreno,
  required TextEditingController fttyreno
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // important
        insetPadding: EdgeInsets.zero, // removes default margin
        child: Container(
          width: double.infinity, // full width
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(20), // 👈 your padding control
          ),
          padding: EdgeInsets.all(SizeConfig.w(20)),
          decoration: BoxDecoration(
            color: kwhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fs14),
                ),

                SizedBox(height: SizeConfig.h(20)),
                if (hasVehicleData ==  true)
                Column(
                  children: [
                    textfieldy('Engine No', engineno, readonly: true),
                    textfieldy('Key No', keyno, readonly: true),
                    textfieldy('Battery No', batteryno, readonly: true),
                    textfieldy('Tyre Make', tyremake, readonly: true),
                    textfieldy('RR Tyre No', rrtyreno, readonly: true),
                    textfieldy('FT Tyre No', fttyreno, readonly: true),
                  ],
                ),

                SizedBox(height: SizeConfig.h(20)),

                SizedBox(
                  width: double.infinity, // full width button
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "OK",
                      style: customtext(fs12, kred, FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}