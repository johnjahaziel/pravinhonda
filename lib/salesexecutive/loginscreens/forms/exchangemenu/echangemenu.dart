import 'package:flutter/material.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editexchange.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editfinance.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class ExchangeMenuUpdate extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const ExchangeMenuUpdate({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<ExchangeMenuUpdate> createState() => _ExchangeMenuUpdateState();
}

class _ExchangeMenuUpdateState extends State<ExchangeMenuUpdate> {
  bool createenquiry = false;
  bool finance = false;
  bool exchange = true;

  bool bookingtrue = true;

  bool financetrue = false;
  bool exchangetrue = false;

  String previousTab = 'enquiry';

  late String modelName;
  late String modelColor;

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    modelName = enquiry['model_name'];
    modelColor = enquiry['model_color'];

    print(modelName);
    print(modelColor);

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
    // final apiresponseLocal = BlocProvider.of<ApiresponseCubit>(context).state.apiresponse;
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
                  SizedBox(height: SizeConfig.h(10)),
                  back(context, Navigation(initialIndex: 1)),
                  Center(
                    child: Text(
                      'Finance Update',
                      style: customtext(
                        fs18,
                        kred,
                        FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(15)),
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
                            edit: true,
                            isEditedform: () {
                              setState(() {
                                bookingtrue = false;
                              });
                            },
                          ),
                          if(finance == true)
                          EditfinanceMB(
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
                            edit: true,
                            oldapiResponse: widget.apiResponse,
                            apiResponse: widget.apiResponse,
                          ),
                          if(exchange == true)
                          EditexchangeMB(
                            enquiryid: widget.enquiryid,
                            apiResponse: widget.apiResponse,
                            edit: false,
                          )
                        ],
                      ),
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

  // void showVehicleStockPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 24,
  //           vertical: 20,
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Vehicle In Stock?',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             const SizedBox(height: 20),

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 OutlinedButton(
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => BookingformNo(
  //                         enquiryid: widget.enquiryid
  //                         )
  //                       )
  //                     );
  //                   },
  //                   child: Text(
  //                     'No',
  //                     style: TextStyle(
  //                       fontFamily: 'Poppins',
  //                       color: kred
  //                     ),
  //                   ),
  //                 ),

  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => BookingformYes(
  //                         enquiryid: widget.enquiryid
  //                         )
  //                       )
  //                     );
  //                   },
  //                   child: Text(
  //                     'Yes',
  //                     style: TextStyle(
  //                       fontFamily: 'Poppins',
  //                       color: kred
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}