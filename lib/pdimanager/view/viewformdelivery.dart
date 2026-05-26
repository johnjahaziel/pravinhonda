import 'package:flutter/material.dart';
import 'package:pravinhonda/pdimanager/NavigationPdi.dart';
import 'package:pravinhonda/pdimanager/view/simpleviewdelivery.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class ViewformPdidelivery extends StatefulWidget {
  final String pagename;
  final String enquiryid;
  final Map<String, dynamic> apiResponse;
  final int initialIndex;
  const ViewformPdidelivery({
    super.key,
    required this.pagename,
    required this.enquiryid,
    required this.apiResponse,
    this.initialIndex = 0
  });

  @override
  State<ViewformPdidelivery> createState() => _ViewformPdideliveryState();
}

class _ViewformPdideliveryState extends State<ViewformPdidelivery> {
  bool isEdited = false;

  bool onEditpressed = false;

  bool edit() {
    if(onEditpressed == true) {
      return false;
    } else {
      return true;
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
                back(context, NavigationPdi(initialIndex: widget.initialIndex)),
                Center(
                  child: Text(
                    widget.pagename,
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(15)),
                Expanded(
                  child: Simpleviewdelivery(
                    enquiryid: widget.enquiryid,
                    apiResponse: widget.apiResponse
                  ),
                ),
                SizedBox(height: SizeConfig.h(15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}