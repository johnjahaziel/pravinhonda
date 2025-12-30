import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewform.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  bool waitingforapproval = true;
  bool bookinglist = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          waitingforapproval = true;
                          bookinglist = false;
                        });
                      },
                      constraints: BoxConstraints(),
                      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                      fillColor: waitingforapproval ? kred : kwhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(
                          color: kgrey
                        )
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Waiting for Approval',
                          style: customtext(
                            fs14,
                            waitingforapproval ? kwhite : kred,
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
                          waitingforapproval = false;
                          bookinglist = true;
                        });
                      },
                      constraints: BoxConstraints(),
                      fillColor: bookinglist ? kred : kwhite,
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
                          'Booking List',
                          style: customtext(
                            fs14,
                            bookinglist ? kwhite : kred,
                            FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(waitingforapproval == true)
            Expanded(
              child: Waitingforapproval()
            ),
            if(bookinglist == true)
            Expanded(
              child: Bookinglist()
            )
          ],
        )
      ),
    );
  }
}

class Bookinglist extends StatefulWidget {
  const Bookinglist({super.key});

  @override
  State<Bookinglist> createState() => _BookinglistState();
}

class _BookinglistState extends State<Bookinglist> {
  List<dynamic> _allData = [];
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
    searchController.addListener(_onSearchChanged);
    _fetchPage();
  }

  @override
  void dispose() {
    _sc.removeListener(_onScroll);
    _sc.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
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

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        alldata = List<dynamic>.from(_allData);
      } else {
        alldata = _allData.where((item) {
          final name = (item['customer_name'] ?? '').toString().toLowerCase();
          final mobile = (item['customer_contact_number'] ?? '').toString().toLowerCase();
          final modelName = (item['model_name'] ?? '').toString().toLowerCase();
          final modelVariant = (item['model_variant'] ?? '').toString().toLowerCase();
          final modelColor = (item['model_color'] ?? '').toString().toLowerCase();

          return name.contains(query) ||
              mobile.contains(query) ||
              modelName.contains(query) ||
              modelVariant.contains(query) ||
              modelColor.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchPage({String? url}) async {
    try {
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/booking');

      if (_allData.isEmpty && !isLoading) {
        setState(() {
          isLoading = true;
        });
      } else if (_allData.isNotEmpty) {
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

        // final List<dynamic> filteredList = dataList
        // .where((item) => item['status_code']?.toString() == "2")
        // .toList();

        final List<dynamic> filteredList = dataList;

        setState(() {
          if (url == null) {
            _allData = filteredList;
          } else {
            _allData.addAll(filteredList);
          }

          final query = searchController.text.trim().toLowerCase();
          if (query.isEmpty) {
            alldata = List<dynamic>.from(_allData);
          } else {
            alldata = _allData.where((item) {
              final name = (item['customer_name'] ?? '').toString().toLowerCase();
              final mobile = (item['customer_contact_number'] ?? '').toString().toLowerCase();
              final modelName = (item['model_name'] ?? '').toString().toLowerCase();
              final modelVariant = (item['model_variant'] ?? '').toString().toLowerCase();
              final modelColor = (item['model_color'] ?? '').toString().toLowerCase();

              return name.contains(query) ||
                  mobile.contains(query) ||
                  modelName.contains(query) ||
                  modelVariant.contains(query) ||
                  modelColor.contains(query);
            }).toList();
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
      _allData = [];
      alldata = [];
      isLoading = true;
      isLoadingMore = false;
    });
    await _fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading && alldata.isEmpty
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
                'Bookings',
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
                            'No Bookings found.',
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Waitingforapproval extends StatefulWidget {
  const Waitingforapproval({super.key});

  @override
  State<Waitingforapproval> createState() => _WaitingforapprovalState();
}

class _WaitingforapprovalState extends State<Waitingforapproval> {
  List<dynamic> _allData = [];
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
    searchController.addListener(_onSearchChanged);
    _fetchPage();
  }

  @override
  void dispose() {
    _sc.removeListener(_onScroll);
    _sc.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
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

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        alldata = List<dynamic>.from(_allData);
      } else {
        alldata = _allData.where((item) {
          final name = (item['customer_name'] ?? '').toString().toLowerCase();
          final mobile = (item['customer_contact_number'] ?? '').toString().toLowerCase();
          final modelName = (item['model_name'] ?? '').toString().toLowerCase();
          final modelVariant = (item['model_variant'] ?? '').toString().toLowerCase();
          final modelColor = (item['model_color'] ?? '').toString().toLowerCase();

          return name.contains(query) ||
              mobile.contains(query) ||
              modelName.contains(query) ||
              modelVariant.contains(query) ||
              modelColor.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchPage({String? url}) async {
    try {
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/waiting-for-approval');

      if (_allData.isEmpty && !isLoading) {
        setState(() {
          isLoading = true;
        });
      } else if (_allData.isNotEmpty) {
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

        final List<dynamic> filteredList = dataList;

        setState(() {
          if (url == null) {
            _allData = filteredList;
          } else {
            _allData.addAll(filteredList);
          }

          final query = searchController.text.trim().toLowerCase();
          if (query.isEmpty) {
            alldata = List<dynamic>.from(_allData);
          } else {
            alldata = _allData.where((item) {
              final name = (item['customer_name'] ?? '').toString().toLowerCase();
              final mobile = (item['customer_contact_number'] ?? '').toString().toLowerCase();
              final modelName = (item['model_name'] ?? '').toString().toLowerCase();
              final modelVariant = (item['model_variant'] ?? '').toString().toLowerCase();
              final modelColor = (item['model_color'] ?? '').toString().toLowerCase();

              return name.contains(query) ||
                  mobile.contains(query) ||
                  modelName.contains(query) ||
                  modelVariant.contains(query) ||
                  modelColor.contains(query);
            }).toList();
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
      _allData = [];
      alldata = [];
      isLoading = true;
      isLoadingMore = false;
    });
    await _fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading && alldata.isEmpty
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
                'Waiting For Approval',
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
                            'No Data found.',
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}