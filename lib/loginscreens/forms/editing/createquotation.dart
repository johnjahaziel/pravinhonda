import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Createquotation extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Createquotation({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Createquotation> createState() => _CreatequotationState();
}

class _CreatequotationState extends State<Createquotation> {

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
    {'label': 'Male', 'value': 'Male'},
    {'label': 'Female', 'value': 'Female'},
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

  String? selectedmodelnameitems;
  String? selectedmodelvariantitems;
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

  List<Map<String, String>> districtitems = [
    {'label': 'Thoothukkudi', 'value': 'Thoothukkudi'},
  ];

  String? selecteddistrictitems;

  List<Map<String, String>> cityitems = [
    {'label': 'Kovilpatti', 'value': 'Kovilpatti'},
  ];

  String? selectedcityitems;

  late TextEditingController wingsenquiry;
  late TextEditingController customercontactnumber;
  late TextEditingController secondarycontactnumber;
  late TextEditingController pincode;
  late TextEditingController customername;
  late TextEditingController datecontroller;
  late TextEditingController emailid;
  late TextEditingController address;
  late TextEditingController followupdatecontroller;
  late TextEditingController customerremarks;

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp['data'] ?? {};

    wingsenquiry = TextEditingController(text: enquiry['wings_enquiry_number'] ?? '');
    selectedcustomercategoryitems = enquiry['customer_category'];
    selectedenquirycategoryitems = enquiry['enquiry_category'];
    selectedcustomertypeitems = enquiry['customer_type'];
    selectedgenderitems = enquiry['gender'];
    selectedmartialstatusitems = enquiry['martial_status'];
    selecteddistrictitems = enquiry['district'];
    selectedcityitems = enquiry['city'];
    selectedenquirytypeitems = enquiry['enquiry_type'];
    selectedenquirysourceitems = enquiry['enquiry_source'];
    selectedmodelnameitems = enquiry['model_name'];
    selectedmodelvariantitems = enquiry['model_variant'];
    selectedmodelcoloritems = enquiry['model_color'];
    selectedpurchasetypeitems = enquiry['purchase_type'];
    selectedexchangeflagitems = enquiry['exchange_flag'];
    selectedtestrideitems = enquiry['test_ride'];
    customername = TextEditingController(text: enquiry['customer_name'] ?? '');
    customercontactnumber = TextEditingController(text: enquiry['customer_contact_number'] ?? '');
    secondarycontactnumber = TextEditingController(text: enquiry['secondary_contact_number'] ?? '');
    emailid = TextEditingController(text: enquiry['email_id'] ?? '');
    address = TextEditingController(text: enquiry['address'] ?? '');
    pincode = TextEditingController(text: enquiry['pincode'].toString());
    datecontroller = TextEditingController(text: enquiry['dob'] ?? '');
    followupdatecontroller = TextEditingController(text: enquiry['follow_up_date'] ?? '');
    customerremarks = TextEditingController(text: enquiry['customers_remarks'] ?? '');
  }

  String wingsenquirye = '';
  String customercategorye = '';
  String enquirycategorye = '';
  String customertypee = '';
  String customernamee = '';
  String customercontactnumbere = '';
  String secondarycontactnumbere = '';
  String pincodee = '';
  String emailide = '';
  String gendere = '';
  String addresse = '';
  String districte = '';
  String citye = '';
  String enquirytypee = '';
  String enquirysourcee = '';
  String modelnamee = '';
  String modelvariante = '';
  String modelcolore = '';
  String purchasetypee = '';
  String exchangeflage = '';
  String customerremarkse = '';

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

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
          'secondary_contact_number': secondarycontactnumber.text,
          'pincode': pincode.text,
          'customer_name': customername.text,
          'gender': selectedgenderitems?.toString(),
          'dob': datecontroller.text,
          'marital_status': selectedmartialstatusitems?.toString(),
          'email_id': emailid.text,
          'address': address.text,
          'district' : selecteddistrictitems?.toString(),
          'city' : selectedcityitems?.toString(),
          'enquiry_type': selectedenquirytypeitems?.toString(),
          'enquiry_source': selectedenquirysourceitems?.toString(),
          'model_name': selectedmodelnameitems?.toString(),
          'model_variant': selectedmodelvariantitems?.toString(),
          'model_color': selectedmodelcoloritems?.toString(),
          'purchase_type': selectedpurchasetypeitems?.toString(),
          'exchange_flag': selectedexchangeflagitems?.toString(),
          'follow_up_date': followupdatecontroller.text,
          'test_ride': selectedtestrideitems?.toString(),
          'customers_remarks': customerremarks.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => QuotationSuccessPopup(
            name: '${responseData['data']['customer_name']}',
            number: '${responseData['data']['customer_contact_number']}',
            enquiryid: responseData['data']['enquiry_id'],
          ),
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
          secondarycontactnumbere = errors['secondary_contact_number']?.toString() ?? '';
          pincodee = errors['pincode']?.toString() ?? '';
          gendere = errors['gender']?.toString() ?? '';
          emailide = errors['email_id']?.toString() ?? '';
          addresse = errors['address']?.toString() ?? '';
          enquirytypee = errors['enquiry_type']?.toString() ?? '';
          enquirysourcee = errors['enquiry_source']?.toString() ?? '';
          modelnamee = errors['model_name']?.toString() ?? '';
          modelvariante = errors['model_variant']?.toString() ?? '';
          modelcolore = errors['model_color']?.toString() ?? '';
          districte = errors['district']?.toString() ?? '';
          citye = errors['city']?.toString() ?? '';
          purchasetypee = errors['purchase_type']?.toString() ?? '';
          exchangeflage = errors['exchange_flag']?.toString() ?? '';
          customerremarkse = errors['customers_remarks']?.toString() ?? '';
        });

        Fluttertoast.showToast(msg: responseData['message']);
        print(response.body);

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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.h(20)),
                    Center(
                      child: Text(
                        'Quotation',
                        style: customtext(
                          fs18,
                          kred,
                          FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(10)),
                    textfieldy(
                      'High Rise Number',
                      wingsenquiry,
                      readonly: edit(),
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
                      readOnly: edit(),
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
                      readOnly: edit(),
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
                      readOnly: edit(),
                    ),
                    if(customertypee.isNotEmpty)
                    errormessage(customertypee),
                    textfieldy(
                      'Customer Contact Number',
                      customercontactnumber,
                      readonly: edit(),
                    ),
                    if(customercontactnumbere.isNotEmpty)
                    errormessage(customercontactnumbere),
                    textfieldy(
                      'Secondary Contact Number',
                      secondarycontactnumber,
                      readonly: edit(),
                    ),
                    if(secondarycontactnumbere.isNotEmpty)
                    errormessage(secondarycontactnumbere),
                    textfieldy(
                      'Customer Name',
                      customername,
                      readonly: edit(),
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
                      readOnly: edit(),
                    ),
                    if(gendere.isNotEmpty)
                    errormessage(gendere),
                    Dateofbirthfield(
                      title: 'Date of Birth',
                      datecontroller: datecontroller,
                      star: false,
                      readOnly: edit(),
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
                      readOnly: edit(),
                    ),
                    
                    textfieldy(
                      "Email ID",
                      emailid,
                      readonly: edit(),
                    ),
                    if(emailide.isNotEmpty)
                    errormessage(emailide),
                    textfieldy(
                      "Address",
                      address,
                      readonly: edit(),
                    ),
                    if(addresse.isNotEmpty)
                    errormessage(addresse),
                    CustomDropdown(
                      title: 'District',
                      selectedCustomDropdown: selecteddistrictitems,
                      customDropdownItems:districtitems,
                      onChanged: (newValue) {
                        setState(() {
                          selecteddistrictitems = newValue;
                        });
                      },
                      readOnly: edit(),
                    ),
                    if(districte.isNotEmpty)
                    errormessage(districte),
                    CustomDropdown(
                      title: 'City',
                      selectedCustomDropdown: selectedcityitems,
                      customDropdownItems: cityitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedcityitems = newValue;
                        });
                      },
                      readOnly: edit(),
                    ),
                    if(citye.isNotEmpty)
                    errormessage(citye),
                    textfieldy(
                      'Pincode',
                      pincode,
                      readonly: edit(),
                    ),
                    if(pincodee.isNotEmpty)
                    errormessage(pincodee),
                    CustomDropdown(
                      title: 'Enquiry Type',
                      selectedCustomDropdown: selectedenquirytypeitems,
                      customDropdownItems: enquirytypeitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedenquirytypeitems = newValue;
                        });
                      },
                      readOnly: edit(),
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
                      readOnly: edit(),
                    ),
                    if(enquirysourcee.isNotEmpty)
                    errormessage(enquirysourcee),
                    Namevariantcolor(
                      modelnamee: modelnamee,
                      modelvariante: modelvariante,
                      modelcolore: modelcolore,
                      
                      selectedname: selectedmodelnameitems,
                      selectedvariant: selectedmodelvariantitems,
                      selectedcolor: selectedmodelcoloritems,
                      onNameChanged: (value) {
                        setState(() {
                          selectedmodelnameitems = value;
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
                      edit: edit(),
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
                      readOnly: edit(),
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
                      readOnly: edit(),
                    ),
                    if(exchangeflage.isNotEmpty)
                    errormessage(exchangeflage),
                    Followupdate(
                      title: 'Follow Up Date',
                      datecontroller: followupdatecontroller,
                      star: false,
                      readOnly: edit(),
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
                      readOnly: edit(),
                    ),
                    description(
                      'Customer Remarks',
                      customerremarks,
                      readonly: edit()
                    ),
                    SizedBox(height: SizeConfig.h(20)),
                    button(
                      'Confirm Quotation',
                      () {
                        apiconnection();
                      }
                    ),
                    SizedBox(height: SizeConfig.h(40)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    onEditpressed = !onEditpressed;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: onEditpressed ? kwhite : klightgrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 2,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(12),
                    vertical: SizeConfig.h(2)
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: kblack,
                    ),
                    SizedBox(width: SizeConfig.w(3)),
                    Text(
                      'Edit',
                      style: textmedium12,
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuotationSuccessPopup extends StatefulWidget {
  final String name;
  final String number;
  final int enquiryid;

  const QuotationSuccessPopup({
    super.key,
    required this.name,
    required this.number,
    required this.enquiryid,
  });

  @override
  State<QuotationSuccessPopup> createState() => _QuotationSuccessPopupState();
}

class _QuotationSuccessPopupState extends State<QuotationSuccessPopup> {

  Future<void> openUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);

    try {
      final bool ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (ok) {
        print('Launched externally: $uri');
        return;
      } else {
        print('launchUrl (external) returned false for $uri');
      }
    } catch (e) {
      print('launchUrl external exception: $e');
    }

    Fluttertoast.showToast(msg: 'Could not open URL');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open: ${uri.toString()}')),
    );
  }

  Future<void> generatepdf() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/pdf/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        openUrl(context, responseData['file']);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
          ((route) => false)
        );

        print(responseData['file']);

      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to generate PDF. Status code: ${response.statusCode}');
        print(response.body);
      }

    } catch (error) {
      print('Error generating PDF: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tightFor(
        width: double.infinity
      ),
      backgroundColor: kwhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(5),left: SizeConfig.w(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : ${widget.name}",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : ${widget.number}",
                      style: textmedium12,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(20)),
          LottieBuilder(
            height: SizeConfig.h(120),
            width: SizeConfig.w(120),
            lottie: AssetLottie(
              'lottie/completed.json',
            ),
            repeat: false,
          ),
          SizedBox(height: SizeConfig.h(2)),
          Text(
            "Thanks For Creating The Quotation!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Please Download It And\nGive A Hard Copy To The Customer.",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Thank You!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(30)),
          button(
            'Print',
            () {
              generatepdf();
            },
            padding: true
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}

