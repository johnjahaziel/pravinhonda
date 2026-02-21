import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Viewfinace extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Viewfinace({
    super.key,
    required this.apiResponse
  });

  @override
  State<Viewfinace> createState() => _ViewfinaceState();
}

class _ViewfinaceState extends State<Viewfinace> {
  TextEditingController modalname = TextEditingController();
  TextEditingController modalvariant = TextEditingController();
  TextEditingController modalcolor = TextEditingController();

  TextEditingController maxloanpercentage= TextEditingController();
  TextEditingController maxloanamount= TextEditingController();
  TextEditingController minimumdownpayment = TextEditingController();
  TextEditingController totaldocumentcharge = TextEditingController();

  TextEditingController finance = TextEditingController();
  TextEditingController loanperiod= TextEditingController();

  TextEditingController loanamount= TextEditingController();

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String loanamounte = '';
  String loanperioditemse = '';

  String nextpagelocal = '';

  int enquiryid = 0;

  bool readonly = true;

  @override
  void initState() {
    super.initState();
    initControllersFromResponse(widget.apiResponse);
    financepreview(finance.text);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    enquiryid = enquiry['enquiry_id'];

    finance  = TextEditingController(text: (enquiry['finance'] ?? '').toString());
    loanperiod = TextEditingController(text: (enquiry['loan_period'] ?? '').toString());

    vehiclecost = TextEditingController(text: (enquiry['vehicle_cost'] ?? '').toString());
    loaninterest = TextEditingController(text: (enquiry['loan_interest'] ?? '').toString());
    loanamount = TextEditingController(text: (enquiry['loan_amount'] ?? '').toString());
    emi = TextEditingController(text: (enquiry['emi'] ?? '').toString());

    modalname = TextEditingController(text: enquiry['model_name']);
    modalvariant = TextEditingController(text: enquiry['model_variant']);
    modalcolor = TextEditingController(text: enquiry['model_color']);
  }

  Future<void> financepreview(String selectedfinace) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/finance/preview/$enquiryid');

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
          'finance': selectedfinace
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {

        setState(() {
          vehiclecost = TextEditingController(text: responseData['data']['finance_rule']['vehicle_price'].toString());
          minimumdownpayment = TextEditingController(text: responseData['data']['finance_rule']['minimum_down_payment'].toString());
          totaldocumentcharge = TextEditingController(text: responseData['data']['finance_rule']['total_doc_charges'].toString());

        });
        print(responseData);

      } else {
        Fluttertoast.showToast(msg: responseData['message']);
        print(responseData);
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
            'Model Name',
            modalname,
            readonly: readonly
          ),
          // textfieldy(
          //   'Model Variant',
          //   modalvariant,
          //   readonly: readonly
          // ),
          textfieldy(
            'Model Color',
            modalcolor,
            readonly: readonly
          ),
          textfieldy(
            'Finance',
            finance,
            readonly: readonly
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textfieldy(
                'On Road Price',
                vehiclecost,
                readonly: readonly
              ),
              textfieldy(
                'Total Document Charge',
                totaldocumentcharge,
                readonly: true
              ),
              textfieldy(
                'Minimum Down Payment',
                minimumdownpayment,
                readonly: readonly
              ),

              textfieldy(
                'Customer Down Payment',
                loanamount,
                readonly: readonly
              ),
              if(loanamounte.isNotEmpty)
              errormessage(loanamounte),
              textfieldy(
                'Loan Period (Month)',
                loanperiod,
                readonly: readonly
              ),
              if(loanperioditemse.isNotEmpty)
              errormessage(loanperioditemse),
            ],
          ),
          textfieldy(
            'EMI',
            emi,
            readonly: true
          ),
          textfieldy(
            'Loan Interest',
            loaninterest,
            readonly: true
          ),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}