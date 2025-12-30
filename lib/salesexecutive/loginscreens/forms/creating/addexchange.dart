import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/salesexecutive/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Addexchange extends StatefulWidget {
  final int enquiryid;
  const Addexchange({
    super.key,
    required this.enquiryid,
  });

  @override
  State<Addexchange> createState() => _AddexchangeState();
}

class _AddexchangeState extends State<Addexchange> {

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController vehiclemodal = TextEditingController();
  TextEditingController newvehiclemodal = TextEditingController();
  TextEditingController expectedprice = TextEditingController();
  TextEditingController finalizedprice = TextEditingController();
  TextEditingController assessedby = TextEditingController();

  String namee = '';
  String addresse = '';
  String vehiclemodale = '';
  String newvehiclemodale = '';
  String expectedpricee = '';
  String finalizedpricee = '';
  String assessedbye = '';

  Future<void> exchangeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/exchange/${widget.enquiryid}');

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Createquotation(
                  enquiryid: responseData['data']['enquiry_id'],
                  apiResponse: responseData,
                )
              )
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
    SizeConfig.init(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textfieldy(
                'Name',
                name
              ),
              if(namee.isNotEmpty)
              errormessage(namee),
              description(
                'Address',
                address,
                star: true
              ),
              if(addresse.isNotEmpty)
              errormessage(addresse),
              textfieldy(
                'Vehicle Modal',
                vehiclemodal
              ),
              if(vehiclemodale.isNotEmpty)
              errormessage(vehiclemodale),
              textfieldy(
                'New Vehicle Modal',
                newvehiclemodal
              ),
              if(newvehiclemodale.isNotEmpty)
              errormessage(newvehiclemodale),
              textfieldy(
                'Expected Price',
                expectedprice
              ),
              if(expectedpricee.isNotEmpty)
              errormessage(expectedpricee),
              textfieldy(
                'Finalized Price',
                finalizedprice
              ),
              if(finalizedpricee.isNotEmpty)
              errormessage(finalizedpricee),
              textfieldy(
                'Assessed By',
                assessedby
              ),
              if(assessedbye.isNotEmpty)
              errormessage(assessedbye),
              SizedBox(height: SizeConfig.h(25)),
              button(
                'Submit',
                () {
                  exchangeform();
                }
              ),
              SizedBox(height: SizeConfig.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}