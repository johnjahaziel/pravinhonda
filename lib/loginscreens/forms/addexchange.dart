import 'package:flutter/material.dart';
import 'package:pravinhonda/loginscreens/forms/createquotation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Addexchange extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Addexchange({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Addexchange> createState() => _AddexchangeState();
}

class _AddexchangeState extends State<Addexchange> {

  List<Map<String, String>>monthitems = [
    {'label': 'January', 'value': 'January'},
  ];

  String? selectedmonthitems;

  List<Map<String, String>> yearitems = [
    {'label': '2005', 'value': '2005'},
  ];

  String? selectedyearitems;

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController vehiclemodal = TextEditingController();
  TextEditingController expectedprice = TextEditingController();
  TextEditingController finalizedprice = TextEditingController();
  TextEditingController assessedby = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                    'Exchange',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
                textfieldy(
                  'Name',
                  name
                ),
                description(
                  'Address',
                  address
                ),
                textfieldy(
                  'Vehicle Modal',
                  vehiclemodal
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        title: 'Month',
                        selectedCustomDropdown: selectedmonthitems,
                        customDropdownItems: monthitems,
                        onChanged:(newValue) {
                          setState(() {
                            selectedmonthitems = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(10)),
                    Expanded(
                      child: CustomDropdown(
                        title: 'Year',
                        selectedCustomDropdown: selectedyearitems,
                        customDropdownItems: yearitems,
                        onChanged:(newValue) {
                          setState(() {
                            selectedyearitems = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                textfieldy(
                  'Expected Price',
                  expectedprice
                ),
                textfieldy(
                  'Finalized Price',
                  finalizedprice
                ),
                textfieldy(
                  'Assessed By',
                  assessedby
                ),
                SizedBox(height: SizeConfig.h(25)),
                button(
                  'Submit',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Createquotation(
                          enquiryid: widget.enquiryid,
                          apiResponse: widget.apiResponse,
                        )
                      )
                    );
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