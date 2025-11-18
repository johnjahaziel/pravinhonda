import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Pdi extends StatefulWidget {
  const Pdi({super.key});

  @override
  State<Pdi> createState() => _PdiState();
}

class _PdiState extends State<Pdi> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(20)),
                Center(
                  child: Text(
                    'PDI',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
              ],
            ),
          ),
        ),
      )
    );
  }
}