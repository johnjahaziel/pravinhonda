import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/financemenu/financemenu.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewbookingyes.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Financemenu extends StatefulWidget {
  const Financemenu({super.key});

  @override
  State<Financemenu> createState() => _FinancemenuState();
}

class _FinancemenuState extends State<Financemenu> {

  bool financepending = true;
  bool financedelivery = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
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
                          financepending = true;
                          financedelivery = false;
                        });
                      },
                      constraints: BoxConstraints(),
                      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                      fillColor: financepending ? kred : kwhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(
                          color: kgrey
                        )
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Pending',
                          style: customtext(
                            fs14,
                            financepending ? kwhite : kred,
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
                          financepending = false;
                          financedelivery = true;
                        });
                      },
                      constraints: BoxConstraints(),
                      fillColor: financedelivery ? kred : kwhite,
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
                          'Delivery',
                          style: customtext(
                            fs14,
                            financedelivery ? kwhite : kred,
                            FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(financepending == true)
            Expanded(
              child: Financepending()
            ),
            if(financedelivery == true)
            Expanded(
              child: Financedelivery()
            )
          ],
        )
      ),
    );
  }
}

class Financedelivery extends StatefulWidget {
  const Financedelivery({super.key});

  @override
  State<Financedelivery> createState() => _FinancedeliveryState();
}

class _FinancedeliveryState extends State<Financedelivery> {
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
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/finance-delivery-list');

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
            SizedBox(height: SizeConfig.h(10)),
            Center(
              child: Text(
                'Finance',
                style: customtext(
                  fs18,
                  kred,
                  FontWeight.bold
                ),
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
                            'No data found.',
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
                        return FinanceMenu(
                          enquiryid: data['enquiry_id'] ?? 0,
                          id: data['enquiry_id']?.toString() ?? '',
                          customername: data['customer_name']?.toString() ?? '',
                          highrisenumber: data['high_rise_number']?.toString() ?? '',
                          finance: data['finance']?.toString() ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewBookingyes(
                                enquiryid: data['enquiry_id'] ?? '',
                                apiResponse: data,
                                )
                              )
                            );
                          },
                          model: data['model_name']?.toString() ?? '',
                          // variant: data['model_variant']?.toString() ?? '',
                          color: data['model_color']?.toString() ?? '',
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

class Financepending extends StatefulWidget {
  const Financepending({super.key});

  @override
  State<Financepending> createState() => _FinancependingState();
}

class _FinancependingState extends State<Financepending> {
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
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/finance-pending-list');

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
            SizedBox(height: SizeConfig.h(10)),
            Center(
              child: Text(
                'Finance',
                style: customtext(
                  fs18,
                  kred,
                  FontWeight.bold
                ),
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
                        return FinanceMenu(
                          enquiryid: data['enquiry_id'] ?? 0,
                          id: data['enquiry_id']?.toString() ?? '',
                          customername: data['customer_name']?.toString() ?? '',
                          highrisenumber: data['high_rise_number']?.toString() ?? '',
                          finance: data['finance']?.toString() ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FinanceMenuUpdate(
                                enquiryid: data['enquiry_id'] ?? '',
                                apiResponse: data,
                                )
                              )
                            );
                          },
                          model: data['model_name']?.toString() ?? '',
                          // variant: data['model_variant']?.toString() ?? '',
                          color: data['model_color']?.toString() ?? '',
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