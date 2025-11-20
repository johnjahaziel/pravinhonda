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
    {'label': 'CSD', 'value': 'CSD'},
    {'label': 'KPKB', 'value': 'KPKB'},
    {'label': 'Corporate', 'value': 'Corporate'},
  ];

  String? selectedcustomercategoryitems;

  List<Map<String, String>> enquirycategoryitems = [
    {'label': 'Individual', 'value': 'Individual'},
    {'label': 'Institutional Customer', 'value': 'Institutional Customer'},
    {'label': 'Exchange with ELV', 'value': 'Exchange with ELV'},
  ];

  String? selectedenquirycategoryitems;

  List<Map<String, String>> customertypeitems = [
    {'label': 'First Time Buyer', 'value': 'First Time Buyer'},
    {'label': 'Additional Buyer', 'value': 'Additional Buyer'},
    {'label': 'Replacement Buyer', 'value': 'Replacement Buyer'},
  ];

  String? selectedcustomertypeitems;

  List<Map<String, String>> genderitems = [
    {'label': 'Male', 'value': 'male'},
    {'label': 'Female', 'value': 'female'},
  ];

  String? selectedgenderitems;

  List<Map<String, String>> martialstatusitems = [
    {'label': 'Married', 'value': 'married'},
    {'label': 'Single', 'value': 'single'},
  ];

  String? selectedmartialstatusitems;

  List<Map<String, String>> enquirytypeitems = [
    {'label': 'Digital', 'value': 'Digital'},
    {'label': 'Walk-In', 'value': 'Walk-In'},
    {'label': 'Telephonic', 'value': 'Telephonic'},
    {'label': 'Outdoor Activity', 'value': 'Outdoor Activity'},
  ];

  String? selectedenquirytypeitems;

  List<Map<String, String>> enquirysourceitems = [
    {'label': 'Showroom Walk In', 'value': 'Showroom Walk In'},
    {'label': 'Railway', 'value': 'Railway'},
    {'label': 'Auto-Expo 2025', 'value': 'Auto-Expo 2025'},
    {'label': 'NEWS', 'value': 'NEWS'},
    {'label': 'Online Booking', 'value': 'Online Booking'},
    {'label': 'TV', 'value': 'TV'},
    {'label': 'Facebook', 'value': 'Facebook'},
  ];

  String? selectedenquirysourceitems;

  List<Map<String, String>> modelcategoryitems = [
    {'label': 'BW', 'value': 'BW'},
  ];

  String? selectedmodelcategoryitems;

  List<Map<String, String>> modelnameitems = [
    {'label': 'honda shine', 'value': 'honda shine'},
  ];

  String? selectedmodelnameitems;

  List<Map<String, String>> modelvariantitems = [
    {'label': 'sp120', 'value': 'sp120'},
  ];

  String? selectedmodelvariantitems;

  List<Map<String, String>> modelcoloritems = [
    {'label': 'Imperial Red Metallic', 'value': 'Imperial Red Metallic'},
  ];

  String? selectedmodelcoloritems;

  List<Map<String, String>> purchasetypeitems = [
    {'label': 'Cash', 'value': 'cash'},
    {'label': 'Finance', 'value': 'finance'},
  ];

  String? selectedpurchasetypeitems;

  List<Map<String, String>> exchangeflagitems = [
    {'label': 'Yes', 'value': 'yes'},
    {'label': 'No', 'value': 'no'},
  ];

  String? selectedexchangeflagitems;

  List<Map<String, String>> testrideitems = [
    {'label': 'Yes', 'value': 'yes'},
    {'label': 'No', 'value': 'no'},
  ];

  String? selectedtestrideitems;

  TextEditingController customerid = TextEditingController();
  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController followupdatecontroller = TextEditingController();
  TextEditingController customerremarks = TextEditingController();

  String customeride = '';
  String wingsenquirye = '';
  String customercategorye = '';
  String enquirycategorye = '';
  String customertypee = '';
  String customernamee = '';
  String customercontactnumbere = '';
  String emailide = '';
  String addresse = '';
  String enquirytypee = '';
  String enquirysourcee = '';
  String modelcategorye = '';
  String modelnamee = '';
  String modelvariante = '';
  String modelcolore = '';

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customer_id': customerid.text,
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

        if(selectedpurchasetypeitems == 'finance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addfinance(
                exchangeflag: selectedexchangeflagitems,
              )
            ),
          );
        } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addexchange()
            )
          );
        }

      } else if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (response.statusCode == 422) {

          final Map<String, dynamic> errormessage = responseData['errors'];

          setState(() {
            customeride = errormessage['customer_id'] ?? '';
            wingsenquirye = errormessage['wings_enquiry_number'] ?? '';
            customercategorye = errormessage['customer_category'] ?? '';
            enquirycategorye = errormessage['enquiry_category'] ?? '';
            customertypee = errormessage['customer_type'] ?? '';
            customernamee = errormessage['customer_name'] ?? '';
            customercontactnumbere = errormessage['customer_contact_number'] ?? '';
            emailide = errormessage['email_id'] ?? '';
            addresse = errormessage['address'] ?? '';
            enquirytypee = errormessage['enquiry_type'] ?? '';
            enquirysourcee = errormessage['enquiry_source'] ?? '';
            modelcategorye = errormessage['model_category'] ?? '';
            modelnamee = errormessage['model_name'] ?? '';
            modelvariante = errormessage['model_variant'] ?? '';
            modelcolore = errormessage['model_color'] ?? '';
          });

          print(customeride);

      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to create enquiry. Status code: ${response.statusCode}');
        print(response.body);
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Customer ID',
                  customerid
                ),
                if(customeride.isNotEmpty)
                errormessage(customeride),
                textfieldy(
                  'Wings Enquiry Number',
                  wingsenquiry
                ),
                if(wingsenquirye.isNotEmpty)
                errormessage(wingsenquirye),
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
                if(customercategorye.isNotEmpty)
                errormessage(customercategorye),
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
                if(enquirycategorye.isNotEmpty)
                errormessage(enquirycategorye),
                CustomDropdown(
                  title: 'Customer Type',
                  selectedCustomDropdown: selectedcustomertypeitems,
                  customDropdownItems: customertypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcustomertypeitems = newValue;
                    });
                  },
                ),
                if(customertypee.isNotEmpty)
                errormessage(customertypee),
                textfieldy(
                  'Customer Contact Number',
                  customercontactnumber
                ),
                if(customercontactnumbere.isNotEmpty)
                errormessage(customercontactnumbere),
                textfieldy(
                  'Customer Name',
                  customername
                ),
                if(customernamee.isNotEmpty)
                errormessage(customernamee),
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
                if(emailide.isNotEmpty)
                errormessage(emailide),
                textfieldy(
                  "Address",
                  address
                ),
                if(addresse.isNotEmpty)
                errormessage(addresse),
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
                if(enquirytypee.isNotEmpty)
                errormessage(enquirytypee),
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
                if(enquirysourcee.isNotEmpty)
                errormessage(enquirysourcee),
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
                if(modelcategorye.isNotEmpty)
                errormessage(modelcategorye),
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
                if(modelnamee.isNotEmpty)
                errormessage(modelnamee),
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
                if(modelvariante.isNotEmpty)
                errormessage(modelvariante),
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
                if(modelcolore.isNotEmpty)
                errormessage(modelcolore),
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
