import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/lostcustomerreason.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Hondabox extends StatefulWidget {
  final String enquiryid;
  final String id;
  final String customername;
  final String contactnumber;
  final String status;
  final String cashfinance;
  final String textride;
  final String exchange;
  final VoidCallback onTap;
  final bool buttonneed;
  const Hondabox({
    super.key,
    required this.enquiryid,
    required this.id,
    required this.customername,
    required this.contactnumber,
    required this.status,
    this.cashfinance = 'no',
    this.textride = 'No',
    this.exchange = 'No',
    required this.onTap,
    this.buttonneed = true
  });

  @override
  State<Hondabox> createState() => _HondaboxState();
}

class _HondaboxState extends State<Hondabox> {

  void callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    await launchUrl(url);
  }

  void openWhatsApp(String number) async {
    final whatsappUrl = Uri.parse('https://wa.me/91${number}');

    launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.h(5),bottom: SizeConfig.h(5)),
      child: RawMaterialButton(
        onPressed: widget.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all( 
              color: kgrey
            )
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(10),vertical: SizeConfig.h(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow(Icons.confirmation_number_outlined, widget.id),
                          infoRow(Icons.person_outline, widget.customername),
                          infoRow(Icons.phone_outlined, widget.contactnumber),
                          infoRow(Icons.info_outline, widget.status, gap: false),
                        ],
                      ),
                    ),
                    if(widget.buttonneed == true)
                    Column(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            callNumber(widget.contactnumber);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => ReviewBoxes(
                                name: widget.customername,
                                number: widget.contactnumber,
                                enquiryid: widget.enquiryid,
                              ),
                            );
                          },
                          constraints: BoxConstraints.tightFor(
                            height: SizeConfig.h(40),
                            width: SizeConfig.w(40)
                          ),
                          fillColor: kgreen2,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.call,
                            color: kwhite,
                          ),
                        ),
                        SizedBox(height: SizeConfig.h(7)),
                        RawMaterialButton(
                          onPressed: () {
                            openWhatsApp(widget.contactnumber);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => ReviewBoxes(
                                name: widget.customername,
                                number: widget.contactnumber,
                                enquiryid: widget.enquiryid,
                              ),
                            );
                          },
                          constraints: BoxConstraints.tightFor(
                            height: SizeConfig.h(40),
                            width: SizeConfig.w(40)
                          ),
                          fillColor: kgreen,
                          shape: CircleBorder(),
                          child: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: kwhite,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    if(widget.textride == 'yes')
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kyellow,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                          child: Text(
                            'Test Ride',
                            style: textmedium8,
                          ),
                        ),
                        SizedBox(width: SizeConfig.w(4)),
                      ],
                    ),
                    if(widget.cashfinance != 'no')
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kblue,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                          child: Text(
                            '${widget.cashfinance[0].toUpperCase()}${widget.cashfinance.substring(1)}',
                            style: textmedium8,
                          ),
                        ),
                        SizedBox(width: SizeConfig.w(4)),
                      ],
                    ),
                    if(widget.exchange == 'yes')
                    Container(
                      decoration: BoxDecoration(
                        color: kgreen2,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                      child: Text(
                        'Exchange',
                        style: textmedium8,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text, {bool gap = true}) {
    return Padding(
      padding: gap == true ? EdgeInsets.only(bottom: SizeConfig.h(4)) : EdgeInsetsGeometry.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: kgrey),
          SizedBox(width: SizeConfig.w(6)),
          Expanded(
            child: Text(
              text,
              style: textmedium12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Pdiinchargebox extends StatefulWidget {
  final String enquiryid;
  final String id;
  final String customername;
  final String highrisenumber;
  final String model;
  // final String variant;
  final String color;
  final String deliverydate;
  final String deliverytime;
  final String status;
  final String cashfinance;
  final String textride;
  final String exchange;
  final VoidCallback onTap;

  const Pdiinchargebox({
    super.key,
    required this.enquiryid,
    required this.id,
    required this.customername,
    required this.highrisenumber,
    required this.deliverydate,
    required this.deliverytime,
    required this.model,
    // required this.variant,
    required this.color,
    required this.status,
    this.cashfinance = 'no',
    this.textride = 'No',
    this.exchange = 'No',
    required this.onTap,
  });

  @override
  State<Pdiinchargebox> createState() => _PdiinchargeboxState();
}

class _PdiinchargeboxState extends State<Pdiinchargebox> {

  void callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    await launchUrl(url);
  }

  void openWhatsApp(String number) async {
    final whatsappUrl = Uri.parse('https://wa.me/91${number}');
    
    launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'booking':
        return const Color(0xFFFFF3CD); // soft yellow
      case 'accepted':
        return const Color(0xFFD1FAE5); // mint green
      case 'allocated helper':
        return const Color(0xFFE0E7FF); // indigo blue
      case 'spare dep':
        return const Color(0xFFFFE4E6); // light rose
      case 'working':
        return const Color(0xFFFDE68A); // amber
      case 'completed':
        return const Color(0xFFBBF7D0); // success green
      case 'delivery':
        return const Color(0xFFDBEAFE); // sky blue
      default:
        return const Color(0xFFF3F4F6); // neutral grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(5),
      ),
      child: RawMaterialButton(
        onPressed: widget.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kgrey),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(10),
            vertical: SizeConfig.h(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 ENQUIRY ID (TOP)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enquiry ID : ${widget.id}',
                    style: textbold12,
                  ),
                  Text(
                    'HRN : ${widget.highrisenumber}',
                    style: textbold12,
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(8)),

              /// 🔹 DETAILS WITH ICONS
              infoRow(Icons.person_outline, widget.customername),
              infoRow(Icons.directions_bike_outlined, widget.model),
              // infoRow(Icons.layers_outlined, widget.variant),
              infoRow(Icons.palette_outlined, widget.color),
              
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: kgrey),
                      SizedBox(width: SizeConfig.w(6)),
                      Text(
                        widget.deliverydate,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(width: SizeConfig.w(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.access_time_outlined, size: 14, color: kgrey),
                      SizedBox(width: SizeConfig.w(6)),
                      Text(
                        widget.deliverytime,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),

              // SizedBox(height: SizeConfig.h(6)),

              /// 🔹 TAGS ROW
              // Row(
              //   children: [
              //     if (widget.textride == 'yes')
              //       _tag('Test Ride', kyellow),

              //     if (widget.cashfinance != 'no')
              //       _tag(
              //         '${widget.cashfinance[0].toUpperCase()}${widget.cashfinance.substring(1)}',
              //         kblue,
              //       ),

              //     if (widget.exchange == 'yes')
              //       _tag('Exchange', kgreen2),
              //   ],
              // ),

              SizedBox(height: SizeConfig.h(10)),

              /// 🔹 STATUS STRIP (BOTTOM)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.h(6),
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(widget.status),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    widget.status.toUpperCase(),
                    style: textbold12.copyWith(
                      color: Colors.black87,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _tag(String text, Color color) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: SizeConfig.w(4)),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: SizeConfig.w(6),
  //         vertical: SizeConfig.h(2),
  //       ),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Text(text, style: textmedium8),
  //     ),
  //   );
  // }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: kgrey),
          SizedBox(width: SizeConfig.w(6)),
          Expanded(
            child: Text(
              text,
              style: textmedium12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceMenu extends StatefulWidget {
  final String enquiryid;
  final String id;
  final String customername;
  final String highrisenumber;
  final String model;
  // final String variant;
  final String color;
  final String finance;
  final VoidCallback onTap;

  const FinanceMenu({
    super.key,
    required this.enquiryid,
    required this.id,
    required this.customername,
    required this.highrisenumber,
    required this.finance,
    required this.model,
    // required this.variant,
    required this.color,
    required this.onTap,
  });

  @override
  State<FinanceMenu> createState() => _FinanceMenuState();
}

class _FinanceMenuState extends State<FinanceMenu> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(5),
      ),
      child: RawMaterialButton(
        onPressed: widget.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kgrey),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(10),
            vertical: SizeConfig.h(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 ENQUIRY ID (TOP)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enquiry ID : ${widget.id}',
                    style: textbold12,
                  ),
                  // Text(
                  //   'HRN : ${widget.highrisenumber}',
                  //   style: textbold12,
                  // ),
                ],
              ),

              SizedBox(height: SizeConfig.h(8)),

              /// 🔹 DETAILS WITH ICONS
              infoRow(Icons.person_outline, widget.customername),
              infoRow(Icons.directions_bike_outlined, widget.model),
              // infoRow(Icons.layers_outlined, widget.variant),
              infoRow(Icons.palette_outlined, widget.color),
              infoRow(Icons.cases, widget.finance),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _tag(String text, Color color) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: SizeConfig.w(4)),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: SizeConfig.w(6),
  //         vertical: SizeConfig.h(2),
  //       ),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Text(text, style: textmedium8),
  //     ),
  //   );
  // }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: kgrey),
          SizedBox(width: SizeConfig.w(6)),
          Expanded(
            child: Text(
              text,
              style: textmedium12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangeMenu extends StatefulWidget {
  final String enquiryid;
  final String id;
  final String customername;
  final String presentmodelowned;
  final String expectedprice;
  final VoidCallback onTap;

  const ExchangeMenu({
    super.key,
    required this.enquiryid,
    required this.id,
    required this.customername,
    required this.presentmodelowned,
    required this.expectedprice,
    required this.onTap,
  });

  @override
  State<ExchangeMenu> createState() => _ExchangeMenuState();
}

class _ExchangeMenuState extends State<ExchangeMenu> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(5),
      ),
      child: RawMaterialButton(
        onPressed: widget.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kgrey),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(10),
            vertical: SizeConfig.h(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 ENQUIRY ID (TOP)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enquiry ID : ${widget.id}',
                    style: textbold12,
                  ),
                  // Text(
                  //   'HRN : ${widget.highrisenumber}',
                  //   style: textbold12,
                  // ),
                ],
              ),

              SizedBox(height: SizeConfig.h(8)),

              /// 🔹 DETAILS WITH ICONS
              infoRow(Icons.person_outline, widget.customername),
              infoRow(Icons.directions_bike_outlined, widget.presentmodelowned),
              // infoRow(Icons.layers_outlined, widget.variant),
              infoRow(Icons.palette_outlined, widget.expectedprice),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _tag(String text, Color color) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: SizeConfig.w(4)),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: SizeConfig.w(6),
  //         vertical: SizeConfig.h(2),
  //       ),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Text(text, style: textmedium8),
  //     ),
  //   );
  // }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: kgrey),
          SizedBox(width: SizeConfig.w(6)),
          Expanded(
            child: Text(
              text,
              style: textmedium12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewBoxes extends StatefulWidget {
  final String name;
  final String number;
  final String enquiryid;

  const ReviewBoxes({
    super.key,
    required this.name,
    required this.number,
    required this.enquiryid,
  });

  @override
  State<ReviewBoxes> createState() => _ReviewBoxesState();
}

class _ReviewBoxesState extends State<ReviewBoxes> {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController commemts = TextEditingController();

  bool isChecked = false;

  Future<void> apiconnection() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/${widget.enquiryid}/followup');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'followupdate': datecontroller.text,
          'followupnote': commemts.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Follow-up updated successfully.');

        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: responseData['message']);
        print('Failed to update follow-up. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tightFor(
        width: double.infinity
      ),
      backgroundColor: kwhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(5),left: SizeConfig.w(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : ${widget.name}",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : ${widget.number}",
                      style: textmedium12,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(20)),
          description(
            'Comments',
            commemts,
            padding: true,
          ),
          SizedBox(height: SizeConfig.h(10)),
          Followupdate(
            title: 'Next Follow Up Date',
            datecontroller: datecontroller,
            padding: true,
          ),
          SizedBox(height: SizeConfig.h(10)),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.w(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: kred,
                ),
                Text(
                  'Lost Customer',
                  style: text12,
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.h(10)),
          button(
            'Update',
            () {
              if(isChecked == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Lostcustomer(
                    name: widget.name,
                    number: widget.number,
                    enquiryId: widget.enquiryid,
                  ),
                );
              } else {
                apiconnection();
              }
            },
            padding: true
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}

class Lostcustomer extends StatefulWidget {
  final String name;
  final String number;
  final String enquiryId;
  const Lostcustomer({
    super.key,
    required this.name,
    required this.number,
    required this.enquiryId,
  });

  @override
  State<Lostcustomer> createState() => _LostcustomerState();
}

class _LostcustomerState extends State<Lostcustomer> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tightFor(
        width: double.infinity
      ),
      backgroundColor: kwhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(5),left: SizeConfig.w(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : ${widget.name}",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : ${widget.number}",
                      style: textmedium12,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(20)),
          LottieBuilder(
            height: SizeConfig.h(120),
            width: SizeConfig.w(120),
            lottie: AssetLottie(
              'lottie/sad.json',
            ),
          ),
          SizedBox(height: SizeConfig.h(10)),
          Text(
            "Are You Sure that the customer is not\nInterested in Purchase the bike",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "That action can’t be revert.",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(30)),
          button(
            'Yes',
            () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LostcustomerReason(
                  enquiryId: widget.enquiryId,
                )),
                ((route) => false)
              );
            },
            padding: true
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}