import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/username_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewform.dart';
import 'package:pravinhonda/login.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool recentactivity = true;
  bool todolist = false;

  String? totalenquiry;
  String? openenquiry;
  String? allbooking;
  String? lostcustomer;

  @override
  void initState() {
    super.initState();
    fetchtotalenquiry();
  }

  Future<void> fetchtotalenquiry() async {
    final totalenquiryurl = Uri.parse('https://app.pravinhonda.com/api/total-count');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        totalenquiryurl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        setState(() {
          totalenquiry = responseData['total_enquiry'].toString();
          openenquiry = responseData['enquiry count'].toString();
          allbooking = responseData['booking count'].toString();
          lostcustomer = responseData['lost customer count'].toString();
        });
      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocusername = BlocProvider.of<UsernameCubit>(context).state.username;
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.h(20)
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(10),
                  vertical: SizeConfig.h(10),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(SizeConfig.w(10)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome $blocusername',
                            style: customtext(fs12, kred, FontWeight.w600),
                          ),
                          SizedBox(height: SizeConfig.h(5)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Monthly Target : 20', style: textmedium10),
                          ),
                          SizedBox(height: SizeConfig.h(3)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Target Achieved : 12', style: textmedium10),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceRadius: SizeConfig.w(20),
                                      sectionsSpace: 0,
                                      startDegreeOffset: 270,
                                      sections: _showingSections(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.h(4)),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Daily Conversion%',
                                    style: textmedium8
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.w(10),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceRadius: SizeConfig.w(20),
                                      sectionsSpace: 0,
                                      startDegreeOffset: 270,
                                      sections: _showingSections(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.h(4)),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Monthly Conversion%',
                                    style: textmedium8
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.h(10),
              ),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    rowdetails(
                      totalenquiry ?? '0',
                      'Total\nEnquiry',
                      kred
                    ),
                    rowdetails(
                      openenquiry ?? '0',
                      'Open\nEnquiry',
                      kyellow
                    ),
                    rowdetails(
                      allbooking ?? '0',
                      'Booking',
                      klightgreen
                    ),
                    // rowdetails(
                    //   '34',
                    //   'Delivered',
                    //   kdarkblue
                    // ),
                    rowdetails(
                      lostcustomer ?? '0',
                      'Lost\nCustomer',
                      kpurple
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.h(10),
              ),
        
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kgrey
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.h(8),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    recentactivity = true;
                                    todolist = false;
                                  });
                                },
                                constraints: BoxConstraints(),
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                fillColor: recentactivity ? kred : kwhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'Recent Activities',
                                  style: customtext(
                                    fs14,
                                    recentactivity ? kwhite : kred,
                                    FontWeight.w500
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
                                    recentactivity = false;
                                    todolist = true;
                                  });
                                },
                                constraints: BoxConstraints(),
                                fillColor: todolist ? kred : kwhite,
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'To Do List',
                                  style: customtext(
                                    fs14,
                                    todolist ? kwhite : kred,
                                    FontWeight.w500
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.h(5)
                        ),
                        Expanded(
                          child: recentactivity
                              ? Recentactivity()
                              : Todolist(),
                        ),
                        SizedBox(
                          height: SizeConfig.h(5)
                        )
                      ],
                    ),
                  )
                ),
              ),
              SizedBox(
                height: SizeConfig.h(20)
              )
            ],
          ),
        ),
      )
    );
  }

  List<PieChartSectionData> _showingSections() {
    List<double> values = [50, 30, 20];
    List<Color> colors = [Colors.blue, Colors.greenAccent, Colors.orangeAccent];

    return List.generate(values.length, (i) {
      final double fontSize = fs6;
      final double radius = 15;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: '${values[i]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget rowdetails(
    String count,
    String title,
    Color color
  ) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.w(5)),
      child: RawMaterialButton(
        onPressed: () {},
        constraints: BoxConstraints.tightFor(
          height: SizeConfig.h(70),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          side: BorderSide(
            color: kgrey
          )
        ),
        padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: customtext(
                fs18,
                color,
                FontWeight.bold
              ),
            ),
            SizedBox(height: SizeConfig.h(2)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: customtext(
                fs12,
                color,
                FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recentactivity extends StatefulWidget {
  const Recentactivity({super.key});

  @override
  State<Recentactivity> createState() => _RecentactivityState();
}

class _RecentactivityState extends State<Recentactivity> {
  List<dynamic> alldata = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRecent();
  }

  Future<void> fetchRecent() async {
    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final url = Uri.parse(
        "https://app.pravinhonda.com/api/recent-activities");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        final List<dynamic> dataList = (responseData['data'] as List<dynamic>?) ?? [];

        final List<dynamic> filteredList = dataList
        .where((item) => item['status_code']?.toString() == "1")
        .toList();

        setState(() {
          alldata = filteredList;
          loading = false;
        });

      } else if(response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');

        BlocProvider.of<AuthCubit>(context).cleartoken();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
        );

        Fluttertoast.showToast(msg: responseData['message']);
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(40)),
        child: Center(
          child: CircularProgressIndicator(
            color: kred,
        )),
      );
    }
    return alldata.isEmpty ? Center(
      child: Text(
        'No Recent Activities',
        style: customtext(fs12, kred, FontWeight.bold),
      ),
    ) : ListView.builder(
      itemCount: alldata.length,
      itemBuilder: (context, index) {
        final data = alldata[index];
        final details = data ?? {};
        return Hondabox(
          enquiryid: details['enquiry_id'] ?? 0,
          id: details['enquiry_id']?.toString() ?? '',
          customername: details['customer_name']?.toString() ?? '',
          contactnumber: details['customer_contact_number']?.toString() ?? '',
          status: details['status']?.toString() ?? '',
          cashfinance: details['purchase_type']?.toString() ?? '',
          textride: details['test_ride']?.toString() ?? '',
          exchange: details['exchange_flag']?.toString() ?? '',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Viewform(
                enquiryid: details['enquiry_id'] ?? 0,
                apiResponse: details,
                )
              )
            );
          }
        );
      },
    );
  }
}

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List<dynamic> alldata = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRecent();
  }

  Future<void> fetchRecent() async {
    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final url = Uri.parse(
        "https://app.pravinhonda.com/api/todolist");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> dataList = (responseData['data'] as List<dynamic>?) ?? [];

        final List<dynamic> filteredList = dataList
          .where((item) => item['status_code']?.toString() == "1")
          .toList();

        setState(() {
          alldata = filteredList;
          loading = false;
        });
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(40)),
        child: Center(
          child: CircularProgressIndicator(
            color: kred,
        )),
      );
    }
    return alldata.isEmpty ? Center(
      child: Text(
        'No To-Do Items for Today',
        style: customtext(fs12, kred, FontWeight.bold),
      ),
    ) : ListView.builder(
      itemCount: alldata.length,
      itemBuilder: (context, index) {
        final data = alldata[index];
        return Hondabox(
          enquiryid: data['enquiry_id'] ?? 0,
          id: data['enquiry_id']?.toString() ?? '',
          customername: data['customer_name']?.toString() ?? '',
          contactnumber: data['customer_contact_number']?.toString() ?? '',
          status: data['status']?.toString() ?? '',
          cashfinance: data['purchase_type']?.toString() ?? '',
          textride: data['test_ride']?.toString() ?? '',
          exchange: data['exchange_flag']?.toString() ?? '',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Viewform(
                enquiryid: data['enquiry_id'] ?? 0,
                apiResponse: data,
                )
              )
            );
          }
        );
      },
    );
  }
}
