import 'package:flutter/material.dart';
import 'package:pravinhonda/pdimanager/NavigationPdi.dart';
import 'package:pravinhonda/rtomanager/mainscreens/readyforegisform.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewexchange.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewfinace.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetoreadyforregis extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetoreadyforregis({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Movetoreadyforregis> createState() => _MovetoreadyforregisState();
}

class _MovetoreadyforregisState extends State<Movetoreadyforregis> {
  bool readyforregis = true;
  bool createenquiry = false;
  bool finance = false;
  bool exchange = false;

  bool bookingtrue = true;

  bool financetrue = false;
  bool exchangetrue = false;

  String previousTab = 'enquiry';

  bool isEdited = false;

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
    return PopScope(
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
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(),
          drawer: Customdrawer(),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.h(10)),
                  back(context, NavigationPdi(initialIndex: 3)),
                  Center(
                    child: Text(
                      'Ready for Registration',
                      style: customtext(
                        fs18,
                        kred,
                        FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(15)),
                  Expanded(
                    child: Column(
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
                                      createenquiry = false;
                                      finance = false;
                                      exchange = false;
                                      readyforregis = true;
                                    });
                                  },
                                  constraints: BoxConstraints(),
                                  fillColor: readyforregis ? kred : kwhite,
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(10),
                                    side: BorderSide(
                                      color: kgrey
                                    )
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Details',
                                      style: customtext(
                                        fs14,
                                        readyforregis ? kwhite : kred,
                                        FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.w(10),
                              ),
                              Expanded(
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      createenquiry = true;
                                      finance = false;
                                      exchange = false;
                                      readyforregis = false;
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
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
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
                                          readyforregis = false;
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
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
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
                                          readyforregis = false;
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
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
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
                                ),
                              ),
                            ]
                          ),
                        ),
                        SizedBox(height: SizeConfig.h(10)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if(readyforregis == true)
                                Readyforegisform(
                                  enquiryid: widget.enquiryid,
                                  apiResponse: widget.apiResponse,
                                ),
                                if(createenquiry == true)
                                Viewenquiry(
                                  apiResponse: widget.apiResponse,
                                ),
                                if(finance == true)
                                Viewfinace(
                                  apiResponse: widget.apiResponse,
                                ),
                                if(exchange == true)
                                Viewexchange(
                                  apiResponse: widget.apiResponse,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}