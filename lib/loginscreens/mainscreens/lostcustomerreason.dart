import 'package:flutter/material.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class LostcustomerReason extends StatefulWidget {
  const LostcustomerReason({super.key});

  @override
  State<LostcustomerReason> createState() => _LostcustomerReasonState();
}

class _LostcustomerReasonState extends State<LostcustomerReason> {
  bool duetobrand = false;
  bool otherhondadealer = false;
  bool discount = false;
  bool product = false;
  bool service = false;
  bool availablility = false;
  bool price = false;
  bool others = false;

  String? selectedduetobranditems;

  List<Map<String, String>> duetobranditems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedotherhondadealeritems;

  List<Map<String, String>> otherhondadealeritems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selecteddiscountitems;

  List<Map<String, String>> discountitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedproductitems;

  List<Map<String, String>> productitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedserviceitems;

  List<Map<String, String>> serviceitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedavailablilityitems;

  List<Map<String, String>> availablilityitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  String? selectedpriceitems;

  List<Map<String, String>> priceitems = [
    {'label': 'Yes', 'value': 'Yes'},
    {'label': 'No', 'value': 'No'},
  ];

  TextEditingController otherscomments = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.h(20)),
              Center(
                child: Text(
                  'Lost Customer',
                  style: customtext(fs18, kred, FontWeight.bold),
                ),
              ),
              SizedBox(height: SizeConfig.h(20)),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.w(0), top: SizeConfig.h(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Customcheckbox(
                      isChecked: duetobrand,
                      title: 'Due to Brand',
                      onChanged: (val) => setState(() => duetobrand = val),
                    ),
                    if(duetobrand == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedduetobranditems,
                      customDropdownItems: duetobranditems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedduetobranditems = newValue;
                        });
                      },
                      padding: true,
                    ),
          
                    Customcheckbox(
                      isChecked: otherhondadealer,
                      title: 'Other Honda Dealer',
                      onChanged: (val) => setState(() => otherhondadealer = val),
                    ),
                    if(otherhondadealer == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedotherhondadealeritems,
                      customDropdownItems: otherhondadealeritems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedotherhondadealeritems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: discount,
                      title: 'Discount',
                      onChanged: (val) => setState(() => discount = val),
                    ),
                    if(discount == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selecteddiscountitems,
                      customDropdownItems: discountitems,
                      onChanged: (newValue) {
                        setState(() {
                          selecteddiscountitems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: product,
                      title: 'Product',
                      onChanged: (val) => setState(() => product = val),
                    ),
                    if(product == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedproductitems,
                      customDropdownItems: productitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedproductitems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: service,
                      title: 'Service',
                      onChanged: (val) => setState(() => service = val),
                    ),
                    if(service == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedserviceitems,
                      customDropdownItems: serviceitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedserviceitems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: availablility,
                      title: 'Availability',
                      onChanged: (val) => setState(() => availablility = val),
                    ),
                    if(availablility == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedavailablilityitems,
                      customDropdownItems: availablilityitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedavailablilityitems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: price,
                      title: 'Price',
                      onChanged: (val) => setState(() => price = val),
                    ),
                    if(price == true)
                    CustomDropdown(
                      title: 'Choose the Brand',
                      selectedCustomDropdown: selectedpriceitems,
                      customDropdownItems: priceitems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedpriceitems = newValue;
                        });
                      },
                      padding: true,
                    ),

                    Customcheckbox(
                      isChecked: others,
                      title: 'Others',
                      onChanged: (val) => setState(() => others = val),
                    ),
                    if(others == true)
                    description(
                      '',
                      otherscomments,
                      padding: true
                    ),

                    SizedBox(height: SizeConfig.h(40)),
                    button(
                      'Submit',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation())
                        );
                      },
                      padding: true
                    ),
                    SizedBox(height: SizeConfig.h(40)),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Customcheckbox extends StatelessWidget {
  final bool isChecked;
  final String title;
  final ValueChanged<bool> onChanged;

  const Customcheckbox({
    super.key,
    required this.isChecked,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.w(20), top: SizeConfig.h(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: kred,
          ),
          Text(
            title,
            style: textmedium14,
          )
        ],
      ),
    );
  }
}
