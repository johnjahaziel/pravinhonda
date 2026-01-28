import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Vformbookingno extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Vformbookingno({
    super.key,
    required this.apiResponse,
  });

  @override
  State<Vformbookingno> createState() => _VformbookingnoState();
}

class _VformbookingnoState extends State<Vformbookingno> {
late TextEditingController bookingamount;
  late TextEditingController bookingreceiptno;
  late TextEditingController bookingremarks;
  late TextEditingController deliverydate;
  late TextEditingController deliverytime;

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
    deliverydate = TextEditingController(text: enquiry['expected_delivery_date']?.toString() ?? '');
    deliverytime = TextEditingController(text: enquiry['delivery_time']?.toString() ?? '');
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
          Followupdate(
            title: 'Estimated Delivery Date',
            datecontroller: deliverydate,
            readOnly: true,
          ),
          SizedBox(height: SizeConfig.h(40)),
        ],
      ),
    );
  }
}