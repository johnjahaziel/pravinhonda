import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/utility/boxes.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class AllLostcustomer extends StatefulWidget {
  const AllLostcustomer({super.key});

  @override
  State<AllLostcustomer> createState() => _AllLostcustomerState();
}

class _AllLostcustomerState extends State<AllLostcustomer> {
  List<dynamic> alldata = [];
  bool loading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecent();
  }

  Future<void> fetchRecent() async {
    final token = BlocProvider.of<AuthCubit>(context).state.token;

    final url = Uri.parse(
        "https://app.pravinhonda.com/api/loss-customers");

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
          alldata = dataList;
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
                      enquiryid: 0,
                      id: data['enquiry_id']?.toString() ?? '',
                      customername: data['customer_name']?.toString() ?? '',
                      contactnumber: data['customer_contact_number']?.toString() ?? '',
                      status: data['status']?.toString() ?? '',
                      onTap: () {}
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