import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/styles.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('images/pravin_honda_logo.png'),
          height: 30,
          width: 30,
        ),
        Text(
          'Pravin Honda',
          style: customtext(
            fs14,
            kred,
            FontWeight.w600
          ),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 2),
        child: IconButton(
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_outlined,
            color: kblack,
          ),
        ),
      ),
    ],
  );
}