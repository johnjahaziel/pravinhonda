import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Editbooking extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Editbooking({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Editbooking> createState() => _EditbookingState();
}

class _EditbookingState extends State<Editbooking> {
  late TextEditingController bookingamount;
  late TextEditingController bookingreceiptno;
  late TextEditingController bookingremarks;
  late TextEditingController chassisno;
  late TextEditingController engineno;
  late TextEditingController keyno;
  late TextEditingController batteryno;
  late TextEditingController tyremake;
  late TextEditingController rrtyreno;
  late TextEditingController fttyreno;
  late TextEditingController deliverydate;
  late TextEditingController deliverytime;
  late TextEditingController addapprovedname;
  late TextEditingController allotedby;

  String deliverydatee = '';
  String deliverytimee = '';

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
    print('Api Response from child: ${widget.apiResponse}');
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    bookingamount = TextEditingController(text: enquiry['booking_amount']?.toString() ?? '');
    bookingreceiptno = TextEditingController(text: enquiry['booking_receipt_no']?.toString() ?? '');
    bookingremarks = TextEditingController(text: enquiry['booking_remarks']?.toString() ?? '');
    chassisno = TextEditingController(text: enquiry['chassis_no']?.toString() ?? '');
    engineno = TextEditingController(text: enquiry['engine_no']?.toString() ?? '');
    keyno = TextEditingController(text: enquiry['key_no']?.toString() ?? '');
    batteryno = TextEditingController(text: enquiry['battery_no']?.toString() ?? '');
    tyremake = TextEditingController(text: enquiry['tyre_make']?.toString() ?? '');
    rrtyreno = TextEditingController(text: enquiry['RR_tyre_no']?.toString() ?? '');
    fttyreno = TextEditingController(text: enquiry['FT_tyre_no']?.toString() ?? '');
    deliverydate = TextEditingController(text: enquiry['delivery_date']?.toString() ?? '');
    deliverytime = TextEditingController(text: enquiry['delivery_time']?.toString() ?? '');
    addapprovedname = TextEditingController(text: enquiry['add_approved_name']?.toString() ?? '');
    allotedby = TextEditingController(text: enquiry['alloted_by']?.toString() ?? '');
  }

  Future<void> exchangeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
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
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => QuotationSuccessPopup(
                  name: '${responseData['data']['customer_name']}',
                  number: '${responseData['data']['customer_contact_number']}',
                  enquiryid: responseData['data']['enquiry_id'],
                ),
              );
          },
          nextpage: 'Quotation'
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          deliverydatee = errors['delivery_date']?.toString() ?? '';
          deliverytimee = errors['delivery_time']?.toString() ?? '';
        });

        Fluttertoast.showToast(msg: responseData['message']);
        print(response.body);
      } else {
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          }
        );
        print(response.body);
      }
    } catch (error) {
      print('Error submitting finance form: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textfieldy(
            'Booking Amount',
            bookingamount,
            readonly: true,
          ),
          textfieldy(
            'Booking Receipt No.',
            bookingreceiptno,
            readonly: true,
          ),
          textfieldy(
            'Booking Remarks',
            bookingremarks,
            readonly: true,
          ),
          textfieldy(
            'Chassis No',
            chassisno,
            readonly: true,
          ),
          textfieldy(
            'Engine No',
            engineno,
            readonly: true,
          ),
          textfieldy(
            'Key No',
            keyno,
            readonly: true,
          ),
          textfieldy(
            'Battery No',
            batteryno,
            readonly: true,
          ),
          textfieldy(
            'Tyre Make',
            tyremake,
            readonly: true,
          ),
          textfieldy(
            'RR Tyre No',
            rrtyreno,
            readonly: true,
          ),
          textfieldy(
            'FT Tyre No',
            fttyreno,
            readonly: true,
          ),
          Followupdate(
            title: 'Estimated Delivery Date',
            datecontroller: deliverydate,
            readOnly: false,
          ),
          if(deliverydatee.isNotEmpty)
          errormessage(deliverydatee),
          TimeField(
            title: 'Estimated Delivery Time',
            timeController: deliverytime,
            readOnly: false,
          ),
          if(deliverytimee.isNotEmpty)
          errormessage(deliverytimee),
          SizedBox(height: SizeConfig.h(10)),
          button(
            'Update Booking',
            () {
              exchangeform();
            }
          ),
          // textfieldy(
          //   'Add Approved Name',
          //   addapprovedname,
          //   readonly: true,
          // ),
          // textfieldy(
          //   'Alloted By',
          //   allotedby,
          //   readonly: true,
          // ),
          SizedBox(height: SizeConfig.h(40)),
        ],
      ),
    );
  }
}