import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/enquiry_id_cubit.dart';
import 'package:pravinhonda/districtcity.dart';
import 'package:pravinhonda/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Addenquiry extends StatefulWidget {
  final VoidCallback financeselected;
  final VoidCallback exchangeselected;
  const Addenquiry({
    super.key,
    required this.financeselected,
    required this.exchangeselected
  });

  @override
  State<Addenquiry> createState() => _AddenquiryState();
}

class _AddenquiryState extends State<Addenquiry> {

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

  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController secondarycontactnumber = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController followupdatecontroller = TextEditingController();
  TextEditingController customerremarks = TextEditingController();

  List<dynamic> mpproducts = [];
  List<dynamic> mpprice = [];
  String? mptotal;

  List<dynamic> efproducts = [];
  List<dynamic> efprice = [];

  String? minimumPackageAnswer;
  List<String> extraFittingsSelected = [];

  String wingsenquirye = '';
  String customercategorye = '';
  String enquirycategorye = '';
  String customertypee = '';
  String customernamee = '';
  String customercontactnumbere = '';
  String secondarycontactnumbere = '';
  String pincodee = '';
  String gendere = '';
  String emailide = '';
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

  String? selectedmodelnameitems;
  String? selectedmodelvariantitems;
  String? selectedmodelcoloritems;

  String? selecteddistrictitems;
  String? selectedcityitems;

  String nextpagelocal = '';

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
          // 'high_rise_number': wingsenquiry.text,
          // 'customer_category': selectedcustomercategoryitems?.toString(),
          // 'enquiry_category': selectedenquirycategoryitems?.toString(),
          // 'customer_type': selectedcustomertypeitems?.toString(),
          // 'customer_contact_number': customercontactnumber.text,
          // 'secondary_contact_number': secondarycontactnumber.text,
          // 'pincode': pincode.text,
          // 'customer_name': customername.text,
          // 'gender': selectedgenderitems?.toString(),
          // 'dob': datecontroller.text,
          // 'marital_status': selectedmartialstatusitems?.toString(),
          // 'email_id': emailid.text,
          // 'address': address.text,
          // 'district' : selecteddistrictitems?.toString(),
          // 'city' : selectedcityitems?.toString(),
          // 'enquiry_type': selectedenquirytypeitems?.toString(),
          // 'enquiry_source': selectedenquirysourceitems?.toString(),
          // 'model_name': selectedmodelnameitems?.toString(),
          // 'model_variant': selectedmodelvariantitems?.toString(),
          // 'model_color': selectedmodelcoloritems?.toString(),
          // 'purchase_type': selectedpurchasetypeitems?.toString(),
          // 'exchange_flag': selectedexchangeflagitems?.toString(),
          // 'follow_up_date': followupdatecontroller.text,
          // 'test_ride': selectedtestrideitems?.toString(),
          // 'customers_remarks': customerremarks.text,
          // "minimum_package": minimumPackageAnswer,
          // "extra_fittings": extraFittingsSelected.join(','),

