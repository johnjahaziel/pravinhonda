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
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Movetocompleted extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;
  const Movetocompleted({
    super.key,
    required this.enquiryid,
    required this.apiResponse
  });

  @override
  State<Movetocompleted> createState() => _MovetocompletedState();
}

class _MovetocompletedState extends State<Movetocompleted> {
  bool isEdited = false;

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> movetoaccept() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/move-to-completed/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        url,
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
              initialIndex: 5,
            ),
          ),
        );

      } else {

        print(responseData);
        Fluttertoast.showToast(msg: responseData['message']);

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
                back(context, NavigationPdi(initialIndex: 4)),
                Center(
                  child: Text(
                    'Working',
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
                button(
                  'Move to Completed',
                  () {
                    movetoaccept();
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