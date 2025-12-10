import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class EditfinanceMB extends StatefulWidget {
  final String? exchangeflag;
  final int enquiryid;
  final VoidCallback exchangeselected;
  final Map<String, dynamic> oldapiResponse;
  final Map<String, dynamic> apiResponse;

  final bool edit;
  const EditfinanceMB({
    super.key,
    required this.exchangeflag,
    required this.enquiryid,
    required this.exchangeselected,
    required this.apiResponse,
    required this.oldapiResponse,

    required this.edit
  });

  @override
  State<EditfinanceMB> createState() => _EditfinanceMBState();
}

class _EditfinanceMBState extends State<EditfinanceMB> {
  List<Map<String, String>> financeitems = financeTypeItems;
  List<Map<String, String>> loanperioditems = loanperiodTypeItems;

  String? selectedfinanceitems;
  String? selectedloanperioditems;

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController initialpayment = TextEditingController();
  TextEditingController documentcharges = TextEditingController();
  TextEditingController downpayment = TextEditingController();
  TextEditingController loaninterest = TextEditingController();

  String financeitemse = '';
  String vehiclecoste = '';
  String loanperioditemse = '';
  String initialpaymente = '';
  String documentchargese = '';
  String downpaymente = '';
  String loanintereste = '';

  String nextpagelocal = '';

  String? oldexchange;

  @override
  void initState() {
    super.initState();
    print('old api response: ${widget.oldapiResponse}');
    oldapiexchange(widget.oldapiResponse);
    print('api response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void oldapiexchange(Map<String, dynamic> resp) {
    final enquiry = resp['data'] ?? {};
    oldexchange = enquiry['exchange_flag'];
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

    selectedfinanceitems    = enquiry['finance']?.toString();
    selectedloanperioditems = enquiry['loan_period']?.toString();

    vehiclecost = TextEditingController(text: (enquiry['vehicle_cost'] ?? '').toString());
    documentcharges = TextEditingController(text: (enquiry['document_charges'] ?? '').toString());
    downpayment = TextEditingController(text: (enquiry['down_payment'] ?? '').toString());
    loaninterest = TextEditingController(text: (enquiry['loan_interest'] ?? '').toString());
    initialpayment = TextEditingController(text: (enquiry['initial_payment'] ?? '').toString());
  }

  Map<String, dynamic> originalEnquiry = {};

  bool isEdited() {
    return 
      selectedfinanceitems != originalEnquiry['finance'] ||
      selectedloanperioditems != originalEnquiry['loan_period'].toString() ||
      vehiclecost.text != (originalEnquiry['vehicle_cost']?.toString() ?? '') ||
      documentcharges.text != (originalEnquiry['document_charges']?.toString() ?? '') ||
      downpayment.text != (originalEnquiry['down_payment']?.toString() ?? '') ||
      loaninterest.text != (originalEnquiry['loan_interest']?.toString() ?? '') ||
      initialpayment.text != (originalEnquiry['initial_payment']?.toString() ?? '');
  }

  Future<void> financeform() async {
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
          'finance': selectedfinanceitems?.toString(),
          'vehicle_cost': vehiclecost.text,
          'initial_payment': initialpayment.text,
          'document_charges': documentcharges.text,
          'down_payment': downpayment.text,
          'loan_interest': loaninterest.text,
          'loan_period': selectedloanperioditems?.toString(),

          // "finance": "Personal Loan",
          // "vehicle_cost": 500000,
          // "initial_payment": 50000,
          // "document_charges": 10000,
          // "down_payment": 100000,
          // "loan_interest": 12,
          // "loan_period": 12
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        final String exchange = responseData['data']["exchange_flag"];
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
                  name: '${responseData['data']['customer_name']}',
                  number: '${responseData['data']['customer_contact_number']}',
                  enquiryid: responseData['data']['enquiry_id'],
                ),
              );
            }
          },
          nextpage: nextpagelocal
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          financeitemse = errors['finance']?.toString() ?? '';
          vehiclecoste = errors['vehicle_cost']?.toString() ?? '';
          loanperioditemse = errors['loan_period']?.toString() ?? '';
          initialpaymente = errors['initial_payment']?.toString() ?? '';
          documentchargese = errors['document_charges']?.toString() ?? '';
          downpaymente = errors['down_payment']?.toString() ?? '';
          loanintereste = errors['loan_interest']?.toString() ?? '';
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              title: 'Finance',
              selectedCustomDropdown: selectedfinanceitems,
              customDropdownItems: financeitems,
              onChanged:(newValue) {
                setState(() {
                  selectedfinanceitems = newValue;
                });
              },
              readOnly: widget.edit,
            ),
            if(financeitemse.isNotEmpty)
            errormessage(financeitemse),
            textfieldy(
              'Vehicle Cost',
              vehiclecost,
              readonly: widget.edit,
            ),
            if(vehiclecoste.isNotEmpty)
            errormessage(vehiclecoste),
            textfieldy(
              'Initial Payment',
              initialpayment,
              readonly: widget.edit,
            ),
            if(initialpaymente.isNotEmpty)
            errormessage(initialpaymente),
            textfieldy(
              'Document Charges',
              documentcharges,
              readonly: widget.edit,
            ),
            if(documentchargese.isNotEmpty)
            errormessage(documentchargese),
            textfieldy(
              'Down Payment',
              downpayment,
              readonly: widget.edit,
            ),
            if(downpaymente.isNotEmpty)
            errormessage(downpaymente),
            textfieldy(
              'Loan Interest',
              loaninterest,
              readonly: widget.edit,
            ),
            if(loanintereste.isNotEmpty)
            errormessage(loanintereste),
            CustomDropdown(
              title: 'Loan Period',
              selectedCustomDropdown: selectedloanperioditems,
              customDropdownItems: loanperioditems,
              onChanged:(newValue) {
                setState(() {
                  selectedloanperioditems = newValue;
                });
              },
              readOnly: widget.edit,
            ),
            if(loanperioditemse.isNotEmpty)
            errormessage(loanperioditemse),
            // SizedBox(height: SizeConfig.h(20)),
            // button(
            //   'Calculate',
            //   () {}
            // ),
            // textfieldy(
            //   'EMI',
            //   TextEditingController(),
            //   // emi,
            //   readonly: true
            // ),
            if(isEdited() == true)
            SizedBox(height: SizeConfig.h(25)),
            if(isEdited() == true)
            button(
              'Update Quotation',
              () {
                financeform();
              }
            ),
            SizedBox(height: SizeConfig.h(30)),
          ],
        ),
      ),
    );
  }
}