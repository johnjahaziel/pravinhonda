import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/loginscreens/forms/addexchange.dart';
import 'package:pravinhonda/loginscreens/forms/addfinance.dart';
import 'package:pravinhonda/loginscreens/forms/createquotation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetobooking extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetobooking({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Movetobooking> createState() => _MovetobookingState();
}

class _MovetobookingState extends State<Movetobooking> {

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
    {'label': 'Honda Dio', 'value': 'Honda Dio'},
  ];

  String? selectedmodelnameitems;

  List<Map<String, String>> modelvariantitems = [
    {'label': 'Standard', 'value': 'Standard'},
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

  late TextEditingController enquiryid;
  // late TextEditingController customerid;
  late TextEditingController wingsenquiry;
  late TextEditingController customercontactnumber;
  late TextEditingController customername;
  late TextEditingController datecontroller;
  late TextEditingController emailid;
  late TextEditingController address;
  late TextEditingController followupdatecontroller;
  late TextEditingController customerremarks;

  final TextEditingController bookingamount = TextEditingController();
  final TextEditingController bookingreceiptno = TextEditingController();
  final TextEditingController vehiclename = TextEditingController();
  final TextEditingController vehiclecolour = TextEditingController();
  final TextEditingController chassisno = TextEditingController();
  final TextEditingController engineno = TextEditingController();
  final TextEditingController keyno = TextEditingController();
  final TextEditingController batteryno = TextEditingController();
  final TextEditingController tyremake = TextEditingController();
  final TextEditingController rrtyreno = TextEditingController();
  final TextEditingController fttyreno = TextEditingController();
  final TextEditingController addapprovedname = TextEditingController();
  final TextEditingController allotedby = TextEditingController();

  String bookingamounte = '';
  String bookingreceiptnoe = '';
  String vehiclenamee = '';
  String vehiclecoloure = '';
  String chassisnoe = '';
  String enginenoe = '';
  String keynoe = '';
  String batterynoe = '';
  String tyremakee = '';
  String rrtyrenoe = '';
  String fttyrenoe = '';
  String addapprovednamee = '';
  String allotedbye = '';

  Map<String, dynamic> originalEnquiry = {};

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
    }
  }

  bool isEdited() {
    return
      // customerid.text != (originalEnquiry['customer_id'] ?? '') ||
      wingsenquiry.text != (originalEnquiry['wings_enquiry_number'] ?? '') ||
      selectedcustomercategoryitems != originalEnquiry['customer_category'] ||
      selectedenquirycategoryitems != originalEnquiry['enquiry_category'] ||
      selectedcustomertypeitems != originalEnquiry['customer_type'] ||
      selectedgenderitems != originalEnquiry['gender'] ||
      selectedmartialstatusitems != originalEnquiry['marital_status'] ||
      selectedenquirytypeitems != originalEnquiry['enquiry_type'] ||
      selectedenquirysourceitems != originalEnquiry['enquiry_source'] ||
      selectedmodelnameitems != originalEnquiry['model_name'] ||
      selectedmodelvariantitems != originalEnquiry['model_variant'] ||
      selectedmodelcoloritems != originalEnquiry['model_color'] ||
      selectedpurchasetypeitems != originalEnquiry['purchase_type'] ||
      selectedexchangeflagitems != originalEnquiry['exchange_flag'] ||
      selectedtestrideitems != originalEnquiry['test_ride'] ||
      customername.text != (originalEnquiry['customer_name'] ?? '') ||
      customercontactnumber.text != (originalEnquiry['customer_contact_number'] ?? '') ||
      emailid.text != (originalEnquiry['email_id'] ?? '') ||
      address.text != (originalEnquiry['address'] ?? '') ||
      datecontroller.text != (originalEnquiry['dob'] ?? '') ||
      followupdatecontroller.text != (originalEnquiry['follow_up_date'] ?? '') ||
      customerremarks.text != (originalEnquiry['customers_remarks'] ?? '');
  }

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

    enquiryid = TextEditingController(text: enquiry['enquiry_id']?.toString() ?? '');
    // customerid = TextEditingController(text: enquiry['customer_id']?.toString() ?? '');
    wingsenquiry = TextEditingController(text: enquiry['wings_enquiry_number'] ?? '');
    selectedcustomercategoryitems = enquiry['customer_category'];
    selectedenquirycategoryitems = enquiry['enquiry_category'];
    selectedcustomertypeitems = enquiry['customer_type'];
    selectedgenderitems = enquiry['gender'];
    selectedmartialstatusitems = enquiry['marital_status'];
    selectedenquirytypeitems = enquiry['enquiry_type'];
    selectedenquirysourceitems = enquiry['enquiry_source'];
    // selectedmodelcategoryitems = enquiry['model_category'];
    selectedmodelnameitems = enquiry['model_name'];
    selectedmodelvariantitems = enquiry['model_variant'];
    selectedmodelcoloritems = enquiry['model_color'];
    selectedpurchasetypeitems = enquiry['purchase_type'];
    selectedexchangeflagitems = enquiry['exchange_flag'];
    selectedtestrideitems = enquiry['test_ride'];
    customername = TextEditingController(text: enquiry['customer_name'] ?? enquiry['customer_name'] ?? '');
    customercontactnumber = TextEditingController(text: enquiry['customer_contact_number'] ?? enquiry['customer_contact_number'] ?? '');
    emailid = TextEditingController(text: enquiry['email_id'] ?? enquiry['email_id'] ?? '');
    address = TextEditingController(text: enquiry['address'] ?? enquiry['address'] ?? '');
    datecontroller = TextEditingController(text: enquiry['dob'] ?? enquiry['dob'] ?? '');
    followupdatecontroller = TextEditingController(text: enquiry['follow_up_date'] ?? '');
    customerremarks = TextEditingController(text: enquiry['customers_remarks'] ?? '');
  }

  // String customeride = '';
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
          // 'customer_id': customerid.text,
          'wings_enquiry_number': wingsenquiry.text,
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

      if (response.statusCode == 200) {
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
                enquiryid: widget.enquiryid,
                apiResponse: widget.apiResponse,
              )
            ),
          );
        } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addexchange(
                enquiryid: widget.enquiryid,
                apiResponse: widget.apiResponse,
              )
            )
          );
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => QuotationSuccessPopup(
            name: '${responseData['data']['enquiry']['customer_name']}',
            number: '${responseData['data']['enquiry']['customer_contact_number']}',
            enquiryid: responseData['data']['enquiry']['enquiry_id'],
          ),
        );

      } else if (response.statusCode == 422) {
          setState(() {
            // customeride = responseData['errors']['customer_id'] ?? '';
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

  Future<void> movetobooking() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}/move-to-booking');

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
          'booking_amount': bookingamount.text.toString(),
          'booking_receipt_no': bookingreceiptno.text.toString(),
          'vehicle_name': vehiclename.text.toString(),
          'vehicle_colour': vehiclecolour.text.toString(),
          'chassis_no': chassisno.text.toString(),
          'engine_no': engineno.text.toString(),
          'key_no': keyno.text.toString(),
          'battery_no': batteryno.text.toString(),
          'tyre_make': tyremake.text.toString(),
          'RR_tyre_no': rrtyreno.text.toString(),
          'FT_tyre_no': fttyreno.text.toString(),
          'add_approved_name': addapprovedname.text.toString(),
          'alloted_by': allotedby.text.toString(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('response data: $responseData');

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation(initialIndex: 1),
          ),
        );

      } else if (response.statusCode == 200) {

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        
      } else if (response.statusCode == 422) {
        // final errors = responseData['errors'] ?? {};

        // setState(() {
        //   bookingamounte = errors['errors']['booking_amount'] ?? '';
        //   bookingreceiptnoe = errors['errors']['booking_receipt_no'] ?? '';
        //   vehiclenamee = errors['errors']['vehicle_name'] ?? '';
        //   vehiclecoloure = errors['errors']['vehicle_colour'] ?? '';
        //   chassisnoe = errors['errors']['chassis_no'] ?? '';
        //   enginenoe = errors['errors']['engine_no'] ?? '';
        //   keynoe = errors['errors']['key_no'] ?? '';
        //   batterynoe = errors['errors']['battery_no'] ?? '';
        //   tyremakee = errors['errors']['tyre_make'] ?? '';
        //   rrtyrenoe = errors['errors']['rr_tyre_no'] ?? '';
        //   fttyrenoe = errors['errors']['ft_tyre_no'] ?? '';
        // });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Status code: ${response.statusCode}');
        print(response.body);
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to move to booking. Status code: ${response.statusCode}');
        print(response.body);
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
                        isEdited() ? 'Update Quotation' : 'Move to Booking',
                        style: customtext(
                          fs18,
                          kred,
                          FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(10)),
                    textfieldy(
                      'Enquiry Number',
                      enquiryid,
                      readonly: true,
                    ),
                    // textfieldy(
                    //   'Customer ID',
                    //   customerid,
                    //   readonly: edit(),
                    // ),
                    // if(customeride.isNotEmpty)
                    // errormessage(customeride),
                    textfieldy(
                      'Wings Enquiry Number',
                      wingsenquiry,
                      readonly: false,
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
                    // CustomDropdown(
                    //   title: 'Model Category',
                    //   selectedCustomDropdown: selectedmodelcategoryitems,
                    //   customDropdownItems: modelcategoryitems,
                    //   onChanged: (newValue) {
                    //     setState(() {
                    //       selectedmodelcategoryitems = newValue;
                    //     });
                    //   },
                    //   readOnly: edit(),
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
                      readOnly: edit(),
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
                      readOnly: edit(),
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
                      readOnly: edit(),
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
                    if(isEdited() == false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textfieldy(
                          'Booking Amount',
                          bookingamount,
                        ),
                        if(bookingamounte.isNotEmpty)
                        errormessage(bookingamounte),
                        textfieldy(
                          'Booking Receipt No',
                          bookingreceiptno,
                        ),
                        if(bookingreceiptnoe.isNotEmpty)
                        errormessage(bookingreceiptnoe),
                        textfieldy(
                          'Vehicle Name',
                          vehiclename,
                        ),
                        if(vehiclenamee.isNotEmpty)
                        errormessage(vehiclenamee),
                        textfieldy(
                          'Vehicle Colour',
                          vehiclecolour,
                        ),
                        if(vehiclecoloure.isNotEmpty)
                        errormessage(vehiclecoloure),
                        textfieldy(
                          'Chassis No',
                          chassisno,
                        ),
                        if(chassisnoe.isNotEmpty)
                        errormessage(chassisnoe),
                        textfieldy(
                          'Engine No',
                          engineno,
                        ),
                        if(enginenoe.isNotEmpty)
                        errormessage(enginenoe),
                        textfieldy(
                          'Key No',
                          keyno,
                        ),
                        if(keynoe.isNotEmpty)
                        errormessage(keynoe),
                        textfieldy(
                          'Battery No',
                          batteryno,
                        ),
                        if(batterynoe.isNotEmpty)
                        errormessage(batterynoe),
                        textfieldy(
                          'Tyre Make',
                          tyremake,
                        ),
                        if(tyremakee.isNotEmpty)
                        errormessage(tyremakee),
                        textfieldy(
                          'RR Tyre No',
                          rrtyreno,
                        ),
                        if(rrtyrenoe.isNotEmpty)
                        errormessage(rrtyrenoe),
                        textfieldy(
                          'FT Tyre No',
                          fttyreno,
                        ),
                        if(fttyrenoe.isNotEmpty)
                        errormessage(fttyrenoe),
                        textfieldy(
                          'Add Approved Name',
                          addapprovedname,
                        ),
                        if(addapprovednamee.isNotEmpty)
                        errormessage(addapprovednamee),
                        textfieldy(
                          'Alloted By',
                          allotedby,
                        ),
                        if(allotedbye.isNotEmpty)
                        errormessage(allotedbye),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(20)),
                    button(
                      isEdited() ? 'Update Quotation' : 'Move to Booking',
                      () {
                        isEdited() ? apiconnection() : movetobooking();
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