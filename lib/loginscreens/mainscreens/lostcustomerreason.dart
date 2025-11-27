import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class LostcustomerReason extends StatefulWidget {
  final int enquiryId;
  const LostcustomerReason({
    super.key,
    required this.enquiryId,
  });

  @override
  State<LostcustomerReason> createState() => _LostcustomerReasonState();
}

class _LostcustomerReasonState extends State<LostcustomerReason> {
  String? selectedReason;

  String? selectedduetobranditems;

  List<Map<String, String>> duetobranditems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedotherhondadealeritems;

  List<Map<String, String>> otherhondadealeritems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  TextEditingController otherscomments = TextEditingController();

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/mark-loss-customer/${widget.enquiryId}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'reason': selectedReason,
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: responseData['message']);
        print('Data submitted successfully.');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
          ((route) => false)
        );

      } else {
        Fluttertoast.showToast(msg: responseData['message']);
        print('Failed to submit data. Status Code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.h(20)),
              Center(
                child: Text(
                  'Lost Customer',
                  style: customtext(fs18, kred, FontWeight.bold),
                ),
              ),
              SizedBox(height: SizeConfig.h(20)),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.w(0), top: SizeConfig.h(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Customcheckbox(
                      isChecked: selectedReason == 'Due to Brand',
                      title: 'Due to Brand',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Due to Brand';
                        });
                      },
                    ),
                    if (selectedReason == 'Due to Brand')
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedduetobranditems,
                      customDropdownItems: duetobranditems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedduetobranditems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Other Honda Dealer',
                      title: 'Other Honda Dealer',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Other Honda Dealer';
                        });
                      },
                    ),
                    if (selectedReason == 'Other Honda Dealer')
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedotherhondadealeritems,
                      customDropdownItems: otherhondadealeritems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedotherhondadealeritems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Discount',
                      title: 'Discount',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Discount';
                        });
                      },
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Product',
                      title: 'Product',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Product';
                        });
                      },
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Service',
                      title: 'Service',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Service';
                        });
                      },
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Availability',
                      title: 'Availability',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Availability';
                        });
                      },
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Price',
                      title: 'Price',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Price';
                        });
                      },
                    ),

                    Customcheckbox(
                      isChecked: selectedReason == 'Others',
                      title: 'Others',
                      onChanged: (val) {
                        setState(() {
                          selectedReason = 'Others';
                        });
                      },
                    ),
                    if (selectedReason == 'Others')
                    description(
                      '',
                      otherscomments,
                      padding: true
                    ),

                    SizedBox(height: SizeConfig.h(20)),
                    button(
                      'Submit',
                      () {
                        apiconnection();
                      },
                      padding: true
                    ),
                    SizedBox(height: SizeConfig.h(40)),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Customcheckbox extends StatelessWidget {
  final bool isChecked;
  final String title;
  final ValueChanged<bool> onChanged;

  const Customcheckbox({
    super.key,
    required this.isChecked,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.w(20), top: SizeConfig.h(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: kred,
          ),
          Text(
            title,
            style: textmedium14,
          )
        ],
      ),
    );
  }
}
