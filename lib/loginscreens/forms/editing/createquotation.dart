import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/loginscreens/forms/creating/createenquiry.dart';
import 'package:pravinhonda/loginscreens/forms/editing/editenquiry.dart';
import 'package:pravinhonda/loginscreens/forms/editing/editexchange.dart';
import 'package:pravinhonda/loginscreens/forms/editing/editfinance.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Createquotation extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Createquotation({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
  });

  @override
  State<Createquotation> createState() => _CreatequotationState();
}

class _CreatequotationState extends State<Createquotation> {
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
    apiresponseBloc(widget.apiResponse);
  }

  void apiresponseBloc(Map<String,dynamic> response) {
    final apiresponse = widget.apiResponse;
    BlocProvider.of<ApiresponseCubit>(context).setApiresponse(apiresponse);
    _initControllersFromResponse(apiresponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp['data'] ?? {};

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
    final apiresponselocal = BlocProvider.of<ApiresponseCubit>(context).state.apiresponse ?? {};
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
                  back(context, Createenquiry()),
                  Center(
                    child: Text(
                      'Create Quotation',
                      style: customtext(
                        fs20,
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
                  Editenquiry(
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
                    apiResponse: apiresponselocal,
                    edit: edit(),
                  ),
                  if(finance == true)
                  Expanded(
                    child: Editfinance(
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
                      apiResponse: apiresponselocal,
                    ),
                  ),
                  if(exchange == true)
                  Editexchange(
                    enquiryid: widget.enquiryid,
                    apiResponse: apiresponselocal,
                    edit: edit(),
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

class QuotationSuccessPopup extends StatefulWidget {
  final String name;
  final String number;
  final int enquiryid;

  const QuotationSuccessPopup({
    super.key,
    required this.name,
    required this.number,
    required this.enquiryid,
  });

  @override
  State<QuotationSuccessPopup> createState() => _QuotationSuccessPopupState();
}

class _QuotationSuccessPopupState extends State<QuotationSuccessPopup> {

  Future<void> openUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);

    try {
      final bool ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (ok) {
        print('Launched externally: $uri');
        return;
      } else {
        print('launchUrl (external) returned false for $uri');
      }
    } catch (e) {
      print('launchUrl external exception: $e');
    }

    Fluttertoast.showToast(msg: 'Could not open URL');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open: ${uri.toString()}')),
    );
  }

  Future<void> generatepdf() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/pdf/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        openUrl(context, responseData['file']);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
          ((route) => false)
        );

        print(responseData['file']);

      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        print('Failed to generate PDF. Status code: ${response.statusCode}');
        print(response.body);
      }

    } catch (error) {
      print('Error generating PDF: $error');
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
          LottieBuilder(
            height: SizeConfig.h(120),
            width: SizeConfig.w(120),
            lottie: AssetLottie(
              'lottie/completed.json',
            ),
            repeat: false,
          ),
          SizedBox(height: SizeConfig.h(2)),
          Text(
            "Thanks For Creating The Quotation!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Please Download It And\nGive A Hard Copy To The Customer.",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Thank You!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(30)),
          button(
            'Print',
            () {
              generatepdf();
            },
            padding: true
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}

