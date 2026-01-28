import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewexchange.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewfinace.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Viewformhrn extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Viewformhrn({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Viewformhrn> createState() => _ViewformhrnState();
}

class _ViewformhrnState extends State<Viewformhrn> {
  bool createenquiry = true;
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Updatehrnpopup(enquiryid: widget.enquiryid),
      );
    });
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
                  SizedBox(height: SizeConfig.h(10)),
                  back(context, Navigation(initialIndex: 0)),
                  Center(
                    child: Text(
                      'View Details',
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
            ],
          ),
          floatingActionButton: SizedBox(
            height: SizeConfig.h(40),
            width: SizeConfig.w(40),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Updatehrnpopup(
                    enquiryid: widget.enquiryid,
                  ),
                );
              },
              shape: CircleBorder(),
              elevation: 10,
              backgroundColor: kred,
              child: Icon(
                Icons.add_circle_outline_rounded,
                color: kwhite,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Updatehrnpopup extends StatefulWidget {
  final int enquiryid;
  const Updatehrnpopup({
    super.key,
    required this.enquiryid
  });

  @override
  State<Updatehrnpopup> createState() => _UpdatehrnpopupState();
}

class _UpdatehrnpopupState extends State<Updatehrnpopup> {
  bool isLoading = false;

  String mobilenumbere = '';

  final TextEditingController mobileController = TextEditingController();

  Future<void> updateMobileNumberAPI(String mobile) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/update-highrise/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'high_rise_number' : mobileController.text
        })
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Mobile: $responseData');

        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.pop(context);

      } else if (response.statusCode == 422) {

        setState(() {
          mobilenumbere = responseData['errors']['high_rise_number'];
        });

      } else {
        print('Failed to update high rise number. Status code: ${response.statusCode}');

        Fluttertoast.showToast(msg: responseData['message']);

        print('Mobile: $responseData');
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kwhite,
      title: Text(
        'High Rise Number',
        style: customtext(fs16, kblack, FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please enter high rise number.',
            style: customtext(fs14, kblack, FontWeight.w400),
          ),
          const SizedBox(height: 20),

          textfieldy(
            'Enter High Rise Number',
            mobileController,
          ),
          if(mobilenumbere.isNotEmpty)
          errormessage(mobilenumbere),

          if (isLoading)
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(child: CircularProgressIndicator(color: kred,)),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: customtext(fs14, kgrey, FontWeight.w500),
          ),
        ),

        TextButton(
          onPressed: isLoading
          ? null
          : () async {
              setState(() => isLoading = true);

              await updateMobileNumberAPI(
                mobileController.text,
              );

              setState(() => isLoading = false);

              // Navigator.pop(context);
            },
          child: Text(
            'SUBMIT',
            style: customtext(fs14, kred, FontWeight.w600),
          ),
        ),
      ],
    );
  }
}