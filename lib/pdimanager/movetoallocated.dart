import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/pdimanager/Navigation.dart';
import 'package:pravinhonda/pdimanager/view/simpleview.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetoallocated extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetoallocated({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Movetoallocated> createState() => _MovetoallocatedState();
}

class _MovetoallocatedState extends State<Movetoallocated> {
  final helperitems = helperItems;
  String? selectedhelper;

  String helpere = '';

  bool isEdited = false;

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> movetoworking() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/allocated-helper/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'helper': selectedhelper,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(responseData);
        Fluttertoast.showToast(msg: responseData['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPdi(
              initialIndex: 2,
            ),
          ),
        );

      } else {

        print(responseData);
        Fluttertoast.showToast(msg: responseData['message']);

        setState(() {
          helpere = responseData['message'];
        });

      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.h(10)),
                back(context, NavigationPdi(initialIndex: 1)),
                Center(
                  child: Text(
                    'Accepted',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(15)),
                Expanded(
                  child: Simpleview(
                    enquiryid: widget.enquiryid,
                    apiResponse: widget.apiResponse
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20),),
                  child: CustomDropdown(
                    title: 'Helper',
                    selectedCustomDropdown: selectedhelper,
                    customDropdownItems: helperitems,
                    onChanged: (newValue) {
                      setState(() {
                        selectedhelper = newValue;
                      });
                    },
                    star: true,
                  ),
                ),
                if(helpere.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20),),
                  child: errormessage(helpere),
                ),
                button(
                  'Move to Allocated Helper',
                  () {
                    movetoworking();
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}