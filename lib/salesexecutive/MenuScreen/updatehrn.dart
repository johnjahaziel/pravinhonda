import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/view/viewformhrn.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Updatehrn extends StatefulWidget {
  const Updatehrn({super.key});

  @override
  State<Updatehrn> createState() => _UpdatehrnState();
}

class _UpdatehrnState extends State<Updatehrn> {
  List<dynamic> alldata = [];
  List<dynamic> _allData = [];
  bool loading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    fetchRecent();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
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

          return name.contains(query) ||
              mobile.contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchRecent() async {
    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final url = Uri.parse(
        "https://app.pravinhonda.com/api/highrise");

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

        setState(() {
          _allData = dataList;
          loading = false;
          alldata = List<dynamic>.from(_allData);
        });

        final query = searchController.text.trim().toLowerCase();
        if (query.isEmpty) {
          alldata = List<dynamic>.from(_allData);
        } else {
          alldata = _allData.where((item) {
            final name = (item['customer_name'] ?? '').toString().toLowerCase();
            final mobile = (item['customer_contact_number'] ?? '').toString().toLowerCase();

            return name.contains(query) ||
                mobile.contains(query);
          }).toList();
        }

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
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: loading ? Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(40)),
          child: Center(
            child: CircularProgressIndicator(
              color: kred,
          )),
        )
        : Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(10)),
              search(searchController),
              SizedBox(height: SizeConfig.h(20)),
              Expanded(
                child: ListView.builder(
                  itemCount: alldata.length,
                  itemBuilder: (context, index) {
                    final data = alldata[index];
                    return Hondabox(
                      enquiryid: data['enquiry_id']?.toString() ?? '',
                      id: data['enquiry_id']?.toString() ?? '',
                      customername: data['customer_name']?.toString() ?? '',
                      contactnumber: data['customer_contact_number']?.toString() ?? '',
                      status: data['status']?.toString() ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Viewformhrn(
                            enquiryid: data['enquiry_id'] ?? 0,
                            apiResponse: data,
                            )
                          )
                        );
                      },
                      buttonneed: false,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}