import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

textfieldy(String title, TextEditingController controller, {bool star = true}) => Padding(
  padding: const EdgeInsets.only(top: 15),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fs12,
              fontFamily: 'Poppins',
              color: Color(0xff919EAB)
            ),
          ),
          // if(star)
          // Text(
          //   '*',
          //   style: TextStyle(
          //     fontFamily: 'Poppins',
          //     color: kred
          //   ),
          // ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          child: TextField(
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xff919EAB)
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xff919EAB)
                )
              )
            )
          ),
        ),
      ),
    ],
  ),
);

description(String title,TextEditingController controller, {bool star = false, bool padding = false}) => Padding(
  padding: padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.only(top: 15),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff919EAB)
            ),
          ),
          // if(star)
          // Text(
          //   '*',
          //   style: TextStyle(
          //     fontFamily: 'Poppins',
          //     color: kred
          //   ),
          // ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          height: 150,
          child: TextField(
            expands: true,
            maxLines: null,
            minLines: null,
            controller: controller,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xff919EAB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xff919EAB)),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);

button(String title, VoidCallback onPressed) => Padding(
  padding: const EdgeInsets.only(left: 25,right: 25),
  child: RawMaterialButton(
    onPressed: onPressed,
    fillColor: kred,
    constraints: BoxConstraints.tightFor(
      width: double.infinity,
      height: 55
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16
      ),
    )
  ),
);