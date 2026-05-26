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

class EditfinanceMB extends StatefulWidget {
  final String? exchangeflag;
  final String enquiryid;
  final VoidCallback exchangeselected;
  final Map<String, dynamic> oldapiResponse;
  final Map<String, dynamic> apiResponse;

  final ValueChanged<bool>? onEditedChanged;

  final bool edit;
  const EditfinanceMB({
    super.key,
    required this.exchangeflag,
    required this.enquiryid,
    required this.exchangeselected,
    required this.apiResponse,
    required this.oldapiResponse,
    this.onEditedChanged,

    required this.edit
  });

  @override
  State<EditfinanceMB> createState() => _EditfinanceMBState();
}

class _EditfinanceMBState extends State<EditfinanceMB> {
  List<Map<String, String>> financeitems = [];
  List<Map<String, String>> loanperioditems = [];

  String? selectedfinanceitems;
  String? selectedloanperioditems;

  TextEditingController modalname = TextEditingController();
  TextEditingController modalvariant = TextEditingController();
  TextEditingController modalcolor = TextEditingController();

  TextEditingController maxloanpercentage= TextEditingController();
  TextEditingController maxloanamount= TextEditingController();
  TextEditingController minimumdownpayment = TextEditingController();
  TextEditingController totaldocumentcharge = TextEditingController();

  TextEditingController loanamount= TextEditingController();

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String loanamounte = '';
  String loanperioditemse = '';

  String nextpagelocal = '';

  Map<String, dynamic>? _financeResponse;

  String? oldexchange;

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
    print('old api response: ${widget.oldapiResponse}');
    oldapiexchange(widget.oldapiResponse);
    print('api response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
    fetchfinance();
  }

  Map<String, dynamic> originalEnquiry = {};

  bool? _lastReportedEdited;

  void _reportEditedToParent() {
    if (widget.onEditedChanged == null) return;
    final current = isEdited();
    if (current != _lastReportedEdited) {
      _lastReportedEdited = current;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onEditedChanged?.call(current);
      });
    }
  }

  bool isEdited() {
    return
      selectedfinanceitems != originalEnquiry['finance'] ||
      selectedloanperioditems != originalEnquiry['loan_period'].toString() ||
      vehiclecost.text != (originalEnquiry['vehicle_cost'] ?? '') ||
      loanamount.text != (originalEnquiry['loan_amount'] ?? '') ||
      emi.text != (originalEnquiry['emi'] ?? '') ||
      loaninterest.text != (originalEnquiry['loan_interest'] ?? '');
  }

  void oldapiexchange(Map<String, dynamic> resp) {
    final enquiry = resp;
    oldexchange = enquiry['exchange_flag'];
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

    selectedfinanceitems  = enquiry['finance']?.toString();
    financepreview(selectedfinanceitems ?? '');

    selectedloanperioditems = enquiry['loan_period']?.toString();

    vehiclecost = TextEditingController(text: (enquiry['vehicle_cost'] ?? '').toString());
    loaninterest = TextEditingController(text: (enquiry['loan_interest'] ?? '').toString());
    loanamount = TextEditingController(text: (enquiry['loan_amount'] ?? '').toString());
    emi = TextEditingController(text: (enquiry['emi'] ?? '').toString());

    minimumdownpayment = TextEditingController(text: (enquiry['emi'] ?? '').toString());

    modalname = TextEditingController(text: enquiry['model_name']);
    modalvariant = TextEditingController(text: enquiry['model_variant']);
    modalcolor = TextEditingController(text: enquiry['model_color']);
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

      print(modalname.text);
      print(modalvariant.text);
      print('Color: ${modalcolor.text}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> finances = data['data']['finance_schemes'];

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
        print("Failed to load Finance. Status code: ${response.statusCode}");
        print(response.body);
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

          final resp = widget.apiResponse;

          final enquiryLoanPeriod = resp['loan_period']?.toString();

          selectedloanperioditems = enquiryLoanPeriod;
        });
        print(responseData);
        finance();

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

    final resp = widget.apiResponse;
    print(resp);

    final String exchange = resp["exchange_flag"];
    print('exchange: $exchange');

    if (exchange == 'yes'  && oldexchange == 'no') {
      nextpagelocal = 'Exchange Form';
    } else {
      nextpagelocal = 'Quotation';
    }

    showMessagePopup(
      context,
      responseData['message'],
      () {
        Navigator.pop(context);
        if (exchange == 'yes' && oldexchange == 'no') {
          widget.exchangeselected();
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => QuotationSuccessPopup(
              name: '${api['data']['customer_name']}',
              number: '${api['data']['customer_contact_number']}',
              enquiryid: api['data']['enquiry_id'],
            ),
          );
        }
      },
      nextpage: nextpagelocal
    );
  }
  
  @override
  Widget build(BuildContext context) {
    _reportEditedToParent();
    return Padding(
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
            readOnly: widget.edit,
          ),
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
                },
                readonly: widget.edit
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
                readOnly: widget.edit
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
          if(isEdited() == true)
          SizedBox(height: SizeConfig.h(25)),
          if(isEdited() == true)
          button(
            'Update Quotation',
            () {
              submit();
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}