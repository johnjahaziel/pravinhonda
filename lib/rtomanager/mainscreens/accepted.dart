import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/rtomanager/mainscreens/movetoreadyforregis.dart';
import 'package:pravinhonda/rtomanager/mainscreens/movetortoinsu.dart';
import 'package:pravinhonda/rtomanager/mainscreens/movetortorto.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class AcceptedRTO extends StatefulWidget {
  const AcceptedRTO({super.key});

  @override
  State<AcceptedRTO> createState() => _AcceptedRTOState();
}

class _AcceptedRTOState extends State<AcceptedRTO> {
  bool acceptedinsurance = true;
  bool acceptedrto = false;
  bool acceptedpending = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.h(20)),
        Center(
          child: Text(
            'Accepted',
            style: customtext(fs18, kred, FontWeight.bold),
          ),
        ),
        SizedBox(height: SizeConfig.h(10)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Row(
            children: [
              Expanded(
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      acceptedinsurance = true;
                      acceptedrto = false;
                      acceptedpending = false;
                    });
                  },
                  constraints: BoxConstraints(),
                  padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15), vertical: SizeConfig.h(8)),
                  fillColor: acceptedinsurance ? kred : kwhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    side: BorderSide(
                      color: kgrey,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Insurance',
                      style: customtext(
                        fs14,
                        acceptedinsurance ? kwhite : kred,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.w(10)),
              Expanded(
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      acceptedinsurance = false;
                      acceptedrto = true;
                      acceptedpending = false;
                    });
                  },
                  constraints: BoxConstraints(),
                  padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15), vertical: SizeConfig.h(8)),
                  fillColor: acceptedrto ? kred : kwhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    side: BorderSide(
                      color: kgrey,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'RTO',
                      style: customtext(
                        fs14,
                        acceptedrto ? kwhite : kred,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.w(10)),
              Expanded(
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      acceptedinsurance = false;
                      acceptedrto = false;
                      acceptedpending = true;
                    });
                  },
                  constraints: BoxConstraints(),
                  padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15), vertical: SizeConfig.h(8)),
                  fillColor: acceptedpending ? kred : kwhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    side: BorderSide(
                      color: kgrey,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Pending',
                      style: customtext(
                        fs14,
                        acceptedpending ? kwhite : kred,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.h(10)),
        if (acceptedinsurance == true)
          Expanded(child: AcceptedInsurance()),
        if (acceptedrto == true)
          Expanded(child: AcceptedRtoTab()),
        if (acceptedpending == true)
          Expanded(child: AcceptedPendingTab()),
      ],
    );
  }
}

class AcceptedInsurance extends StatefulWidget {
  const AcceptedInsurance({super.key});

  @override
  State<AcceptedInsurance> createState() => _AcceptedInsuranceState();
}

class _AcceptedInsuranceState extends State<AcceptedInsurance> {
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
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/rto/accepted');

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
                          enquiryid: data['enquiry_id'] ?? '',
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
                                builder: (context) => Movetortoinsu(
                                  enquiryid: data['enquiry_id'] ?? '',
                                  apiResponse: data,
                                ),
                              ),
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

class AcceptedRtoTab extends StatefulWidget {
  const AcceptedRtoTab({super.key});

  @override
  State<AcceptedRtoTab> createState() => _AcceptedRtoTabState();
}

class _AcceptedRtoTabState extends State<AcceptedRtoTab> {
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
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/rto/accepted');

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
                          enquiryid: data['enquiry_id'] ?? '',
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
                                builder: (context) => Movetortorto(
                                  enquiryid: data['enquiry_id'] ?? '',
                                  apiResponse: data,
                                ),
                              ),
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

class AcceptedPendingTab extends StatefulWidget {
  const AcceptedPendingTab({super.key});

  @override
  State<AcceptedPendingTab> createState() => _AcceptedPendingTabState();
}

class _AcceptedPendingTabState extends State<AcceptedPendingTab> {
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
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/rto/ready-partial');

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
                          enquiryid: data['enquiry_id'] ?? '',
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
                                builder: (context) => Movetoreadyforregis(
                                  enquiryid: data['enquiry_id'] ?? '',
                                  apiResponse: data,
                                ),
                              ),
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
