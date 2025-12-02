import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/editpages/movetobooking.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  List<dynamic> alldata = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? nextPageUrl;
  final ScrollController _sc = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sc.addListener(_onScroll);
    _fetchPage();
  }

  @override
  void dispose() {
    _sc.removeListener(_onScroll);
    _sc.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_sc.hasClients || isLoadingMore || !hasMore) return;
    final thresholdPixels = 200;
    final maxScroll = _sc.position.maxScrollExtent;
    final currentScroll = _sc.position.pixels;
    if (maxScroll - currentScroll <= thresholdPixels) {
      _fetchPage(url: nextPageUrl);
    }
  }

  Future<void> _fetchPage({String? url}) async {
    try {
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/enquiries');

      if (alldata.isEmpty && !isLoading) {
        setState(() {
          isLoading = true;
        });
      } else if (alldata.isNotEmpty) {
        setState(() {
          isLoadingMore = true;
        });
      }

      final token = BlocProvider.of<AuthCubit>(context).state.token;

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> dataList = (responseData['data'] as List<dynamic>?) ?? [];

        final List<dynamic> filteredList = dataList
        .where((item) => item['status_code']?.toString() == "1")
        .toList();

        setState(() {
          if (url == null) {
            alldata = filteredList;
          } else {
            alldata.addAll(dataList);
          }

          nextPageUrl = responseData['next_page_url'] as String?;

          hasMore = nextPageUrl != null;

          isLoading = false;
          isLoadingMore = false;
        });
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
          isLoadingMore = false;
          hasMore = false;
        });
      }
    } catch (e) {
      print('Error fetching enquiries: $e');
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      nextPageUrl = null;
      hasMore = true;
      alldata = [];
      isLoading = true;
      isLoadingMore = false;
    });
    await _fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: isLoading && alldata.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: kred,
                ),
              )
            : RefreshIndicator(
              color: kred,
              backgroundColor: kwhite,
              onRefresh: _refresh,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.h(20)),
                      Center(
                        child: Text(
                          'Enquiry',
                          style: customtext(fs18, kred, FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(20)),
                      search(searchController),
                      SizedBox(height: SizeConfig.h(10)),
                      Expanded(
                        child: alldata.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: SizeConfig.h(80)),
                                  Center(
                                    child: Text(
                                      'No enquiries found.',
                                      style: text12,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                controller: _sc,
                                itemCount: alldata.length + (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == alldata.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(16)),
                                      child: Center(
                                        child: SizedBox(
                                          height: SizeConfig.h(24),
                                          width: SizeConfig.h(24),
                                          child: CircularProgressIndicator(strokeWidth: 2, color: kred),
                                        ),
                                      ),
                                    );
                                  }
                                      
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
                                      final selected = alldata[index];
                                      print(selected);
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Movetobooking(
                                            enquiryid: data['enquiry_id'] ?? 0,
                                            apiResponse: selected
                                          )
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}
