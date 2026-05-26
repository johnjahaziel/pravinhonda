import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewformPending.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Pendinglist extends StatefulWidget {
  const Pendinglist({super.key});

  @override
  State<Pendinglist> createState() => _PendinglistState();
}

class _PendinglistState extends State<Pendinglist> {
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
          final enquiryid = (item['enquiry_id'] ?? '').toString().toLowerCase();

          return enquiryid.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchPage({String? url}) async {
    try {
      final Uri uri = Uri.parse(url ?? 'https://app.pravinhonda.com/api/pdi-pending-list');

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
              final enquiryid = (item['enquiry_id'] ?? '').toString().toLowerCase();

              return enquiryid.contains(query);
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
  
  Widget _buildPendingCard({
    required String enquiryId,
    required List<dynamic> minPending,
    required List<dynamic> extraPending,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(14)),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewformPending(enquiryid: enquiryId),
            ),
          );
        },
        fillColor: kwhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: kred.withOpacity(0.15)),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with enquiry ID
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(16),
              vertical: SizeConfig.h(10),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kred, kred.withOpacity(0.85)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: kwhite, size: SizeConfig.sp(18)),
                SizedBox(width: SizeConfig.w(8)),
                Text(
                  enquiryId,
                  style: customtext(fs16, kwhite, FontWeight.bold),
                ),
              ],
            ),
          ),
    
          Padding(
            padding: EdgeInsets.all(SizeConfig.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimum Pending Section
                _buildPendingSection(
                  title: 'Minimum Pending',
                  items: minPending,
                  icon: Icons.warning_amber_rounded,
                  tagColor: const Color(0xffFFF3E0),
                  tagTextColor: const Color(0xffE65100),
                  iconColor: const Color(0xffE65100),
                ),
    
                if (extraPending.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.h(12)),
                  _buildPendingSection(
                    title: 'Extra Pending',
                    items: extraPending,
                    icon: Icons.add_circle_outline_rounded,
                    tagColor: const Color(0xffE3F2FD),
                    tagTextColor: const Color(0xff1565C0),
                    iconColor: const Color(0xff1565C0),
                  ),
                ],
    
                if (minPending.isEmpty && extraPending.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(8)),
                      child: Text(
                        'No pending items',
                        style: customtext(fs12, kgrey, FontWeight.normal),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPendingSection({
    required String title,
    required List<dynamic> items,
    required IconData icon,
    required Color tagColor,
    required Color tagTextColor,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: SizeConfig.sp(16)),
            SizedBox(width: SizeConfig.w(6)),
            Text(
              '$title (${items.length})',
              style: customtext(fs12, kblack, FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(8)),
        Wrap(
          spacing: SizeConfig.w(8),
          runSpacing: SizeConfig.h(8),
          children: items.map((item) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(10),
                vertical: SizeConfig.h(5),
              ),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.toString(),
                style: customtext(fs10, tagTextColor, FontWeight.w600),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Customdrawer(),
      drawerEnableOpenDragGesture: false,
      appBar: appBar(),
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
                'Pending List',
                style: customtext(fs18, kred, FontWeight.bold),
              ),
            ),
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
                        final String enquiryId = data['enquiry_id']?.toString() ?? '';
                        final List<dynamic> minPending = data['pdi_minimun_pending'] ?? [];
                        final List<dynamic> extraPending = data['pdi_extra_pending'] ?? [];

                        return _buildPendingCard(
                          enquiryId: enquiryId,
                          minPending: minPending,
                          extraPending: extraPending,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
              ),
    );
  }
}