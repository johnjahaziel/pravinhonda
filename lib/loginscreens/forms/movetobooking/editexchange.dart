import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class EditexchangeMB extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;

  final bool edit;
  const EditexchangeMB({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
    required this.edit
  });

  @override
  State<EditexchangeMB> createState() => _EditexchangeMBState();
}

class _EditexchangeMBState extends State<EditexchangeMB> {
  late TextEditingController name;
  late TextEditingController address;
  late TextEditingController vehiclemodal;
  late TextEditingController newvehiclemodal;
  late TextEditingController expectedprice;
  late TextEditingController finalizedprice;
  late TextEditingController assessedby;

  String namee = '';
  String addresse = '';
  String vehiclemodale = '';
  String newvehiclemodale = '';
  String expectedpricee = '';
  String finalizedpricee = '';
  String assessedbye = '';

  Map<String, dynamic> originalEnquiry = {};

  @override
  void initState() {
    super.initState();
    // print('Api Response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

    name = TextEditingController(text: (enquiry['exchange_name'] ?? '').toString());
    address = TextEditingController(text: (enquiry['exchange_address'] ?? '').toString());
    vehiclemodal = TextEditingController(text: (enquiry['vehicle_model'] ?? '').toString());
    newvehiclemodal = TextEditingController(text: (enquiry['new_vehicle_model'] ?? '').toString());
    expectedprice = TextEditingController(text: (enquiry['expected_price'] ?? '').toString());
    finalizedprice = TextEditingController(text: (enquiry['finalized_price'] ?? '').toString());
    assessedby = TextEditingController(text: (enquiry['assessed_by'] ?? '').toString());
  }

  bool isEdited() {
    return
      name.text != (originalEnquiry['exchange_name'] ?? '') ||
      address.text != (originalEnquiry['exchange_address'] ?? '') ||
      vehiclemodal.text != (originalEnquiry['vehicle_model'] ?? '') ||
      newvehiclemodal.text != (originalEnquiry['new_vehicle_model'] ?? '') ||
      expectedprice.text != (originalEnquiry['expected_price'] ?? '') ||
      finalizedprice.text != (originalEnquiry['finalized_price'] ?? '') ||
      assessedby.text != (originalEnquiry['assessed_by'] ?? '');
  }

  Future<void> exchangeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'exchange_name': name.text,
          'exchange_address': address.text,
          'vehicle_model': vehiclemodal.text,
          'new_vehicle_model': newvehiclemodal.text,
          'expected_price': expectedprice.text,
          'finalized_price': finalizedprice.text,
          'assessed_by': assessedby.text,

          // "exchange_name": "Maha Kala",
          // "exchange_address": "123, MG Road, Chennai",
          // "vehicle_model": "Honda City 2018",
          // "new_vehicle_model": "September 2025",
          // "expected_price": 50000.00,
          // "finalized_price": 48000.00,
          // "assessed_by": "Athi"
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
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => QuotationSuccessPopup(
                  name: '${responseData['data']['customer_name']}',
                  number: '${responseData['data']['customer_contact_number']}',
                  enquiryid: responseData['data']['enquiry_id'],
                ),
              );
          },
          nextpage: 'Quotation'
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          namee = errors['exchange_name']?.toString() ?? '';
          addresse = errors['exchange_address']?.toString() ?? '';
          vehiclemodale = errors['vehicle_model']?.toString() ?? '';
          newvehiclemodale = errors['new_vehicle_model']?.toString() ?? '';
          expectedpricee = errors['expected_price']?.toString() ?? '';
          finalizedpricee = errors['finalized_price']?.toString() ?? '';
          assessedbye = errors['assessed_by']?.toString() ?? '';
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
        print(response.body);
      }
    } catch (error) {
      print('Error submitting finance form: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        children: [
          textfieldy(
            'Name',
            name,
            readonly: widget.edit,
          ),
          if(namee.isNotEmpty)
          errormessage(namee),
          description(
            'Address',
            address,
            star: true,
            readonly: widget.edit,
          ),
          if(addresse.isNotEmpty)
          errormessage(addresse),
          textfieldy(
            'Vehicle Modal',
            vehiclemodal,
            readonly: widget.edit,
          ),
          if(vehiclemodale.isNotEmpty)
          errormessage(vehiclemodale),
          textfieldy(
            'New Vehicle Modal',
            newvehiclemodal,
            readonly: widget.edit,
          ),
          if(newvehiclemodale.isNotEmpty)
          errormessage(newvehiclemodale),
          textfieldy(
            'Expected Price',
            expectedprice,
            readonly: widget.edit,
          ),
          if(expectedpricee.isNotEmpty)
          errormessage(expectedpricee),
          textfieldy(
            'Finalized Price',
            finalizedprice,
            readonly: widget.edit,
          ),
          if(finalizedpricee.isNotEmpty)
          errormessage(finalizedpricee),
          textfieldy(
            'Assessed By',
            assessedby,
            readonly: widget.edit,
          ),
          if(assessedbye.isNotEmpty)
          errormessage(assessedbye),
          if(isEdited() == true)
          SizedBox(height: SizeConfig.h(25)),
          if(isEdited() == true)
          button(
            'Update Quotation',
            () {
              exchangeform();
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}