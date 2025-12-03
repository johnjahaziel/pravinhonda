import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/forms/addexchange.dart';
import 'package:pravinhonda/loginscreens/forms/addfinance.dart';
import 'package:pravinhonda/loginscreens/forms/createquotation.dart';
import 'package:pravinhonda/namevariantcolor.dart';
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

  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController followupdatecontroller = TextEditingController();
  TextEditingController customerremarks = TextEditingController();

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
  String modelnamee = '';
  String modelvariante = '';
  String modelcolore = '';
  String purchasetypee = '';
  String exchangeflage = '';

  String? selectedmodelnameitems;
  String? selectedmodelvariantitems;
  String? selectedmodelcoloritems;

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    final token = BlocProvider.of<AuthCubit>(context).state.token;
    print('Token: $token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'high_rise_number': wingsenquiry.text,
          'customer_category': selectedcustomercategoryitems?.toString(),
          'enquiry_category': selectedenquirycategoryitems?.toString(),
          'customer_type': selectedcustomertypeitems?.toString(),
          'customer_contact_number': customercontactnumber.text,
          'customer_name': customername.text,
          'gender': selectedgenderitems?.toString(),
          'dob': datecontroller.text,
          'marital_status': selectedmartialstatusitems?.toString(),
          'email_id': emailid.text,
          'address': address.text,
          'enquiry_type': selectedenquirytypeitems?.toString(),
          'enquiry_source': selectedenquirysourceitems?.toString(),
          'model_name': selectedmodelnameitems?.toString(),
          'model_variant': selectedmodelvariantitems?.toString(),
          'model_color': selectedmodelcoloritems?.toString(),
          'purchase_type': selectedpurchasetypeitems?.toString(),
          'exchange_flag': selectedexchangeflagitems?.toString(),
          'follow_up_date': followupdatecontroller.text,
          'test_ride': selectedtestrideitems?.toString(),
          'customer_remarks': customerremarks.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('response data: $responseData');

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
                enquiryid: responseData['data']['enquiry']['enquiry_id'],
                apiResponse: responseData,
              )
            ),
          );
        } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addexchange(
                enquiryid: responseData['data']['enquiry']['enquiry_id'],
                apiResponse: responseData,
              )
            )
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Createquotation(
                enquiryid: responseData['data']['enquiry']['enquiry_id'],
                apiResponse: responseData,
              )
            )
          );
        }

        print(responseData['data']['enquiry']['enquiry_id']);

      } else if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          wingsenquirye = errors['wings_enquiry_number']?.toString() ?? '';
          customercategorye = errors['customer_category']?.toString() ?? '';
          enquirycategorye = errors['enquiry_category']?.toString() ?? '';
          customertypee = errors['customer_type']?.toString() ?? '';
          customernamee = errors['customer_name']?.toString() ?? '';
          customercontactnumbere = errors['customer_contact_number']?.toString() ?? '';
          emailide = errors['email_id']?.toString() ?? '';
          addresse = errors['address']?.toString() ?? '';
          enquirytypee = errors['enquiry_type']?.toString() ?? '';
          enquirysourcee = errors['enquiry_source']?.toString() ?? '';
          modelnamee = errors['model_name']?.toString() ?? '';
          modelvariante = errors['model_variant']?.toString() ?? '';
          modelcolore = errors['model_color']?.toString() ?? '';
          purchasetypee = errors['purchase_type']?.toString() ?? '';
          exchangeflage = errors['exchange_flag']?.toString() ?? '';
        });

        Fluttertoast.showToast(msg: responseData['message'] ?? "Validation error");
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to create enquiry. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error submitting finance form: $error');
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
                  'Wings Enquiry Number',
                  wingsenquiry,
                  star: false
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
                  star: false,
                ),
                
                Dateofbirthfield(
                  title: 'Date of Birth',
                  datecontroller: datecontroller,
                  star: false
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
                  star: false,
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
                Namevariantcolor(
                  selectedname: selectedmodelnameitems,
                  selectedvariant: selectedmodelvariantitems,
                  selectedcolor: selectedmodelcoloritems,
                  onNameChanged: (value) {
                    setState(() {
                      selectedmodelnameitems = value;
                      selectedmodelvariantitems = null;
                      selectedmodelcoloritems = null;
                    });
                  },
                  onVariantChanged: (value) {
                    setState(() {
                      selectedmodelvariantitems = value;
                      selectedmodelcoloritems = null;
                    });
                  },
                  onColorChanged: (value) {
                    setState(() {
                      selectedmodelcoloritems = value;
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
                if(exchangeflage.isNotEmpty)
                errormessage(exchangeflage),
                Followupdate(
                  title: 'Follow Up Date',
                  datecontroller: followupdatecontroller,
                  star: false,
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
                  star: false,
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
