import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  List<dynamic> alldata = [];
  bool isLoading = true;

  Future<void> getallenquiry() async{
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries');

    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {

        List<dynamic> responseData = jsonDecode(response.body);

        setState(() {
          alldata = responseData;
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
    getallenquiry();
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
                        'Enquiry',
                        style: customtext(fs18, kred, FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(10)),
                    if (alldata.isEmpty)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No enquiries found.'),
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
                              id: data['customer_id'],
                              customername: data['customer_name'],
                              contactnumber: data['customer_contact_number'],
                              status: data['status'].toString(),
                              cashfinance: data['purchase_type'],
                              textride: data['test_ride'],
                              exchange: data['exchange_flag']
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}