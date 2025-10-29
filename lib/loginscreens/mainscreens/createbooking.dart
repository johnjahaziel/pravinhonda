import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Createbooking extends StatefulWidget {
  const Createbooking({super.key});

  @override
  State<Createbooking> createState() => _CreatebookingState();
}

class _CreatebookingState extends State<Createbooking> {

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

  TextEditingController enquiryid = TextEditingController();
  TextEditingController wingsenquiry = TextEditingController();
  TextEditingController customercontactnumber = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController bookingamount = TextEditingController();
  TextEditingController bookingreceiptno = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: Customdrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(20)),
              Center(
                child: Text(
                  'Create Booking',
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
              textfieldy(
                'Booking Amount',
                bookingamount
              ),
              textfieldy(
                'Booking Receipt No.',
                bookingreceiptno
              ),
              SizedBox(height: SizeConfig.h(20)),
              button(
                'Create Booking',
                () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => BookingSuccessPopup(
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
    );
  }
}

class BookingSuccessPopup extends StatelessWidget {
  final String name;
  final String number;

  const BookingSuccessPopup({
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
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}