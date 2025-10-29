import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/loginscreens/mainscreens/addexchange.dart';
import 'package:pravinhonda/loginscreens/mainscreens/addfinance.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Createenquiry extends StatefulWidget {
  const Createenquiry({super.key});

  @override
  State<Createenquiry> createState() => _CreateenquiryState();
}

class _CreateenquiryState extends State<Createenquiry> {

  List<Map<String, String>> customercategoryitems = [
    {'label': 'Individual', 'value': 'Individual'},
  ];

  String? selectedcustomercategoryitems;

  List<Map<String, String>> enquirycategoryitems = [
    {'label': 'Individual', 'value': 'Individual'},
  ];

  String? selectedenquirycategoryitems;

  List<Map<String, String>> customertypeitems = [
    {'label': 'First Time Buyer', 'value': 'First Time Buyer'},
  ];

  String? selectedcustomertypeitems;

  List<Map<String, String>> genderitems = [
    {'label': 'Male', 'value': 'Male'},
    {'label': 'Female', 'value': 'Female'},
    {'label': 'Other', 'value': 'Other'},
  ];

  String? selectedgenderitems;

  List<Map<String, String>> martialstatusitems = [
    {'label': 'Married', 'value': 'Married'},
    {'label': 'Single', 'value': 'Single'},
  ];

  String? selectedmartialstatusitems;

  List<Map<String, String>> enquirytypeitems = [
    {'label': 'Enquiry Type', 'value': 'Enquiry Type'},
  ];

  String? selectedenquirytypeitems;

  List<Map<String, String>> enquirysourceitems = [
    {'label': 'Enquiry Source', 'value': 'Enquiry Source'},
  ];

  String? selectedenquirysourceitems;

  List<Map<String, String>> modelcategoryitems = [
    {'label': 'Model Category', 'value': 'Model Category'},
  ];

  String? selectedmodelcategoryitems;

  List<Map<String, String>> modelnameitems = [
    {'label': 'Model Name', 'value': 'Model Name'},
  ];

  String? selectedmodelnameitems;

  List<Map<String, String>> modelvariantitems = [
    {'label': 'Model Variant', 'value': 'Model Variant'},
  ];

  String? selectedmodelvariantitems;

  List<Map<String, String>> modelcoloritems = [
    {'label': 'Model Color', 'value': 'Model Color'},
  ];

  String? selectedmodelcoloritems;

  List<Map<String, String>> purchasetypeitems = [
    {'label': 'Cash', 'value': 'Cash'},
    {'label': 'Finance', 'value': 'Finance'},
  ];

  String? selectedpurchasetypeitems;

  List<Map<String, String>> exchangeflagitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedexchangeflagitems;

  List<Map<String, String>> testrideitems = [
    {'label': 'Test Ride', 'value': 'Test Ride'},
  ];

  String? selectedtestrideitems;

