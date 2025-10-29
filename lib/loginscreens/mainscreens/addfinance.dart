import 'package:flutter/material.dart';
import 'package:pravinhonda/loginscreens/mainscreens/addexchange.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Addfinance extends StatefulWidget {
  final String? exchangeflag;
  const Addfinance({
    super.key,
    required this.exchangeflag
  });

  @override
  State<Addfinance> createState() => _AddfinanceState();
}

class _AddfinanceState extends State<Addfinance> {

  List<Map<String, String>> financeitems = [
    {'label': 'INDUS INDBANK LTD', 'value': 'INDUS INDBANK LTD'},
  ];

  String? selectedfinanceitems;

  List<Map<String, String>> loanperioditems = [
    {'label': '12', 'value': '12'},
  ];

  String? selectedloanperioditems;

  TextEditingController vehiclecost = TextEditingController();
  TextEditingController initialpayment = TextEditingController();
  TextEditingController documentcharges = TextEditingController();
  TextEditingController downpayment = TextEditingController();
  TextEditingController loaninterest = TextEditingController();
  TextEditingController emi = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(20)),
                Center(
                  child: Text(
                    'Finance',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
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
                textfieldy(
                  'Vehicle Cost',
                  vehiclecost
                ),
                textfieldy(
                  'Initial Payment',
                  initialpayment
                ),
                textfieldy(
                  'Document Charges',
                  documentcharges
                ),
                textfieldy(
                  'Down Payment',
                  downpayment
                ),
                textfieldy(
                  'Loan Interest',
                  loaninterest
                ),
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
                SizedBox(height: SizeConfig.h(20)),
                button(
                  'Calculate',
                  () {}
                ),
                textfieldy(
                  'EMI',
                  emi
                ),
                SizedBox(height: SizeConfig.h(25)),
                button(
                  'Submit',
                  () {
                    if(widget.exchangeflag == 'Yes'){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Addexchange()
                        )
                      );
                    }
                  }
                ),
                SizedBox(height: SizeConfig.h(30)),
              ],
            ),
          ),
        ),
      )
    );
  }
}