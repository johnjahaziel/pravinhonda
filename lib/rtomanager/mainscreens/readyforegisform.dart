import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/rtomanager/NavigationRTo.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Readyforegisform extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Readyforegisform({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Readyforegisform> createState() => _ReadyforegisformState();
}

class _ReadyforegisformState extends State<Readyforegisform> {
  final TextEditingController insurancename = TextEditingController();
  final TextEditingController insuranceamount = TextEditingController();
  final TextEditingController insurancepolicy = TextEditingController();

  final TextEditingController rtinvoiceno = TextEditingController();
  final TextEditingController rtinvoiceamount = TextEditingController();
  final TextEditingController latefeeinvoiceno = TextEditingController();
  final TextEditingController latefeeinvoiceamount = TextEditingController();

  final TextEditingController fancyinvoiceno = TextEditingController();
  final TextEditingController fancynumber = TextEditingController();
  final TextEditingController fancyamount = TextEditingController();

  String insurancenamee = '';
  String insuranceamounte = '';
  String insurancepolicye = '';

  String rtinvoicenoe = '';
  String rtinvoiceamounte = '';
  String latefeeinvoicenoe = '';
  String latefeeinvoiceamounte = '';

  String fancyinvoicenoe = '';
  String fancynumbere = '';
  String fancyamounte = '';

  bool fancyEnabled = false;

  @override
  void initState() {
    super.initState();

    final data = widget.apiResponse;

    insurancename.text = data['insurance_name']?.toString() ?? '';
    insuranceamount.text = data['insurance_amount']?.toString() ?? '';
    insurancepolicy.text = data['insurance_policy']?.toString() ?? '';

    rtinvoiceno.text = data['rt_invoice_no']?.toString() ?? '';
    rtinvoiceamount.text = data['rt_invoice_amount']?.toString() ?? '';
    latefeeinvoiceno.text = data['late_fee_invoice_no']?.toString() ?? '';
    latefeeinvoiceamount.text = data['late_fee_invoice_amount']?.toString() ?? '';

    fancyinvoiceno.text = data['fancy_invoice_no']?.toString() ?? '';
    fancynumber.text = data['fancy_number']?.toString() ?? '';
    fancyamount.text = data['fancy_amount']?.toString() ?? '';

    fancyEnabled = (data['fancy_no']?.toString().toLowerCase() == 'yes');
  }

  Future<void> movetoreadyforregis() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/update-registration/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final Map<String, dynamic> body = {
      'insurance_name': insurancename.text.toString(),
      'insurance_amount': insuranceamount.text.toString(),
      'insurance_policy': insurancepolicy.text.toString(),
      'rt_invoice_no': rtinvoiceno.text.toString(),
      'rt_invoice_amount': rtinvoiceamount.text.toString(),
      'late_fee_invoice_no': latefeeinvoiceno.text.toString(),
      'late_fee_invoice_amount': latefeeinvoiceamount.text.toString(),
    };

    if (fancyEnabled) {
      body['fancy_invoice_no'] = fancyinvoiceno.text.toString();
      body['fancy_number'] = fancynumber.text.toString();
      body['fancy_amount'] = fancyamount.text.toString();
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(responseData);
        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationRTO(
              initialIndex: 2,
            ),
          ),
        );
      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          insurancenamee = errors['insurance_name']?.toString() ?? '';
          insuranceamounte = errors['insurance_amount']?.toString() ?? '';
          insurancepolicye = errors['insurance_policy']?.toString() ?? '';
          rtinvoicenoe = errors['rt_invoice_no']?.toString() ?? '';
          rtinvoiceamounte = errors['rt_invoice_amount']?.toString() ?? '';
          latefeeinvoicenoe = errors['late_fee_invoice_no']?.toString() ?? '';
          latefeeinvoiceamounte = errors['late_fee_invoice_amount']?.toString() ?? '';
          fancyinvoicenoe = errors['fancy_invoice_no']?.toString() ?? '';
          fancynumbere = errors['fancy_number']?.toString() ?? '';
          fancyamounte = errors['fancy_amount']?.toString() ?? '';
        });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Status code: ${response.statusCode}');
        print(response.body);
      } else {
        print(responseData);
        Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget sectionHeader(String title) => Padding(
    padding: EdgeInsets.only(top: SizeConfig.h(20), bottom: SizeConfig.h(5)),
    child: Text(
      title,
      style: customtext(fs16, kred, FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader('Insurance'),
          textfieldy('Insurance Name', insurancename),
          if (insurancenamee.isNotEmpty) errormessage(insurancenamee),
          textfieldy('Insurance Amount', insuranceamount, numpad: true),
          if (insuranceamounte.isNotEmpty) errormessage(insuranceamounte),
          textfieldy('Insurance Policy', insurancepolicy),
          if (insurancepolicye.isNotEmpty) errormessage(insurancepolicye),

          sectionHeader('RTO'),
          textfieldy('RT Invoice No', rtinvoiceno),
          if (rtinvoicenoe.isNotEmpty) errormessage(rtinvoicenoe),
          textfieldy('RT Invoice Amount', rtinvoiceamount, numpad: true),
          if (rtinvoiceamounte.isNotEmpty) errormessage(rtinvoiceamounte),
          textfieldy('Late Fee Invoice No', latefeeinvoiceno),
          if (latefeeinvoicenoe.isNotEmpty) errormessage(latefeeinvoicenoe),
          textfieldy('Late Fee Invoice Amount', latefeeinvoiceamount, numpad: true),
          if (latefeeinvoiceamounte.isNotEmpty) errormessage(latefeeinvoiceamounte),

          if (fancyEnabled) ...[
            sectionHeader('Fancy Number'),
            textfieldy('Fancy Invoice No', fancyinvoiceno),
            if (fancyinvoicenoe.isNotEmpty) errormessage(fancyinvoicenoe),
            textfieldy('Fancy Number', fancynumber),
            if (fancynumbere.isNotEmpty) errormessage(fancynumbere),
            textfieldy('Fancy Amount', fancyamount, numpad: true),
            if (fancyamounte.isNotEmpty) errormessage(fancyamounte),
          ],

          SizedBox(height: SizeConfig.h(20)),
          button(
            'Move to Ready for Registration',
            () {
              movetoreadyforregis();
            },
          ),
          SizedBox(height: SizeConfig.h(40)),
        ],
      ),
    );
  }
}