  TextEditingController enquiryid = TextEditingController();
  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController followupdatecontroller = TextEditingController();
  TextEditingController customerremarks = TextEditingController();

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'enquiry_id': enquiryid.text,
          'wings_enquiry_number': wingsenquiry.text,
          'customer_category' : selectedcustomercategoryitems,
          'enquiry_category' : selectedenquirycategoryitems,
          'customer_type' : selectedcustomertypeitems,
          'customer_contact_number' : customercontactnumber.text,
          'customer_name' : customername.text,
          'gender' : selectedgenderitems,
          'date_of_birth' : datecontroller.text,
          'martial_status' : selectedmartialstatusitems,
          'email_id' : emailid.text,
          'address' : address.text,
          'enquiry_type' : selectedenquirytypeitems,
          'enquiry_source' : selectedenquirysourceitems,
          'model_category' : selectedmodelcategoryitems,
          'model_name' : selectedmodelnameitems,
          'model_variant' : selectedmodelvariantitems,
          'model_color' : selectedmodelcoloritems,
          'purchase_type' : selectedpurchasetypeitems,
          'exchange_flag' : selectedexchangeflagitems,
          'follow_up_date' : followupdatecontroller.text,
          'test_ride' : selectedtestrideitems,
          'customer_remarks' : customerremarks.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        if(selectedpurchasetypeitems == 'Finance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addfinance(
                exchangeflag: selectedexchangeflagitems,
              )
            ),
          );
        } else if (selectedpurchasetypeitems != 'Finance' && selectedexchangeflagitems == 'Yes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addexchange()
            )
          );
        }


      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to create enquiry. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(20)),
                Center(
                  child: Text(
                    'Create Enquiry',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
                textfieldy(
                  'Enquiry ID',
                  enquiryid
                ),
                textfieldy(
                  'Wings Enquiry Number',
                  wingsenquiry
                ),
                CustomDropdown(
                  title: 'Customer Category',
                  selectedCustomDropdown: selectedcustomercategoryitems,
                  customDropdownItems: customercategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcustomercategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Category',
                  selectedCustomDropdown: selectedenquirycategoryitems,
                  customDropdownItems: enquirycategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirycategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Category',
                  selectedCustomDropdown: selectedcustomertypeitems,
                  customDropdownItems: customertypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcustomertypeitems = newValue;
                    });
                  },
                ),
                textfieldy(
                  'Customer Contact Number',
                  customercontactnumber
                ),
                textfieldy(
                  'Customer Name',
                  customername
                ),
                CustomDropdown(
                  title: 'Gender',
                  selectedCustomDropdown: selectedgenderitems,
                  customDropdownItems: genderitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedgenderitems = newValue;
                    });
                  },
                ),
                Customdatefield(
                  title: 'Date of Birth',
                  datecontroller: datecontroller
                ),
                CustomDropdown(
                  title: 'Martial Status',
                  selectedCustomDropdown: selectedmartialstatusitems,
                  customDropdownItems: martialstatusitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmartialstatusitems = newValue;
                    });
                  },
                ),
                textfieldy(
                  "Email ID",
                  emailid
                ),
                textfieldy(
                  "Address",
                  address
                ),
                CustomDropdown(
                  title: 'Enquiry Type',
                  selectedCustomDropdown: selectedenquirytypeitems,
                  customDropdownItems: enquirytypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirytypeitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Source',
                  selectedCustomDropdown: selectedenquirysourceitems,
                  customDropdownItems: enquirysourceitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirysourceitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Category',
                  selectedCustomDropdown: selectedmodelcategoryitems,
                  customDropdownItems: modelcategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelcategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Name',
                  selectedCustomDropdown: selectedmodelnameitems,
                  customDropdownItems: modelnameitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelnameitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Variant',
                  selectedCustomDropdown: selectedmodelvariantitems,
                  customDropdownItems: modelvariantitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelvariantitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Color',
                  selectedCustomDropdown: selectedmodelcoloritems,
                  customDropdownItems: modelcoloritems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelcoloritems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Purchase Type',
                  selectedCustomDropdown: selectedpurchasetypeitems,
                  customDropdownItems: purchasetypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedpurchasetypeitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Exchange Flag',
                  selectedCustomDropdown: selectedexchangeflagitems,
                  customDropdownItems: exchangeflagitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedexchangeflagitems = newValue;
                    });
                  },
                ),
                Customdatefield(
                  title: 'Follow Up Date',
                  datecontroller: followupdatecontroller
                ),
                CustomDropdown(
                  title: 'Test Ride',
                  selectedCustomDropdown: selectedtestrideitems,
                  customDropdownItems: testrideitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedtestrideitems = newValue;
                    });
                  },
                ),
                description(
                  'Customer Remarks',
                  customerremarks
                ),
                SizedBox(height: SizeConfig.h(20)),
                button(
                  'Create Enquiry',
                  () {
                    apiconnection();
                  }
                ),
            
                SizedBox(height: SizeConfig.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
