import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/districtcity.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class EditenquiryMB extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  final bool edit;

  final VoidCallback financeselected;
  final VoidCallback exchangeselected;
  const EditenquiryMB({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
    required this.financeselected,
    required this.exchangeselected,
    required this.edit
  });

  @override
  State<EditenquiryMB> createState() => _EditenquiryMBState();
}

class _EditenquiryMBState extends State<EditenquiryMB> {

  final customercategoryitems = customerCategoryItems;
  final enquirycategoryitems = enquirycategoryTypeItems;
  final customertypeitems = customerTypeItems;
  final genderitems = genderTypeItems;
  final martialstatusitems = martialstatusTypeItems;
  final enquirytypeitems = enquiryTypeItems;
  final enquirysourceitems = enquirysourceTypeItems;
  final purchasetypeitems = purchaseTypeItems;
  final exchangeflagitems = exchangeflagTypeItems;
  final testrideitems = testrideTypeItems;

  String? selectedcustomercategoryitems;
  String? selectedenquirycategoryitems;
  String? selectedcustomertypeitems;
  String? selectedgenderitems;
  String? selectedmartialstatusitems;
  String? selectedenquirytypeitems;
  String? selectedenquirysourceitems;
  String? selectedpurchasetypeitems;
  String? selectedexchangeflagitems;
  String? selectedtestrideitems;

  String? selectedmodelnameitems;
  String? selectedmodelvariantitems;
  String? selectedmodelcoloritems;

  String? selecteddistrictitems;
  String? selectedcityitems;

  late TextEditingController enquiryid;
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
    print('apiresponse: ${widget.apiResponse}');
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

    enquiryid = TextEditingController(text: enquiry['enquiry_id']?.toString() ?? '');
    wingsenquiry = TextEditingController(text: enquiry['high_rise_number'] ?? '');
    selectedcustomercategoryitems = enquiry['customer_category'];
    selectedenquirycategoryitems = enquiry['enquiry_category'];
    selectedcustomertypeitems = enquiry['customer_type'];
    selectedgenderitems = enquiry['gender'];
    selectedmartialstatusitems = enquiry['marital_status'];
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

  String nextpagelocal = '';

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
  final TextEditingController deliverydate = TextEditingController();
  final TextEditingController deliverytime = TextEditingController();

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
  String deliverydatee = '';
  String deliverytimee = '';

  Map<String, dynamic> originalEnquiry = {};

