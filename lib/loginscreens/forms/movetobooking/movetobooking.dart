import 'package:flutter/material.dart';
import 'package:pravinhonda/loginscreens/forms/movetobooking/editenquiry.dart';
import 'package:pravinhonda/loginscreens/forms/movetobooking/editexchange.dart';
import 'package:pravinhonda/loginscreens/forms/movetobooking/editfinance.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetobooking extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetobooking({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Movetobooking> createState() => _MovetobookingState();
}

class _MovetobookingState extends State<Movetobooking> {
  bool createenquiry = true;
  bool finance = false;
  bool exchange = false;

  bool financetrue = false;
  bool exchangetrue = false;

  String previousTab = 'enquiry';

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    if(enquiry['purchase_type'] == 'finance' && enquiry['exchange_flag'] == 'yes') {
        financetrue = true;
        exchangetrue = true;
    } else if(enquiry['purchase_type'] != 'finance' && enquiry['exchange_flag'] == 'yes') {
        financetrue = false;
        exchangetrue = true;
    } else if(enquiry['purchase_type'] == 'finance' && enquiry['exchange_flag'] != 'yes') {
        financetrue = true;
        exchangetrue = false;
    } else {
        financetrue = false;
        exchangetrue = false;
    }
  }

  @override
  Widget build(BuildContext context) {
  SizeConfig.init(context);
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          if (exchange == true) {
            setState(() {
              if (previousTab == 'finance') {
                exchange = false;
                finance = true;
                createenquiry = false;
              } else {
                exchange = false;
                finance = false;
                createenquiry = true;
              }
            });
            return;
          }

          if (finance == true) {
            setState(() {
              finance = false;
              createenquiry = true;
              exchange = false;
            });
            return;
          }

          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: appBar(),
          drawer: Customdrawer(),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                createenquiry = true;
                                finance = false;
                                exchange = false;
                              });
                            },
                            constraints: BoxConstraints(),
                            padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                            fillColor: createenquiry ? kred : kwhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              side: BorderSide(
                                color: kgrey
                              )
                            ),
                            child: Text(
                              'Enquiry',
                              style: customtext(
                                fs14,
                                createenquiry ? kwhite : kred,
                                FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.w(10),
                        ),
                        Expanded(
                          child: Opacity(
                            opacity: financetrue == true ? 1 : 0.5,
                            child: IgnorePointer(
                              ignoring: financetrue == true ? false : true,
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    createenquiry = false;
                                    finance = true;
                                    exchange = false;
                                  });
                                },
                                constraints: BoxConstraints(),
                                fillColor: finance ? kred : kwhite,
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'Finance',
                                  style: customtext(
                                    fs14,
                                    finance ? kwhite : kred,
                                    FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.w(10),
                        ),
                        Expanded(
                          child: Opacity(
                            opacity: exchangetrue == true ? 1 : 0.5,
                            child: IgnorePointer(
                              ignoring: exchangetrue == true ? false : true,
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    createenquiry = false;
                                    finance = false;
                                    exchange = true;
                                  });
                                },
                                constraints: BoxConstraints(),
                                fillColor: exchange ? kred : kwhite,
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'Exchange',
                                  style: customtext(
                                    fs14,
                                    exchange ? kwhite : kred,
                                    FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(20)),
                  if(createenquiry == true)
                  EditenquiryMB(
                    financeselected: () {
                      setState(() {
                        previousTab = 'enquiry';
                        financetrue = true;
                        createenquiry = false;
                        finance = true;
                        exchange = false;
                      });
                    },
                    exchangeselected: () {
                      setState(() {
                        previousTab = 'enquiry';
                        exchangetrue = true;
                        createenquiry = false;
                        finance = false;
                        exchange = true;
                      });
                    },
                    enquiryid: widget.enquiryid,
                    apiResponse: widget.apiResponse,
                    edit: edit(),
                  ),
                  if(finance == true)
                  Expanded(
                    child: EditfinanceMB(
                      exchangeflag: 'Yes',
                      enquiryid: widget.enquiryid,
                      exchangeselected: () {
                        setState(() {
                          previousTab = 'finance';
                          exchangetrue = true;
                          createenquiry = false;
                          finance = false;
                          exchange = true;
                        });
                      },
                      edit: edit(),
                      oldapiResponse: widget.apiResponse,
                      apiResponse: widget.apiResponse,
                    ),
                  ),
                  if(exchange == true)
                  EditexchangeMB(
                    enquiryid: widget.enquiryid,
                    apiResponse: widget.apiResponse,
                    edit: edit(),
                  )
                ],
              ),
              Positioned(
                right: 10,
                top: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onEditpressed = !onEditpressed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onEditpressed ? kwhite : klightgrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 2,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(12),
                      vertical: SizeConfig.h(2)
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: kblack,
                      ),
                      SizedBox(width: SizeConfig.w(3)),
                      Text(
                        'Edit',
                        style: textmedium12,
                      )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}