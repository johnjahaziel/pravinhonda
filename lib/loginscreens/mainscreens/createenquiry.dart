import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/loginscreens/mainscreens/addexchange.dart';
import 'package:pravinhonda/loginscreens/mainscreens/addfinance.dart';
import 'package:pravinhonda/loginscreens/mainscreens/createquotation.dart';
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

  // List<Map<String, String>> modelcategoryitems = [
  //   {'label': 'BW', 'value': 'BW'},
  //   {'label': 'EV', 'value': 'EV'},
  //   {'label': 'MC', 'value': 'MC'},
  //   {'label': 'SC', 'value': 'SC'},
  // ];

  // String? selectedmodelcategoryitems;

  List<Map<String, String>> modelnameitems = [
    {'label': 'hondasp125', 'value': 'hondasp125'},
  ];

  String? selectedmodelnameitems;

  List<Map<String, String>> modelvariantitems = [
    {'label': 'Deluxe', 'value': 'Deluxe'},
  ];

  String? selectedmodelvariantitems;

  List<Map<String, String>> modelcoloritems = [
    {'label': 'mat marvel blue', 'value': 'mat marvel blue'},
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
// String modelcategorye = '';
  String modelnamee = '';
  String modelvariante = '';
  String modelcolore = '';
  String purchasetypee = '';
  String exchangeflage = '';

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'customer_id': customerid.text,
          'wings_enquiry_number': wingsenquiry.text,
          'customer_category': selectedcustomercategoryitems?.toString(),
          'enquiry_category': selectedenquirycategoryitems?.toString(),
          'customer_type': selectedcustomertypeitems?.toString(),
          'customer_contact_number': customercontactnumber.text,
          'customer_name': customername.text,
          'gender': selectedgenderitems?.toString(),
          'dob': datecontroller.text,
          'martial_status': selectedmartialstatusitems?.toString(),
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Createquotation(
              enquiryid: responseData['data']['enquiry']['enquiry_id'],
              apiResponse: responseData,
            )
          )
        );

        print(responseData['data']['enquiry']['enquiry_id']);

      } else if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (response.statusCode == 422) {
          setState(() {
            customeride = responseData['errors']['customer_id'] ?? '';
            wingsenquirye = responseData['errors']['wings_enquiry_number'] ?? '';
            customercategorye = responseData['errors']['customer_category'] ?? '';
            enquirycategorye = responseData['errors']['enquiry_category'] ?? '';
            customertypee = responseData['errors']['customer_type'] ?? '';
            customernamee = responseData['errors']['customer_name'] ?? '';
            customercontactnumbere = responseData['errors']['customer_contact_number'] ?? '';
            emailide = responseData['errors']['email_id'] ?? '';
            addresse = responseData['errors']['address'] ?? '';
            enquirytypee = responseData['errors']['enquiry_type'] ?? '';
            enquirysourcee = responseData['errors']['enquiry_source'] ?? '';
            // modelcategorye = responseData['errors']['model_category'] ?? '';
            modelnamee = responseData['errors']['model_name'] ?? '';
            modelvariante = responseData['errors']['model_variant'] ?? '';
            modelcolore = responseData['errors']['model_color'] ?? '';
            purchasetypee = responseData['errors']['purchase_type'] ?? '';
            exchangeflage = responseData['errors']['exchange_flag'] ?? '';
          });

          Fluttertoast.showToast(msg: responseData['message']);

          print('errrorrr $customeride');

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
                  star: false,
                ),
                
                Customdatefield(
                  title: 'Date of Birth',
                  datecontroller: datecontroller,
                  star: false,
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
                // CustomDropdown(
                //   title: 'Model Category',
                //   selectedCustomDropdown: selectedmodelcategoryitems,
                //   customDropdownItems: modelcategoryitems,
                //   onChanged: (newValue) {
                //     setState(() {
                //       selectedmodelcategoryitems = newValue;
                //     });
                //   },
                // ),
                // if(modelcategorye.isNotEmpty)
                // errormessage('$modelcategorye'),
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
                if(purchasetypee.isNotEmpty)
                errormessage(purchasetypee),
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
                Customdatefield(
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
