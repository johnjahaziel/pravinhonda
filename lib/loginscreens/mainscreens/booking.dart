import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<dynamic> alldata = [];
  bool isLoading = true;

  Future<void> getalldata() async{
    final url = Uri.parse('https://app.pravinhonda.com/api/bookings');

    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {

        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = (responseData['data'] as List);

        setState(() {
          alldata = data;
          isLoading = false;
        });
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getalldata();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kred,
              ),
            )
          : Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(20)),
              Center(
                child: Text(
                  'Booking',
                  style: customtext(
                    fs18,
                    kred,
                    FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.h(10)),
              if(alldata.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No bookings found.',
                    style: text12,
                  ),
                ),
              )
              else
              Expanded(
                child: ListView.builder(
                  itemCount: alldata.length,
                  itemBuilder: (context, index) {
                    final data = alldata[index];
                    return Hondabox(
                      id: data['customer_id']?.toString() ?? '',
                      customername: data['customer_name']?.toString() ?? '',
                      contactnumber: data['customer_contact_number']?.toString() ?? '',
                      status: data['status']?.toString() ?? '',
                      cashfinance: data['purchase_type']?.toString() ?? '',
                      textride: data['test_ride']?.toString() ?? '',
                      exchange: data['exchange_flag']?.toString() ?? '',
                    );
                  }
                )
              )
            ],
          ),
        ),
      )
    );
  }
}