          'high_rise_number': wingsenquiry.text,
          'customer_category': "Individual",
          'enquiry_category': "Individual",
          'customer_type': "Replacement Buyer",
          'customer_contact_number':  "1226586431",
          'secondary_contact_number': secondarycontactnumber.text,
          'pincode': "555555",
          'customer_name': "Maha",
          'gender': "Female",
          'dob': datecontroller.text,
          'marital_status': selectedmartialstatusitems?.toString(),
          'email_id': "kalamahabluon@gmail.com",
          'address': "gandhi nager",
          'district' : "Thoothukkudi",
          'city' : "Kovilpatti",
          'enquiry_type': "Walk-In",
          'enquiry_source': "Facebook",
          'model_name': selectedmodelnameitems?.toString(),
          'model_variant': selectedmodelvariantitems?.toString(),
          'model_color': selectedmodelcoloritems?.toString(),
          'purchase_type': selectedpurchasetypeitems?.toString(),
          'exchange_flag': selectedexchangeflagitems?.toString(),
          'follow_up_date': followupdatecontroller.text,
          'test_ride': selectedtestrideitems?.toString(),
          'customers_remarks': "Interested in finance option",
          "minimum_package": minimumPackageAnswer,
          "extra_fittings": extraFittingsSelected.join(','),
        }),
      );

      print('selected city: $selectedcityitems');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('response data: $responseData');

        if (selectedpurchasetypeitems == 'finance') {
          nextpagelocal = 'Finance Form';
        } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
          nextpagelocal = 'Exchange Form';
        } else {
          nextpagelocal = 'Quotation';
        }

        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
            if(selectedpurchasetypeitems == 'finance') {
              widget.financeselected();
              nextpagelocal = 'Finance Form';
            } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
              widget.exchangeselected();
              nextpagelocal = 'Exchange Form';
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Createquotation(
                    enquiryid: responseData['data']['enquiry_id'],
                    apiResponse: responseData,
                  )
                )
              );
              nextpagelocal = 'Quotation';
            }
          },
          nextpage: nextpagelocal.toString()
        );

        final enquiryid = responseData['enquiry_id'];
        BlocProvider.of<EnquiryCubit>(context).setEnquiryid(enquiryid);
        print('enquiryid : $enquiryid');

        BlocProvider.of<ApiresponseCubit>(context).setApiresponse(responseData);

      } else if (response.statusCode == 200) {
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          },
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

  // Future<void> fetchsamemobile() async {
  //   final url = Uri.parse('https://app.pravinhonda.com/api/sales/mobile-count?mobile=${customercontactnumber.text}');

  //   final token = BlocProvider.of<AuthCubit>(context).state.token;

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //     );

  //     final responseData = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(msg: responseData['message']);

  //       final String message = responseData['message'] ?? '';

  //       if (message == "No records found for this mobile number within last 90 days") {

  //         apiconnection();

  //       }

  //       else if (message == "Mobile records fetched successfully (last 90 days)") {

  //         showDialog(
  //           context: context,
  //           barrierDismissible: true,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text(
  //                 'Records Found',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               content: const Text(
  //                 'Previous enquiry records were found for this mobile number.\n\nDo you want to continue?',
  //               ),
  //               actions: [

  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('NO'),
  //                 ),

  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);

  //                     if (selectedpurchasetypeitems == 'finance') {
  //                       widget.financeselected();
  //                       nextpagelocal = 'Finance Form';
  //                     } else if (selectedpurchasetypeitems != 'finance' && selectedexchangeflagitems == 'yes') {
  //                       widget.exchangeselected();
  //                       nextpagelocal = 'Exchange Form';
  //                     } else {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => Createquotation(
  //                             enquiryid: responseData['data']['enquiry_id'],
  //                             apiResponse: responseData,
  //                           ),
  //                         ),
  //                       );
  //                       nextpagelocal = 'Quotation';
  //                     }
  //                   },
  //                   child: const Text('YES'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }

  //       print('Same Mobile Number Response: $responseData');
  //     } else {
  //       Fluttertoast.showToast(msg: responseData['message']);
  //     }
  //   } catch (error) {
  //     print('Error fetching same mobile number: $error');
  //   }
  // }
  
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
                customername
              ),
              if(customernamee.isNotEmpty)
              errormessage(customernamee),
              textfieldy(
                'Customer Contact Number',
                customercontactnumber
              ),
              if(customercontactnumbere.isNotEmpty)
              errormessage(customercontactnumbere),
              textfieldy(
                'Secondary Contact Number',
                secondarycontactnumber,
                star: false
              ),
              if(secondarycontactnumbere.isNotEmpty)
              errormessage(secondarycontactnumbere),
              textfieldy(
                "Address",
                address
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
              ),
              textfieldy(
                'Pincode',
                pincode
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
                star: true,
              ),
              if(gendere.isNotEmpty)
              errormessage(gendere),
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
                'High Rise Number',
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
                modelnamee: modelnamee,
                modelvariante: modelvariante,
                modelcolore: modelcolore,

                selectedname: selectedmodelnameitems,
                selectedvariant: selectedmodelvariantitems,
                selectedcolor: selectedmodelcoloritems,
                onNameChanged: (value) {
                  setState(() {
                    selectedmodelnameitems = value;
                    selectedmodelvariantitems = null;
                    selectedmodelcoloritems = null;

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
                customerremarks,
                star: false,
              ),
              if(customerremarkse.isNotEmpty)
              errormessage(customerremarkse),
              Minimumpackage(
                title: 'Minimum Packages',
                product: mpproducts,
                price: mpprice,
                total: mptotal ?? '0',
                onChanged: (answer) {
                  setState(() {
                    minimumPackageAnswer = answer;
                  });
                },
              ),
              if(minimumpackagee.isNotEmpty)
              errormessage(minimumpackagee),
              Extrafittings(
                title: 'Extra Fittings',
                product: efproducts,
                price: efprice,
                onChanged: (items) {
                  setState(() {
                    extraFittingsSelected = items;
                  });
                },
              ),
              if(extrafittingse.isNotEmpty)
              errormessage(extrafittingse),
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
    );
  }
}