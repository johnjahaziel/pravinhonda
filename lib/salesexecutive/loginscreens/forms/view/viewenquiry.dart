import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/districtcity.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Viewenquiry extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Viewenquiry({
    super.key,
    required this.apiResponse,
  });

  @override
  State<Viewenquiry> createState() => _ViewenquiryState();
}

class _ViewenquiryState extends State<Viewenquiry> {

  bool readonly = true;

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

  List<dynamic> mpproducts = [];
  List<dynamic> mpprice = [];
  String? mptotal;

  List<dynamic> efproducts = [];
  List<dynamic> efprice = [];

  String minimumPackageAnswer = 'no';
  List<String> extraFittingsSelected = [];

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
    print('Api Response from child: ${widget.apiResponse}');

    if (selectedmodelnameitems != null && selectedmodelnameitems!.isNotEmpty) {
      fetchminimumpackage(selectedmodelnameitems!);
      fetchextrafitting(selectedmodelnameitems!);
    }
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

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
    // selectedmodelvariantitems = enquiry['model_variant'];
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
    extraFittingsSelected = List<String>.from(enquiry['extra_package'] ?? []);

    final List<dynamic> minPkg = enquiry['minimum_package'] as List<dynamic>? ?? [];

    setState(() {
      minimumPackageAnswer = minPkg.isNotEmpty ? 'yes' : 'no';
    });
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
  String minimumpackagee = '';
  String extrafittingse = '';

  Future<void> fetchminimumpackage(String modelname) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/minimum-package/$modelname');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        setState(() {
          mpproducts = responseData['products'];
          mpprice = responseData['prices'];
          mptotal = responseData['total'];
        });
      } else {
        print('Failed to fetch Minimum Package. Status code: ${response.statusCode}');
      }

    } catch (e) {
      print('Fetching Minimum Package: $e');
    }
  }

  Future<void> fetchextrafitting(String modelname) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/extra-fitting/$modelname');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        setState(() {
          efproducts = responseData['products'];
          efprice = responseData['prices'];
        });
      } else {
        print('Failed to fetch Minimum Package. Status code: ${response.statusCode}');
      }

    } catch (e) {
      print('Fetching Minimum Package: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textfieldy(
            'Enquiry Number',
            enquiryid,
            readonly: true,
          ),
          textfieldy(
            'Customer Name',
            customername,
            readonly: readonly,
          ),
          if(customernamee.isNotEmpty)
          errormessage(customernamee),
          textfieldy(
            'Customer Contact Number',
            customercontactnumber,
            readonly: readonly,
          ),
          if(customercontactnumbere.isNotEmpty)
          errormessage(customercontactnumbere),
          textfieldy(
            'Secondary Contact Number',
            secondarycontactnumber,
            readonly: readonly,
            star: false
          ),
          if(secondarycontactnumbere.isNotEmpty)
          errormessage(secondarycontactnumbere),
          textfieldy(
            "Address",
            address,
            readonly: readonly,
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
        
            edit: readonly,
          ),
          textfieldy(
            'Pincode',
            pincode,
            readonly: readonly,
          ),
          if(pincodee.isNotEmpty)
          errormessage(pincodee),
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
            readOnly: readonly,
          ),
          if(gendere.isNotEmpty)
          errormessage(gendere),
          Dateofbirthfield(
            title: 'Date of Birth',
            datecontroller: datecontroller,
            star: false,
            readOnly: readonly,
          ),
        
          CustomDropdown(
            title: 'Marital Status',
            selectedCustomDropdown: selectedmartialstatusitems,
            customDropdownItems: martialstatusitems,
            onChanged: (newValue) {
              setState(() {
                selectedmartialstatusitems = newValue;
              });
            },
            star: false,
            readOnly: readonly,
          ),
          textfieldy(
            "Email ID",
            emailid,
            star: false,
            readonly: readonly,
          ),
          if(emailide.isNotEmpty)
          errormessage(emailide),
          textfieldy(
            'High Rise Number',
            wingsenquiry,
            readonly: readonly,
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
            readOnly: readonly,
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
            readOnly: readonly,
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
            readOnly: readonly,
          ),
          if(customertypee.isNotEmpty)
          errormessage(customertypee),
          CustomDropdown(
            title: 'Enquiry Type',
            selectedCustomDropdown: selectedenquirytypeitems,
            customDropdownItems: enquirytypeitems,
            onChanged: (newValue) {
              setState(() {
                selectedenquirytypeitems = newValue;
              });
            },
            readOnly: readonly,
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
            readOnly: readonly,
          ),
          if(enquirysourcee.isNotEmpty)
          errormessage(enquirysourcee),
          Namevariantcolor(
            modelnamee: modelnamee,
            // modelvariante: modelvariante,
            modelcolore: modelcolore,
            
            selectedname: selectedmodelnameitems,
            // selectedvariant: selectedmodelvariantitems,
            selectedcolor: selectedmodelcoloritems,
            onNameChanged: (value) {
              setState(() {
                selectedmodelnameitems = value;
              });

              mpproducts.clear();
              mpprice.clear();
              mptotal = '';

              if (value != null && value.isNotEmpty) {
                fetchminimumpackage(value);
              }

              efproducts.clear();
              efprice.clear();

              if (value != null && value.isNotEmpty) {
                fetchextrafitting(value);
              }
            },
            // onVariantChanged: (value) {
            //   setState(() {
            //     selectedmodelvariantitems = value;
            //     selectedmodelcoloritems = null;
            //   });
            // },
            onColorChanged: (value) {
              setState(() {
                selectedmodelcoloritems = value;
              });
            },
            edit: readonly,
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
            readOnly: readonly,
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
            readOnly: readonly,
          ),
          if(exchangeflage.isNotEmpty)
          errormessage(exchangeflage),
          Followupdate(
            title: 'Follow Up Date',
            datecontroller: followupdatecontroller,
            readOnly: readonly,
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
            readOnly: readonly,
          ),
          description(
            'Customer Remarks',
            customerremarks,
            readonly: readonly
          ),
          EditMinimumpackage(
            title: 'Minimum Packages',
            product: mpproducts,
            price: mpprice,
            total: mptotal ?? '0',
            onChanged: (value) {
              setState(() {
                minimumPackageAnswer = value;
              });
            },
            readonly: readonly,
            answer: minimumPackageAnswer.isEmpty ? 'no' : minimumPackageAnswer,
          ),
          if(minimumpackagee.isNotEmpty)
          errormessage(minimumpackagee),
          EditExtrafittings(
            title: 'Extra Fittings',
            product: efproducts,
            price: efprice,
            initialSelected: extraFittingsSelected,
            onChanged: (items) {
              setState(() {
                extraFittingsSelected = items;
              });
            },
            readonly: readonly,
          ),
          if(extrafittingse.isNotEmpty)
          errormessage(extrafittingse),
          SizedBox(height: SizeConfig.h(40)),
        ],
      ),
    );
  }
}