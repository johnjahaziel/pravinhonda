import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/loginscreens/mainscreens/createbooking.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Createquotation extends StatefulWidget {
  const Createquotation({super.key});

  @override
  State<Createquotation> createState() => _CreatequotationState();
}

class _CreatequotationState extends State<Createquotation> {
  List<Map<String, String>> customercategoryitems = [
    {'label': 'Individual', 'value': 'Individual'},
  ];

  String? selectedcustomercategoryitems;

  List<Map<String, String>> enquirycategoryitems = [
    {'label': 'Individual', 'value': 'Individual'},
  ];

  String? selectedenquirycategoryitems;

  List<Map<String, String>> customertypeitems = [
    {'label': 'First Time Buyer', 'value': 'First Time Buyer'},
  ];

  String? selectedcustomertypeitems;

  List<Map<String, String>> genderitems = [
    {'label': 'Male', 'value': 'Male'},
    {'label': 'Female', 'value': 'Female'},
    {'label': 'Other', 'value': 'Other'},
  ];

  String? selectedgenderitems;

  List<Map<String, String>> martialstatusitems = [
    {'label': 'Married', 'value': 'Married'},
    {'label': 'Single', 'value': 'Single'},
  ];

  String? selectedmartialstatusitems;

  List<Map<String, String>> enquirytypeitems = [
    {'label': 'Enquiry Type', 'value': 'Enquiry Type'},
  ];

  String? selectedenquirytypeitems;

  List<Map<String, String>> enquirysourceitems = [
    {'label': 'Enquiry Source', 'value': 'Enquiry Source'},
  ];

  String? selectedenquirysourceitems;

  List<Map<String, String>> modelcategoryitems = [
    {'label': 'Model Category', 'value': 'Model Category'},
  ];

  String? selectedmodelcategoryitems;

  List<Map<String, String>> modelnameitems = [
    {'label': 'Model Name', 'value': 'Model Name'},
  ];

  String? selectedmodelnameitems;

  List<Map<String, String>> modelvariantitems = [
    {'label': 'Model Variant', 'value': 'Model Variant'},
  ];

  String? selectedmodelvariantitems;

  List<Map<String, String>> modelcoloritems = [
    {'label': 'Model Color', 'value': 'Model Color'},
  ];

  String? selectedmodelcoloritems;

  List<Map<String, String>> purchasetypeitems = [
    {'label': 'Purchase Type', 'value': 'Purchase Type'},
  ];

  String? selectedpurchasetypeitems;

  List<Map<String, String>> exchangeflagitems = [
    {'label': 'Exchange Flag', 'value': 'Exchange Flag'},
  ];

  String? selectedexchangeflagitems;

  List<Map<String, String>> testrideitems = [
    {'label': 'Test Ride', 'value': 'Test Ride'},
  ];

  String? selectedtestrideitems;

  TextEditingController enquiryid = TextEditingController();
  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController followupdatecontroller = TextEditingController();
  TextEditingController customerremarks = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(20)),
                Center(
                  child: Text(
                    'Create Quotation',
                    style: customtext(
                      fs18,
                      kred,
                      FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(10)),
                textfieldy(
                  'Enquiry ID',
                  enquiryid
                ),
                textfieldy(
                  'Wings Enquiry Number',
                  wingsenquiry
                ),
                CustomDropdown(
                  title: 'Customer Category',
                  selectedCustomDropdown: selectedcustomercategoryitems,
                  customDropdownItems: customercategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcustomercategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Category',
                  selectedCustomDropdown: selectedenquirycategoryitems,
                  customDropdownItems: enquirycategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirycategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Category',
                  selectedCustomDropdown: selectedcustomertypeitems,
                  customDropdownItems: customertypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcustomertypeitems = newValue;
                    });
                  },
                ),
                textfieldy(
                  'Customer Contact Number',
                  customercontactnumber
                ),
                textfieldy(
                  'Customer Name',
                  customername
                ),
                CustomDropdown(
                  title: 'Gender',
                  selectedCustomDropdown: selectedgenderitems,
                  customDropdownItems: genderitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedgenderitems = newValue;
                    });
                  },
                ),
                Customdatefield(
                  title: 'Date of Birth',
                  datecontroller: datecontroller
                ),
                CustomDropdown(
                  title: 'Martial Status',
                  selectedCustomDropdown: selectedmartialstatusitems,
                  customDropdownItems: martialstatusitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmartialstatusitems = newValue;
                    });
                  },
                ),
                textfieldy(
                  "Email ID",
                  emailid
                ),
                CustomDropdown(
                  title: 'Enquiry Type',
                  selectedCustomDropdown: selectedenquirytypeitems,
                  customDropdownItems: enquirytypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirytypeitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Enquiry Source',
                  selectedCustomDropdown: selectedenquirysourceitems,
                  customDropdownItems: enquirysourceitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedenquirysourceitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Category',
                  selectedCustomDropdown: selectedmodelcategoryitems,
                  customDropdownItems: modelcategoryitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelcategoryitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Name',
                  selectedCustomDropdown: selectedmodelnameitems,
                  customDropdownItems: modelnameitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelnameitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Variant',
                  selectedCustomDropdown: selectedmodelvariantitems,
                  customDropdownItems: modelvariantitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelvariantitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Model Color',
                  selectedCustomDropdown: selectedmodelcoloritems,
                  customDropdownItems: modelcoloritems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedmodelcoloritems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Purchase Type',
                  selectedCustomDropdown: selectedpurchasetypeitems,
                  customDropdownItems: purchasetypeitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedpurchasetypeitems = newValue;
                    });
                  },
                ),
                CustomDropdown(
                  title: 'Exchange Flag',
                  selectedCustomDropdown: selectedexchangeflagitems,
                  customDropdownItems: exchangeflagitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedexchangeflagitems = newValue;
                    });
                  },
                ),
                Customdatefield(
                  title: 'Follow Up Date',
                  datecontroller: followupdatecontroller
                ),
                CustomDropdown(
                  title: 'Test Ride',
                  selectedCustomDropdown: selectedtestrideitems,
                  customDropdownItems: testrideitems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedtestrideitems = newValue;
                    });
                  },
                ),
                description(
                  'Customer Remarks',
                  customerremarks
                ),
                SizedBox(height: SizeConfig.h(20)),
                button(
                  'Create Quotation',
                  () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => QuotationSuccessPopup(
                        name: "Rojar",
                        number: "87548 01550",
                      ),
                    );
                  }
                ),
            
                SizedBox(height: SizeConfig.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuotationSuccessPopup extends StatelessWidget {
  final String name;
  final String number;

  const QuotationSuccessPopup({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tightFor(
        width: double.infinity
      ),
      backgroundColor: kwhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(5),left: SizeConfig.w(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : $name",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : $number",
                      style: textmedium12,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(20)),
          LottieBuilder(
            height: SizeConfig.h(120),
            width: SizeConfig.w(120),
            lottie: AssetLottie(
              'lottie/completed.json',
            )
          ),
          SizedBox(height: SizeConfig.h(2)),
          Text(
            "Thanks For Creating The Quotation!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Please Download It And\nGive A Hard Copy To The Customer.",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "Thank You!",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(40)),
          button(
            'Print',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Createbooking())
              );
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}

