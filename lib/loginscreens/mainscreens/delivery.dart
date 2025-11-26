import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  List<dynamic> alldata = [];
  bool isLoading = true;

  Future<void> getalldata() async{
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    try{
      final response = await http.get(url);

      if(response.statusCode == 200) {
        
        final Map<String, dynamic> responsedata = jsonDecode(response.body);
        final List<dynamic> data = (responsedata['data'] as List);

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
                  'Delivery',
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
                    'No delievery found.',
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
                      enquiryid: data['enquiry_id'] ?? 0,
                      id: data['customer_id']?.toString() ?? '',
                      customername: data['customer_name']?.toString() ?? '',
                      contactnumber: data['customer_contact_number']?.toString() ?? '',
                      status: data['status']?.toString() ?? '',
                      cashfinance: data['purchase_type']?.toString() ?? '',
                      textride: data['test_ride']?.toString() ?? '',
                      exchange: data['exchange_flag']?.toString() ?? '',
                      onTap: () {}
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