  bool isEdited() {
    return
      wingsenquiry.text != (originalEnquiry['high_rise_number'] ?? '') ||
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
      selecteddistrictitems != originalEnquiry['district'] ||
      selectedcityitems != originalEnquiry['city'] ||
      selectedpurchasetypeitems != originalEnquiry['purchase_type'] ||
      selectedexchangeflagitems != originalEnquiry['exchange_flag'] ||
      selectedtestrideitems != originalEnquiry['test_ride'] ||
      customername.text != (originalEnquiry['customer_name'] ?? '') ||
      customercontactnumber.text != (originalEnquiry['customer_contact_number'] ?? '') ||
      secondarycontactnumber.text != (originalEnquiry['secondary_contact_number'] ?? '') ||
      pincode.text != (originalEnquiry['pincode']?.toString() ?? '') ||
      emailid.text != (originalEnquiry['email_id'] ?? '') ||
      address.text != (originalEnquiry['address'] ?? '') ||
      datecontroller.text != (originalEnquiry['dob'] ?? '') ||
      followupdatecontroller.text != (originalEnquiry['follow_up_date'] ?? '') ||
      customerremarks.text != (originalEnquiry['customers_remarks'] ?? '');
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

        final apiresponse = responseData;
        BlocProvider.of<ApiresponseCubit>(context).setApiresponse(apiresponse);

        if (selectedpurchasetypeitems == 'finance' && responseData['data']['purchase_type'] != selectedpurchasetypeitems) {
          nextpagelocal = 'Finance Form';
        } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes'
              && responseData['data']['exchange_flag'] != selectedexchangeflagitems
        ) {
          nextpagelocal = 'Exchange Form';
        } else {
          nextpagelocal = 'Print';
        }

        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
            if(selectedpurchasetypeitems == 'finance' && responseData['data']['purchase_type'] != selectedpurchasetypeitems) {
              widget.financeselected();
            } else if (
              selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes'
              && responseData['data']['exchange_flag'] != selectedexchangeflagitems
            ) {
              widget.exchangeselected();
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => QuotationSuccessPopup(
                  name: '${responseData['data']['customer_name']}',
                  number: '${responseData['data']['customer_contact_number']}',
                  enquiryid: responseData['data']['enquiry_id'],
                ),
              );
            }
          },
          nextpage: nextpagelocal
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          wingsenquirye = errors['high_rise_number']?.toString() ?? '';
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
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          }
        );
        print('Failed to create enquiry. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error submitting finance form: $error');
    }
  }

  Future<void> movetobooking() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/${widget.enquiryid}/move-to-booking/full');

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
          'delivery_date' : deliverydate.text.toString(),
          'delivery_time' : deliverytime.text.toString()
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Navigation(initialIndex: 1),
              ),
            );
          }
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          bookingamounte = errors['errors']['booking_amount'] ?? '';
          bookingreceiptnoe = errors['errors']['booking_receipt_no'] ?? '';
          vehiclenamee = errors['errors']['vehicle_name'] ?? '';
          vehiclecoloure = errors['errors']['vehicle_colour'] ?? '';
          chassisnoe = errors['errors']['chassis_no'] ?? '';
          enginenoe = errors['errors']['engine_no'] ?? '';
          keynoe = errors['errors']['key_no'] ?? '';
          batterynoe = errors['errors']['battery_no'] ?? '';
          tyremakee = errors['errors']['tyre_make'] ?? '';
          rrtyrenoe = errors['errors']['RR_tyre_no'] ?? '';
          fttyrenoe = errors['errors']['FT_tyre_no'] ?? '';
          addapprovednamee = errors['errors']['add_approved_name'] ?? '';
          allotedbye = errors['errors']['alloted_by'] ?? '';
          deliverydatee = errors['errors']['delivery_date'] ?? '';
          deliverytimee = errors['errors']['delivery_time'] ?? '';
        });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Status code: ${response.statusCode}');
        print(response.body);
      } else {
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          }
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
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: SizeConfig.h(5)),
              textfieldy(
                'Enquiry Number',
                enquiryid,
                readonly: true,
              ),
              textfieldy(
                'High Rise Number',
                wingsenquiry,
                readonly: widget.edit,
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
                readOnly: widget.edit,
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
                readOnly: widget.edit,
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
                readOnly: widget.edit,
              ),
              if(customertypee.isNotEmpty)
              errormessage(customertypee),
              textfieldy(
                'Customer Contact Number',
                customercontactnumber,
                readonly: widget.edit,
              ),
              if(customercontactnumbere.isNotEmpty)
              errormessage(customercontactnumbere),
              textfieldy(
                'Secondary Contact Number',
                secondarycontactnumber,
                readonly: widget.edit,
              ),
              if(secondarycontactnumbere.isNotEmpty)
              errormessage(secondarycontactnumbere),
              textfieldy(
                'Customer Name',
                customername,
                readonly: widget.edit,
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
                readOnly: widget.edit,
              ),
              if(gendere.isNotEmpty)
              errormessage(gendere),
              Dateofbirthfield(
                title: 'Date of Birth',
                datecontroller: datecontroller,
                star: false,
                readOnly: widget.edit,
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
                readOnly: widget.edit,
              ),
              
              textfieldy(
                "Email ID",
                emailid,
                readonly: widget.edit,
              ),
              if(emailide.isNotEmpty)
              errormessage(emailide),
              textfieldy(
                "Address",
                address,
                readonly: widget.edit,
              ),
              if(addresse.isNotEmpty)
              errormessage(addresse),
              Districtcity(
                districte: districte,
                citye: citye,

                selecteddistrict: selecteddistrictitems,
                selectedcity: selectedcityitems,

                ondistrictChanged: (value) {
                  setState(() {
                    selecteddistrictitems = value;
                    selectedcityitems = null;
                  });
                },
                oncityChanged: (value) {
                  setState(() {
                    selectedcityitems = value;
                  });
                },

                edit: widget.edit,
              ),
              textfieldy(
                'Pincode',
                pincode,
                readonly: widget.edit,
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
                readOnly: widget.edit,
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
                readOnly: widget.edit,
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
                edit: widget.edit,
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
                readOnly: widget.edit,
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
                readOnly: widget.edit,
              ),
              if(exchangeflage.isNotEmpty)
              errormessage(exchangeflage),
              Followupdate(
                title: 'Follow Up Date',
                datecontroller: followupdatecontroller,
                star: false,
                readOnly: widget.edit,
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
                readOnly: widget.edit,
              ),
              description(
                'Customer Remarks',
                customerremarks,
                readonly: widget.edit
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
                  Followupdate(
                    title: 'Delivery Date',
                    datecontroller: deliverydate,
                  ),
                  if(deliverydatee.isNotEmpty)
                  errormessage(deliverydatee),
                  TimeField(
                    title: 'Delivery Time',
                    timeController: deliverytime,
                  ),
                  if(deliverytimee.isNotEmpty)
                  errormessage(deliverytimee),
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
    );
  }
}