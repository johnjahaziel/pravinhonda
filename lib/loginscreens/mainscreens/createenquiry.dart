import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/customdropdown.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Createenquiry extends StatefulWidget {
  const Createenquiry({super.key});

  @override
  State<Createenquiry> createState() => _CreateenquiryState();
}

class _CreateenquiryState extends State<Createenquiry> {

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
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(20)),
              Center(
                child: Text(
                  'Create Enquiry',
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
                'Create Enquiry',
                () {}
              ),

              SizedBox(height: SizeConfig.h(40)),
            ],
          ),
        ),
      ),
    );
  }
}
