import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pravinhonda/bloc/enquiry_id_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/creating/addenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/creating/addexchange.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/creating/addfinance.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Createenquiry extends StatefulWidget {
  const Createenquiry({super.key});

  @override
  State<Createenquiry> createState() => _CreateenquiryState();
}

class _CreateenquiryState extends State<Createenquiry> {
  bool createenquiry = true;
  bool finance = false;
  bool exchange = false;

  bool financetrue = false;
  bool exchangetrue = false;

  String previousTab = 'enquiry';

  @override
  Widget build(BuildContext context) {
    String enquiryid = BlocProvider.of<EnquiryCubit>(context).state.enquiryid ?? '';
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.h(10)),
              back(context, Navigation(initialIndex: 0)),
              Center(
                child: Text(
                  'Create Enquiry',
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
              SizedBox(height: SizeConfig.h(10)),
              if(createenquiry == true)
              Addenquiry(
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
              ),
              if(finance == true)
              Addfinance(
                exchangeflag: 'Yes',
                enquiryid: enquiryid,
                exchangeselected: () {
                  setState(() {
                    previousTab = 'finance';
                    exchangetrue = true;
                    createenquiry = false;
                    finance = false;
                    exchange = true;
                  });
                },
              ),
              if(exchange == true)
              Addexchange(
                enquiryid: enquiryid,
              )
            ],
          ),
        ),
      ),
    );
  }
}

