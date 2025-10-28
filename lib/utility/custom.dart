import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/styles.dart';

textfield(String title, TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: text12
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
      child: SizedBox(
        child: TextField(
          maxLines: 1,
          controller: controller,
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
);

password(String title, suffixIcon,bool isPassword,TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: text12
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: !isPassword,
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
          ),
          suffixIcon: suffixIcon
        ),
      ),
    ),
  ],
);