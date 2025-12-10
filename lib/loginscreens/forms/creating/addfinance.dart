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

  List<Map<String, String>> financeitems = financeTypeItems;
  List<Map<String, String>> loanperioditems = loanperiodTypeItems;

  String? selectedfinanceitems;
  String? selectedloanperioditems;

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController initialpayment = TextEditingController();
  TextEditingController documentcharges = TextEditingController();
  TextEditingController downpayment = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String financeitemse = '';
  String vehiclecoste = '';
  String loanperioditemse = '';
  String initialpaymente = '';
  String documentchargese = '';
  String downpaymente = '';
  String loanintereste = '';

  String nextpagelocal = '';

  Future<void> financeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/finance/${widget.enquiryid}');

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

        final int enquiryid = responseData['data']['enquiry_id'];

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
                    enquiryid: enquiryid,
                    apiResponse: responseData,
                  )
                )
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
    SizeConfig.init(context);
    return Expanded(
      child: SingleChildScrollView(
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
              ),
              if(financeitemse.isNotEmpty)
              errormessage(financeitemse),
              textfieldy(
                'Vehicle Cost',
                vehiclecost
              ),
              if(vehiclecoste.isNotEmpty)
              errormessage(vehiclecoste),
              textfieldy(
                'Initial Payment',
                initialpayment
              ),
              if(initialpaymente.isNotEmpty)
              errormessage(initialpaymente),
              textfieldy(
                'Document Charges',
                documentcharges
              ),
              if(documentchargese.isNotEmpty)
              errormessage(documentchargese),
              textfieldy(
                'Down Payment',
                downpayment
              ),
              if(downpaymente.isNotEmpty)
              errormessage(downpaymente),
              textfieldy(
                'Loan Interest',
                loaninterest
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
              ),
              if(loanperioditemse.isNotEmpty)
              errormessage(loanperioditemse),
              SizedBox(height: SizeConfig.h(20)),
              button(
                'Calculate',
                () {}
              ),
              textfieldy(
                'EMI',
                emi,
                readonly: true
              ),
              SizedBox(height: SizeConfig.h(25)),
              button(
                'Submit',
                () {
                  financeform();
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