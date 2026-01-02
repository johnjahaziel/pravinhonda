import 'package:flutter/material.dart';
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

  TextEditingController finance = TextEditingController();
  TextEditingController loanperiod= TextEditingController();

  TextEditingController loanamount= TextEditingController();

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();

  String loanamounte = '';
  String loanperioditemse = '';

  String nextpagelocal = '';

  bool readonly = true;

  @override
  void initState() {
    super.initState();
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

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
          textfieldy(
            'Model Variant',
            modalvariant,
            readonly: readonly
          ),
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
              // textfieldy(
              //   'Max Loan Percentage',
              //   maxloanpercentage,
              //   readonly: readonly
              // ),
              // textfieldy(
              //   'Max Loan Amount',
              //   maxloanamount,
              //   readonly: readonly
              // ),
              textfieldy(
                'Loan Amount',
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