import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Vformbookingyes extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Vformbookingyes({
    super.key,
    required this.apiResponse,
  });

  @override
  State<Vformbookingyes> createState() => _VformbookingyesState();
}

class _VformbookingyesState extends State<Vformbookingyes> {
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
            readOnly: true,
          ),
          TimeField(
            title: 'Estimated Delivery Time',
            timeController: deliverytime,
            readOnly: true,
          ),
          textfieldy(
            'Add Approved Name',
            addapprovedname,
            readonly: true,
          ),
          textfieldy(
            'Alloted By',
            allotedby,
            readonly: true,
          ),
          SizedBox(height: SizeConfig.h(40)),
        ],
      ),
    );
  }
}