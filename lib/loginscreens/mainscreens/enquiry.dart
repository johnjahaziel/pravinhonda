import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(20)),
                Center(
                  child: Text(
                    'Enquiry',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
                hondabox(
                  'ID',
                  'Customer Name',
                  'Contact Number',
                  'Status'
                ),
                hondabox(
                  'ID',
                  'Customer Name',
                  'Contact Number',
                  'Status'
                ),
                hondabox(
                  'ID',
                  'Customer Name',
                  'Contact Number',
                  'Status'
                ),
                hondabox(
                  'ID',
                  'Customer Name',
                  'Contact Number',
                  'Status'
                ),
                hondabox(
                  'ID',
                  'Customer Name',
                  'Contact Number',
                  'Status'
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}