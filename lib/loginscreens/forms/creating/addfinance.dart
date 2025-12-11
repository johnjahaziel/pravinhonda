import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Addfinance extends StatefulWidget {
  final String? exchangeflag;
  final int enquiryid;
  final VoidCallback exchangeselected;
  const Addfinance({
    super.key,
    required this.exchangeflag,
    required this.enquiryid,
    required this.exchangeselected
  });

  @override
  State<Addfinance> createState() => _AddfinanceState();
}

class _AddfinanceState extends State<Addfinance> {

  List<Map<String, String>> financeitems = [];
  List<Map<String, String>> loanperioditems = [];

  String? selectedfinanceitems;
  String? selectedloanperioditems;

  bool financepreviewfields = false;

  TextEditingController modalname = TextEditingController();
  TextEditingController modalvariant = TextEditingController();
  TextEditingController modalcolor = TextEditingController();

  TextEditingController maxloanpercentage= TextEditingController();
  TextEditingController maxloanamount= TextEditingController();

  TextEditingController loanamount= TextEditingController();

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String loanamounte = '';
  String loanperioditemse = '';

  String nextpagelocal = '';

  @override
  void initState() {
    super.initState();
    apiresponse();
    fetchfinance();
  }

  void apiresponse() {
    final Map<String, dynamic> api = BlocProvider.of<ApiresponseCubit>(context).state.apiresponse ?? {};
    print('APi: $api');

    final resp = api['data'] ?? '';

    modalname = TextEditingController(text: resp['model_name']);
    modalvariant = TextEditingController(text: resp['model_variant']);
    modalcolor = TextEditingController(text: resp['model_color']);
  }

  Future<void> fetchfinance() async {
    final financeUrl = Uri.parse('https://app.pravinhonda.com/api/finance/schemes');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        financeUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> finances = data['data'];

        setState(() {
          financeitems = finances.map((item) {
            return {
              'name': item['name'].toString(),
            };
          }).toList();
        });
      } else if(response.statusCode == 404) {

        Fluttertoast.showToast(msg: data['message']);

      } else {
        print("Failed to load citys. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("City fetch error: $e");
    }
  }

  Future<void> financepreview(String selectedfinace) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/finance/preview/${widget.enquiryid}');

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
          financepreviewfields = true;
          vehiclecost = TextEditingController(text: responseData['data']['finance_rule']['vehicle_price'].toString());
          maxloanpercentage = TextEditingController(text: responseData['data']['finance_rule']['max_loan_percentage'].toString());
          maxloanamount = TextEditingController(text: responseData['data']['loan_amount'].toString());

          List<dynamic> rates = responseData['data']['rates'];

          loanperioditems = rates.map((item) {
            return {
              "id": item['months'].toString(),
              "name": "${item['months']}",
            };
          }).toList();

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

  Future<void> finance() async{
    final url = Uri.parse('https://app.pravinhonda.com/api/finance/save/${widget.enquiryid}');

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
          'finance': selectedfinanceitems,
          'loan_amount' : loanamount.text,
          'loan_period' : selectedloanperioditems
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {

        setState(() {
          emi = TextEditingController(text: responseData['data']['emi'].toString());
          loaninterest = TextEditingController(text: responseData['data']['loan_interest'].toString());
        });
        print(responseData);

      } else if (response.statusCode == 422) {
        final error = responseData['errors'] ?? '';

        loanamounte = error['loan_amount'].toString();
        loanperioditemse = error['loan_period'].toString();
      } else {
        Fluttertoast.showToast(msg: responseData['message']);
        print(responseData);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textfieldy(
                'Model Name',
                modalname,
                readonly: true
              ),
              textfieldy(
                'Model Variant',
                modalvariant,
                readonly: true
              ),
              textfieldy(
                'Model Color',
                modalcolor,
                readonly: true
              ),
              CustomNVCDropdown(
                title: 'Finance',
                selectedCustomDropdown: selectedfinanceitems,
                customDropdownItems: financeitems,
                onChanged:(newValue) {
                  setState(() {
                    selectedfinanceitems = newValue;
                    financepreview(selectedfinanceitems ?? '');
                  });
                },
              ),
              if(financepreviewfields = true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textfieldy(
                    'On Road Price',
                    vehiclecost,
                    readonly: true
                  ),
                  textfieldy(
                    'Max Loan Percentage',
                    maxloanpercentage,
                    readonly: true
                  ),
                  textfieldy(
                    'Max Loan Amount',
                    maxloanamount,
                    readonly: true
                  ),

                  textfieldy(
                    'Loan Amount',
                    loanamount,
                  ),
                  if(loanamounte.isNotEmpty)
                  errormessage(loanamounte),
                  CustomNVCDropdown(
                    title: 'Loan Period (Months)',
                    selectedCustomDropdown: selectedloanperioditems,
                    customDropdownItems: loanperioditems,
                    onChanged:(newValue) {
                      setState(() {
                        selectedloanperioditems = newValue;
                      });
                    },
                  ),
                  if(loanperioditemse.isNotEmpty)
                  errormessage(loanperioditemse),
                ],
              ),
              SizedBox(height: SizeConfig.h(10)),
              button(
                'Calculate',
                () {
                  finance();
                  print('Selected Loan Perod: $selectedloanperioditems');
                }
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
              SizedBox(height: SizeConfig.h(25)),
              button(
                'Submit',
                () {}
              ),
              SizedBox(height: SizeConfig.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}