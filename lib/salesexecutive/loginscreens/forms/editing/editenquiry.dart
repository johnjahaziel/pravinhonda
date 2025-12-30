import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/salesexecutive/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/salesexecutive/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/districtcity.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Editenquiry extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  final bool edit;

  final VoidCallback financeselected;
  final VoidCallback exchangeselected;
  const Editenquiry({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
    required this.financeselected,
    required this.exchangeselected,
    required this.edit
  });

  @override
  State<Editenquiry> createState() => _EditenquiryState();
}

class _EditenquiryState extends State<Editenquiry> {

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

  String? minimumPackageAnswer;
  List<String> extraFittingsSelected = [];

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);

    if (selectedmodelnameitems != null && selectedmodelnameitems!.isNotEmpty) {
      fetchminimumpackage(selectedmodelnameitems!);
      fetchextrafitting(selectedmodelnameitems!);
    }

    print(extraFittingsSelected);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp['data'] ?? {};

    wingsenquiry = TextEditingController(text: enquiry['high_rise_number'] ?? '');
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
    minimumPackageAnswer = enquiry['minimum_package']?.toString();
    extraFittingsSelected = List<String>.from(enquiry['extra_package'] ?? []);
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

  String nextpagelocal = '';

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
          'minimum_package': minimumPackageAnswer.toString(),
          "extra_fittings": extraFittingsSelected.join(','),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        BlocProvider.of<ApiresponseCubit>(context).clearApiresponse();
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
          minimumpackagee = errors['minimum_package']?.toString() ?? '';
          extrafittingse = errors['extra_fittings']?.toString() ?? '';
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
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textfieldy(
                'Customer Name',
                customername,
                readonly: widget.edit,
              ),
              if(customernamee.isNotEmpty)
              errormessage(customernamee),
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
                star: false
              ),
              if(secondarycontactnumbere.isNotEmpty)
              errormessage(secondarycontactnumbere),
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
                star: false,
                readonly: widget.edit,
              ),
              if(emailide.isNotEmpty)
              errormessage(emailide),
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
                readonly: widget.edit,
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
                readonly: widget.edit,
              ),
              if(extrafittingse.isNotEmpty)
              errormessage(extrafittingse),
              SizedBox(height: SizeConfig.h(20)),
              button(
                'Create Quotation',
                () {
                  apiconnection();
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