import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Filterscreen.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewbookingyes.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/styles.dart';

class Taskmenu extends StatefulWidget {
  const Taskmenu({super.key});

  @override
  State<Taskmenu> createState() => _TaskmenuState();
}

class _TaskmenuState extends State<Taskmenu> {
  List<dynamic> alldata = [];
  bool isLoading = true;

  Map<String, dynamic>? appliedFilters;

  @override
  void initState() {
    super.initState();
    alldataenquiry();
  }

  List<dynamic> filteredData = [];

  String convertToApiDate(String input) {
    try {
      final parsed = DateFormat("dd-MM-yyyy").parseStrict(input);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (e) {
      return "";
    }
  }

  void applyFilters(Map<String, dynamic> filters) {
    filteredData = alldata.where((item) {

      /// FOLLOW UP DATE (UI → API format)
      if ((filters["date"] ?? "").toString().isNotEmpty) {
        final formattedDate = convertToApiDate(filters["date"]);

        if (item["follow_up_date"]
                .toString()
                .trim() !=
            formattedDate.trim()) {
          return false;
        }
      }

      /// CITY
      if (filters["city"] != null &&
          item["city"] != filters["city"]) {
        return false;
      }

      /// DISTRICT
      if (filters["district"] != null &&
          item["district"] != filters["district"]) {
        return false;
      }

      /// MODEL
      if (filters["model"] != null &&
          item["model_name"] != filters["model"]) {
        return false;
      }

      /// COLOR
      if (filters["color"] != null &&
          item["model_color"] != filters["color"]) {
        return false;
      }

      /// MOBILE
      if ((filters["mobile"] ?? "").isNotEmpty &&
          item["customer_contact_number"]
                  .toString()
                  .contains(filters["mobile"]) ==
              false) {
        return false;
      }

      /// FINANCE
      if (filters["finance"] != null &&
          (filters["finance"] as List).isNotEmpty &&
          !(filters["finance"] as List).contains(item["purchase_type"])) {
        return false;
      }

      /// EXCHANGE
      if (filters["exchange"] != null &&
          (filters["exchange"] as List).isNotEmpty &&
          !(filters["exchange"] as List).contains(item["exchange_flag"])) {
        return false;
      }

      /// TEST RIDE
      if (filters["testRide"] != null &&
          (filters["testRide"] as List).isNotEmpty &&
          !(filters["testRide"] as List).contains(item["test_ride"])) {
        return false;
      }

      /// GENDER
      if (filters["gender"] != null &&
          (filters["gender"] as List).isNotEmpty &&
          !(filters["gender"] as List).contains(item["gender"])) {
        return false;
      }
      
      /// STATUS (case-insensitive)
      if (filters["status"] != null &&
          (filters["status"] as List).isNotEmpty) {

        final selectedStatuses = (filters["status"] as List)
            .map((e) => e.toString().toLowerCase().trim())
            .toList();

        final itemStatus = item["status"]
            .toString()
            .toLowerCase()
            .trim();

        if (!selectedStatuses.contains(itemStatus)) {
          return false;
        }
      }

      return true;
    }).toList();

    setState(() {});
  }

  Future<void> alldataenquiry() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/my-enquiries');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    // Clear old data before calling API
    setState(() {
      alldata = [];
      isLoading = true;
    });

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
        final List<dynamic> dataList =
            (responseData['data'] as List<dynamic>?) ?? [];

        setState(() {
          alldata = dataList;
          isLoading = false;
        });

      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
    (appliedFilters == null || appliedFilters!.isEmpty)
        ? alldata
        : filteredData;

    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                'Tasks',
                style: customtext(
                  fs18,
                  kred,
                  FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            filterbutton(
              () async {
                final filters = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(
                      height: screenHeight * 0.7,
                      child: Filterscreen(
                        initialFilters: appliedFilters, // 🔥 THIS FIXES RESET ISSUE
                      ),
                    );
                  },
                );

                if (filters != null) {
                  appliedFilters = filters;
                  applyFilters(filters);
                }
              }
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: isLoading
                ? Center(child: CircularProgressIndicator(color: kred))
                : displayList.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final data = displayList[index];
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
                              MaterialPageRoute(
                                builder: (context) => ViewBookingyes(
                                  enquiryid: data['enquiry_id'] ?? 0,
                                  apiResponse: data,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

filterbutton(VoidCallback onTap) => RawMaterialButton(
  onPressed: onTap,
  fillColor: kred,
  constraints: BoxConstraints.tightFor(
    height: 56,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  child: Padding(
    padding: const EdgeInsets.only(left: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.filter_list,
            color: kred,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Center(
            child: Text(
              'Filters',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16
              ),
            ),
          ),
        ),
      ],
    ),
  )
);