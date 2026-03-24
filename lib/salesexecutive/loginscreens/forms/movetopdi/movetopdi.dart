import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editexchange.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetobooking/editfinance.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/movetopdi/editbooking.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetopdi extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetopdi({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Movetopdi> createState() => _MovetopdiState();
}

class _MovetopdiState extends State<Movetopdi> {
  bool createenquiry = true;
  bool finance = false;
  bool exchange = false;
  bool booking = false;

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

  Future<void> vehicleStockCheckUp() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/sales-pdi-approval/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'model_name' : modelName,
          'model_color' : modelColor
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation(initialIndex: 1)
          )
        );
        
      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      print('Error: $e');
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
                      'Move to Pdi',
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
                                booking = false;
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
                                    booking = false;
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
                                    booking = false;
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
                        SizedBox(
                          width: SizeConfig.w(10),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                createenquiry = false;
                                finance = false;
                                exchange = false;
                                booking = true;
                              });
                            },
                            constraints: BoxConstraints(),
                            fillColor: booking ? kred : kwhite,
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
                                'Booking',
                                style: customtext(
                                  fs14,
                                  booking ? kwhite : kred,
                                  FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        )
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
                            edit: edit(),
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
                            edit: edit(),
                            oldapiResponse: widget.apiResponse,
                            apiResponse: widget.apiResponse,
                          ),
                          if(exchange == true)
                          EditexchangeMB(
                            enquiryid: widget.enquiryid,
                            apiResponse: widget.apiResponse,
                            edit: edit(),
                          ),
                          if(booking == true)
                          Editbooking(
                            enquiryid: widget.enquiryid,
                            apiResponse: widget.apiResponse,
                          )
                        ],
                      ),
                    ),
                  ),
                  if(isEdited == false)
                  button(
                    'Move to Pdi',
                    () {
                      // showVehicleStockPopup(context);
                      vehicleStockCheckUp();
                    }
                  )
                ],
              ),
              Positioned(
                right: 10,
                top: 20,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onEditpressed = !onEditpressed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onEditpressed ? kwhite : kred,
                    shape: CircleBorder(),
                    elevation: 2,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(12),
                      vertical: SizeConfig.h(2)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 28,
                          color: onEditpressed ? kblack : kwhite,
                        ),
                        SizedBox(width: SizeConfig.w(3)),
                        Text(
                          'Edit',
                          style: customtext(
                            fs8,
                            onEditpressed ? kblack : kwhite
                          ),
                        )
                      ],
                    ),
                  )
                ),
              )
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