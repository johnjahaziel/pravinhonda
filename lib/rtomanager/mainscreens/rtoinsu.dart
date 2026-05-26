import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/rtomanager/NavigationRTo.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Rtoinsu extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Rtoinsu({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Rtoinsu> createState() => _RtoinsuState();
}

class _RtoinsuState extends State<Rtoinsu> {
  final TextEditingController insurancename = TextEditingController();
  final TextEditingController insuranceamount = TextEditingController();
  final TextEditingController insurancepolicy = TextEditingController();

  final TextEditingController fancyinvoiceno = TextEditingController();
  final TextEditingController fancynumber = TextEditingController();
  final TextEditingController fancyamount = TextEditingController();

  String insurancenamee = '';
  String insuranceamounte = '';
  String insurancepolicye = '';

  String fancyinvoicenoe = '';
  String fancynumbere = '';
  String fancyamounte = '';

  bool fancyEnabled = false;

  @override
  void initState() {
    super.initState();
    getoneenquiry();
  }

  Future<void> getoneenquiry() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        BlocProvider.of<ApiresponseCubit>(context).clearApiresponse();
        BlocProvider.of<ApiresponseCubit>(context).setApiresponse(responseData);

        print('Get One Enquiry: $responseData');

        final data = responseData['data'] ?? {};
        setState(() {
          fancyEnabled = (data['fancy_no']?.toString().toLowerCase() == 'yes');
        });

      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> movetoreadyforregis() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/ready-registration/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final Map<String, dynamic> body = {
      'insurance_name': insurancename.text.toString(),
      'insurance_amount': insuranceamount.text.toString(),
      'insurance_policy': insurancepolicy.text.toString(),
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
              initialIndex: 1,
            ),
          ),
        );
      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          insurancenamee = errors['insurance_name']?.toString() ?? '';
          insuranceamounte = errors['insurance_amount']?.toString() ?? '';
          insurancepolicye = errors['insurance_policy']?.toString() ?? '';
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
            'Move to Pending',
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
