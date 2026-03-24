import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/number_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/creating/createenquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewform.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/booking.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/delivery.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/enquiry.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/homescreen.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/mainscreens/pdi.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Navigation extends StatefulWidget {
  final int initialIndex;
  const Navigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            Homescreen(),
            Enquiry(),
            Booking(),
            Pdi(),
            Delivery(),
          ],
        ),
        floatingActionButton: SizedBox(
          height: SizeConfig.h(40),
          width: SizeConfig.w(40),
          child: FloatingActionButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Createenquiry())
              // );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SameMobile(),
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
        bottomNavigationBar: SizedBox(
          height: SizeConfig.h(55),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: kred,
            unselectedItemColor: const Color.fromARGB(255, 50, 50, 50),
            selectedFontSize: fs10,
            unselectedFontSize:fs8,
            backgroundColor: kwhite,
            unselectedLabelStyle: TextStyle(
              color: kblack,
            ),
            onTap: (index) {
              setState(() {
                currentIndex = index;
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_quote_outlined),
                label: 'Enquiry',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_outlined),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.handyman_outlined),
                label: 'PDI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trolley),
                label: 'Delivered',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SameMobile extends StatefulWidget {
  const SameMobile({super.key});

  @override
  State<SameMobile> createState() => _SameMobileState();
}

class _SameMobileState extends State<SameMobile> {
  bool isLoading = false;

  String mobilenumbere = '';

  final TextEditingController mobileController = TextEditingController();

  Future<void> updateMobileNumberAPI(String mobile) async {
    final url = Uri.parse('https://app.pravinhonda.com/api/sales/mobile-count?mobile=$mobile');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        print('Mobile: $responseData');

        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.pop(context);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => MobileResponse(
            apiResponse: responseData,
          ),
        );
      } else if (response.statusCode == 200 && responseData['status'] == false) {
        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Createenquiry()
          )
        );

        BlocProvider.of<NumberCubit>(context).setnumber(mobile);
        
      } else if (response.statusCode == 500) {

        Fluttertoast.showToast(msg: responseData['message']);

        setState(() {
          mobilenumbere = responseData['error'];
        });

      } else {
        print('Failed to update mobile number. Status code: ${response.statusCode}');

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
        'Mobile Number',
        style: customtext(fs16, kblack, FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please enter your mobile number to proceed further.',
            style: customtext(fs14, kblack, FontWeight.w400),
          ),
          const SizedBox(height: 20),

          textfieldy(
            'Enter Mobile Number',
            mobileController,
            numpad: true
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

class MobileResponse extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const MobileResponse({
    super.key,
    required this.apiResponse,
  });

  @override
  State<MobileResponse> createState() => _MobileResponseState();
}

class _MobileResponseState extends State<MobileResponse> {
  String name = '';
  String number = '';
  String attendedBy = '';
  String branchName = '';

  String enquiryId = '';
  String customerName = '';
  String modelName = '';
  String variant = '';
  String color = '';
  String testRide = '';
  String createdAt = '';

  bool showMore = false;
  List<dynamic> enquiryList = [];

  @override
  void initState() {
    super.initState();
    _initControllersFromResponse(widget.apiResponse);
  }

  void _initControllersFromResponse(Map<String, dynamic> resp) {
    final data = resp['data'];
    enquiryList = data['details'] ?? [];

    if (enquiryList.isNotEmpty) {
      final first = enquiryList[0];

      enquiryId = first['enquiry_id'] ?? 0;
      customerName = first['customer_name'] ?? '';
      modelName = first['model_name'] ?? '';
      variant = first['model_variant'] ?? '';
      color = first['model_color'] ?? '';
      testRide = first['test_ride'] ?? '';
      createdAt = first['created_at'] ?? '';

      attendedBy = first['name'] ?? '';
      branchName = first['branch_name'] ?? '';
      name = customerName;
    }

    number = data['customer_contact_number'] ?? '';
    setState(() {});
  }

  String formatDateTime(String iso) {
    if (iso.isEmpty) return '-';
    final dt = DateTime.parse(iso).toLocal();
    return '${dt.day.toString().padLeft(2, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
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
                padding: EdgeInsets.only(top: SizeConfig.h(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : $name",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : $number",
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
          SizedBox(height: SizeConfig.h(5)),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Attended by : $attendedBy",
                  style: textmedium12,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Branch : $branchName",
                    style: textmedium12,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          SizedBox(
            height: showMore ? SizeConfig.h(200) : SizeConfig.h(110),
            child: ListView.builder(
              physics: showMore
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: showMore ? enquiryList.length : 1,
              itemBuilder: (context, index) {
                final item = enquiryList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Viewform(
                            enquiryid: item['enquiry_id'],
                            apiResponse: item,
                          ),
                        ),
                      );
                    },
                    constraints: const BoxConstraints.tightFor(width: double.infinity),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enquiry ID : ${item['enquiry_id']}',
                                style: textmedium12.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Customer : ${item['customer_name'] ?? '-'}',
                                style: textmedium12,
                              ),
                              Text(
                                'Model : ${item['model_name']} | ${item['model_variant']} | ${item['model_color']}',
                                style: textmedium12,
                              ),
                              Text(
                                'Test Ride : ${(item['test_ride'] ?? '').toUpperCase()}',
                                style: textmedium12,
                              ),
                              Text(
                                'Date : ${formatDateTime(item['created_at'] ?? '')}',
                                style: textmedium12.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: SizeConfig.h(5)),
          InkWell(
            onTap: () {
              setState(() {
                showMore = !showMore;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.h(4),
                horizontal: SizeConfig.w(10),
              ),
              child: Text(
                showMore ? 'Show Less' : 'Show More',
                style: customtext(
                  fs10,
                  const Color.fromARGB(255, 22, 95, 154),
                  FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          SizedBox(height: SizeConfig.h(10)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Are you sure you want to create new enquiry?",
              style: textmedium14,
            ),
          ),
          SizedBox(height: SizeConfig.h(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(15), vertical: SizeConfig.h(5)),
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: kred
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Createenquiry()
                    )
                  );

                  BlocProvider.of<NumberCubit>(context).setnumber(number);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(15), vertical: SizeConfig.h(5)),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: kred
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(10)),
        ],
      ),
    );
  }
}