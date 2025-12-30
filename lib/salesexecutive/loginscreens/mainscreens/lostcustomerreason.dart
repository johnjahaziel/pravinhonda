import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/salesexecutive/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
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

  List<Map<String, String>> duetobranditems = [];

  String? selectedotherhondadealeritems;

  List<Map<String, String>> otherhondadealeritems = [];

  TextEditingController otherscomments = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchbrand();
    fetchdealer();
  }

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/lost_customer/${widget.enquiryId}');

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

  Future<void> fetchbrand() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/brands');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> dataList = (responseData['data'] as List<dynamic>?) ?? [];

        setState(() {
          duetobranditems = dataList.map((item) {
            return {
              'id': item['id'].toString(),
              'name': item['brand_name'].toString(),
            };
          }).toList();
        });

        print(responseData);

      } else {
        print('Failed to fetch brands. Status Code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchdealer() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/dealers');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> dataList = (responseData['data'] as List<dynamic>?) ?? [];

        setState(() {
          otherhondadealeritems = dataList.map((item) {
            return {
              'id': item['id'].toString(),
              'name': item['dealer_name'].toString(),
            };
          }).toList();
        });

        print(responseData);

      } else {
        print('Failed to fetch brands. Status Code: ${response.statusCode}');
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
                    CustomNVCDropdown(
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
                    CustomNVCDropdown(
                      title: 'Choose the Dealer',
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
