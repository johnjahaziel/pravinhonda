import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/districtcity.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customtimefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Simpleview extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Simpleview({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Simpleview> createState() => _SimpleviewState();
}

class _SimpleviewState extends State<Simpleview> {

  bool readonly = true;

  String? selectedmodelnameitems;
  String? selectedmodelvariantitems;
  String? selectedmodelcoloritems;

  String? selecteddistrictitems;
  String? selectedcityitems;

  late TextEditingController enquiryid;
  late TextEditingController wingsenquiry;
  late TextEditingController pincode;
  late TextEditingController customername;
  late TextEditingController customerremarks;

  late TextEditingController chassisno;
  late TextEditingController engineno;
  late TextEditingController keyno;
  late TextEditingController batteryno;
  late TextEditingController tyremake;
  late TextEditingController rrtyreno;
  late TextEditingController fttyreno;
  late TextEditingController deliverydate;
  late TextEditingController deliverytime;

  List<dynamic> mpproducts = [];
  List<dynamic> mpprice = [];
  String? mptotal;

  List<dynamic> efproducts = [];
  List<dynamic> efprice = [];

  String minimumPackageAnswer = 'no';
  List<String> extraFittingsSelected = [];

  String districte = '';
  String citye = '';
  String modelnamee = '';
  String modelvariante = '';
  String modelcolore = '';

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
    selecteddistrictitems = enquiry['district'];
    selectedcityitems = enquiry['city'];
    selectedmodelnameitems = enquiry['model_name'];
    selectedmodelvariantitems = enquiry['model_variant'];
    selectedmodelcoloritems = enquiry['model_color'];
    customername = TextEditingController(text: enquiry['customer_name'] ?? '');
    pincode = TextEditingController(text: enquiry['pincode'].toString());
    customerremarks = TextEditingController(text: enquiry['customers_remarks'] ?? '');
    extraFittingsSelected = List<String>.from(enquiry['extra_package'] ?? []);

    final List<dynamic> minPkg = enquiry['minimum_package'] as List<dynamic>? ?? [];

    setState(() {
      minimumPackageAnswer = minPkg.isNotEmpty ? 'yes' : 'no';
    });

    chassisno = TextEditingController(text: enquiry['chassis_no']?.toString() ?? '');
    engineno = TextEditingController(text: enquiry['engine_no']?.toString() ?? '');
    keyno = TextEditingController(text: enquiry['key_no']?.toString() ?? '');
    batteryno = TextEditingController(text: enquiry['battery_no']?.toString() ?? '');
    tyremake = TextEditingController(text: enquiry['tyre_make']?.toString() ?? '');
    rrtyreno = TextEditingController(text: enquiry['RR_tyre_no']?.toString() ?? '');
    fttyreno = TextEditingController(text: enquiry['FT_tyre_no']?.toString() ?? '');
    deliverydate = TextEditingController(text: enquiry['delivery_date']?.toString() ?? '');
    deliverytime = TextEditingController(text: enquiry['delivery_time']?.toString() ?? '');
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
    return SingleChildScrollView(
      child: Padding(
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
              'High Rise Number',
              wingsenquiry,
              readonly: readonly,
              star: false
            ),
            textfieldy(
              'Customer Name',
              customername,
              readonly: readonly,
            ),
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
            description(
              'Customer Remarks',
              customerremarks,
              readonly: readonly
            ),
            textfieldy(
              'Chassis No',
              chassisno,
              readonly: true,
            ),
            textfieldy(
              'Engine No',
              engineno,
              readonly: true,
            ),
            textfieldy(
              'Key No',
              keyno,
              readonly: true,
            ),
            textfieldy(
              'Battery No',
              batteryno,
              readonly: true,
            ),
            textfieldy(
              'Tyre Make',
              tyremake,
              readonly: true,
            ),
            textfieldy(
              'RR Tyre No',
              rrtyreno,
              readonly: true,
            ),
            textfieldy(
              'FT Tyre No',
              fttyreno,
              readonly: true,
            ),
            Followupdate(
              title: 'Estimated Delivery Date',
              datecontroller: deliverydate,
              readOnly: true,
            ),
            TimeField(
              title: 'Estimated Delivery Time',
              timeController: deliverytime,
              readOnly: true,
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
            SizedBox(height: SizeConfig.h(40)),
          ],
        ),
      ),
    );
  }
}