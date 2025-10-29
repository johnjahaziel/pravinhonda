import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

Widget hondabox(
  String id,
  String customername,
  String contactnumber,
  String status
) {
  return Padding(
    padding: EdgeInsets.only(top: SizeConfig.h(5),bottom: SizeConfig.h(5)),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kgrey
        )
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(10),vertical: SizeConfig.h(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        id,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SizeConfig.h(5)),
                      Text(
                        customername,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SizeConfig.h(5)),
                      Text(
                        contactnumber,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SizeConfig.h(5)),
                      Text(
                        status,
                        style: textmedium12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {},
                      constraints: BoxConstraints.tightFor(
                        height: SizeConfig.h(40),
                        width: SizeConfig.w(40)
                      ),
                      fillColor: kgreen2,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.call,
                        color: kwhite,
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(7)),
                    RawMaterialButton(
                      onPressed: () {},
                      constraints: BoxConstraints.tightFor(
                        height: SizeConfig.h(40),
                        width: SizeConfig.w(40)
                      ),
                      fillColor: kgreen,
                      shape: CircleBorder(),
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: kwhite,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: SizeConfig.h(5)),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kyellow,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                  child: Text(
                    'Test Ride',
                    style: textmedium8,
                  ),
                ),
                SizedBox(width: SizeConfig.w(4)),
                Container(
                  decoration: BoxDecoration(
                    color: kblue,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                  child: Text(
                    'Finance',
                    style: textmedium8,
                  ),
                ),
                SizedBox(width: SizeConfig.w(4)),
                Container(
                  decoration: BoxDecoration(
                    color: kgreen2,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                  child: Text(
                    'Exchange',
                    style: textmedium8,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}