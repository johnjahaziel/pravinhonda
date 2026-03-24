import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Addfinance extends StatefulWidget {
  final String? exchangeflag;
  final String enquiryid;
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
  bool financesaved = false;

  TextEditingController modalname = TextEditingController();
  TextEditingController modalvariant = TextEditingController();
  TextEditingController modalcolor = TextEditingController();

  TextEditingController maxloanpercentage= TextEditingController();
  TextEditingController maxloanamount= TextEditingController();
  TextEditingController totaldocumentcharge = TextEditingController();
  TextEditingController minimumdownpayment = TextEditingController();

  TextEditingController loanamount= TextEditingController();

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String loanamounte = '';
  String loanperioditemse = '';

  String nextpagelocal = '';

  Map<String, dynamic>? _financeResponse;

  void validateDownPayment() {
    final double minDown =
        double.tryParse(minimumdownpayment.text) ?? 0;
    final double customerDown =
        double.tryParse(loanamount.text) ?? 0;

    setState(() {
      if (customerDown < minDown) {
        loanamounte =
            'Customer down payment should be greater than the minimum down payment (${minimumdownpayment.text})';
      } else {
        loanamounte = '';
      }
    });
  }

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
    final financeUrl = Uri.parse('https://app.pravinhonda.com/api/finances/schemes');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        financeUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'model_name' : modalname.text,
          'variant_name' : modalvariant.text,
          'color_name' : modalcolor.text
        })
      );

      

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> finances = data['data']['finance_schemes'];

        print('Finance: $finances');

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
      print("Fetch error: $e");
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
          maxloanamount = TextEditingController(text: responseData['data']['Max_loan_amount'].toString());
          minimumdownpayment = TextEditingController(text: responseData['data']['finance_rule']['minimum_down_payment'].toString());
          totaldocumentcharge = TextEditingController(text: responseData['data']['finance_rule']['total_doc_charges'].toString());

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
          'user_down_payment' : loanamount.text,
          'loan_period' : selectedloanperioditems
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {

        setState(() {
          emi = TextEditingController(text: responseData['data']['emi'].toString());
          loaninterest = TextEditingController(text: responseData['data']['interest_rate'].toString());

          getoneenquiry();

          financesaved = true;
          _financeResponse = responseData;
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


      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  void submit() {
    if (_financeResponse == null) {
      Fluttertoast.showToast(msg: 'Please save finance details first.');
      return;
    }

    final responseData = _financeResponse!;
    final Map<String, dynamic> api = BlocProvider.of<ApiresponseCubit>(context).state.apiresponse ?? {};
    final resp = api['data'] ?? {};
    final exchange = resp['exchange_flag'] ?? '';

    if (exchange == 'yes') {
      nextpagelocal = 'Exchange Form';
    } else {
      nextpagelocal = 'Quotation';
    }

    showMessagePopup(
      context,
      responseData['message'],
      () {
        Navigator.pop(context);
        if (exchange == 'yes') {
          widget.exchangeselected();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Createquotation(
                enquiryid: resp['enquiry_id'],
                apiResponse: api,
              )
            )
          );
        }
      },
      nextpage: nextpagelocal,
    );
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
              // textfieldy(
              //   'Model Variant',
              //   modalvariant,
              //   readonly: true
              // ),
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
              if(financepreviewfields == true)
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
                    'Total Document Charge',
                    totaldocumentcharge,
                    readonly: true
                  ),
                  textfieldy(
                    'Minimum Down Payment',
                    minimumdownpayment,
                    readonly: true
                  ),

                  textfieldy(
                    'Customer Down Payment',
                    loanamount,
                    onChanged: (value) {
                      validateDownPayment();
                    }
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
              if(financesaved == true)
              button(
                'Submit',
                () {
                  submit();
                }
              ),
              SizedBox(height: SizeConfig.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}