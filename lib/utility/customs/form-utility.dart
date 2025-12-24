import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

const List<Map<String, String>> customerCategoryItems= [
  {'label': 'Individual', 'value': 'Individual'},
  {'label': 'CSD', 'value': 'CSD'},
  {'label': 'KPKB', 'value': 'KPKB'},
  {'label': 'Corporate', 'value': 'Corporate'},
];

const List<Map<String, String>> enquirycategoryTypeItems = [
  {'label': 'Individual', 'value': 'Individual'},
  {'label': 'Institutional Customer', 'value': 'Institutional Customer'},
  {'label': 'Exchange with ELV', 'value': 'Exchange with ELV'},
];

const List<Map<String, String>> customerTypeItems = [
  {'label': 'First Time Buyer', 'value': 'First Time Buyer'},
  {'label': 'Additional Buyer', 'value': 'Additional Buyer'},
  {'label': 'Replacement Buyer', 'value': 'Replacement Buyer'},
];

const List<Map<String, String>> genderTypeItems = [
  {'label': 'Male', 'value': 'Male'},
  {'label': 'Female', 'value': 'Female'},
];

const List<Map<String, String>> martialstatusTypeItems = [
  {'label': 'Married', 'value': 'Married'},
  {'label': 'Single', 'value': 'Single'},
];

const List<Map<String, String>> enquiryTypeItems = [
  {'label': 'Digital', 'value': 'Digital'},
  {'label': 'Walk-In', 'value': 'Walk-In'},
  {'label': 'Telephonic', 'value': 'Telephonic'},
  {'label': 'Outdoor Activity', 'value': 'Outdoor Activity'},
];

const List<Map<String, String>> enquirysourceTypeItems = [
  {'label': 'Showroom Walk In', 'value': 'Showroom Walk In'},
  {'label': 'Railway', 'value': 'Railway'},
  {'label': 'Auto-Expo 2025', 'value': 'Auto-Expo 2025'},
  {'label': 'NEWS', 'value': 'NEWS'},
  {'label': 'Online Booking', 'value': 'Online Booking'},
  {'label': 'TV', 'value': 'TV'},
  {'label': 'Facebook', 'value': 'Facebook'},
];

const List<Map<String, String>> purchaseTypeItems = [
  {'label': 'Cash', 'value': 'cash'},
  {'label': 'Finance', 'value': 'finance'},
];

const List<Map<String, String>> exchangeflagTypeItems = [
  {'label': 'Yes', 'value': 'yes'},
  {'label': 'No', 'value': 'no'},
];

const List<Map<String, String>> testrideTypeItems = [
  {'label': 'Yes', 'value': 'yes'},
  {'label': 'No', 'value': 'no'},
];

const List<Map<String, String>> financeTypeItems = [
  {'label': 'Personal Loan', 'value': 'Personal Loan'},
];

const List<Map<String, String>> loanperiodTypeItems = [
  {'label': '12', 'value': '12'},
];

textfieldy(String title, TextEditingController controller, {bool star = true, bool readonly = false, bool numpad = false}) => Padding(
  padding: const EdgeInsets.only(top: 15),
  child: Opacity(
    opacity: readonly ? 0.6 : 1,
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
            if(star)
            Text(
              '*',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: kred
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SizedBox(
            child: TextField(
              controller: controller,
              readOnly: readonly == true ? true : false,
              keyboardType: numpad == true ? TextInputType.number : TextInputType.text,
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
  ),
);

description(String title,TextEditingController controller, {bool star = false, bool padding = false, bool readonly = false}) => Padding(
  padding: padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.only(top: 15),
  child: Opacity(
    opacity: readonly ? 0.6 : 1,
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
            if(star)
            Text(
              '*',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: kred
              ),
            ),
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
              readOnly: readonly == true ? true : false,
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
  ),
);

button(String title, VoidCallback onPressed, {bool padding = false}) => Padding(
  padding: padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.only(top: 15),
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

errormessage(String message) {
  return Padding(
    padding: EdgeInsets.only(top: SizeConfig.h(5)),
    child: Text(
      message,
      style: customtext(
        fs10,
        kred
      ),
    ),
  );
}

Future<void> showMessagePopup(BuildContext context, String message, VoidCallback onTap,{String nextpage = ''}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kwhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fs14
              ),
            ),
            SizedBox(height: SizeConfig.h(20)),
            SizedBox(
              width: SizeConfig.w(80),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "OK",
                  style: customtext(
                    fs12,
                    kred,
                    FontWeight.w500
                  ),
                ),
              ),
            ),
            if(nextpage != '')
            SizedBox(height: SizeConfig.h(20)),
            if(nextpage != '')
            Row(
              children: [
                Text(
                  'Next Page: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fs12
                  ),
                ),
                SizedBox(height: SizeConfig.w(2)),
                Text(
                  nextpage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fs14,
                    fontWeight: FontWeight.bold,
                    color: kred
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

back(BuildContext context, Widget backscreen) => RawMaterialButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => backscreen)
    );
  },
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.arrow_back_rounded,
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'Back',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16
          ),
        ),
      ],
    ),
  ),
);

minimumpackages(String title, List<dynamic> product, List<dynamic> price, String total) => Padding(
  padding: const EdgeInsets.only(top: 15),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: fs12,
          fontFamily: 'Poppins',
          color: Color(0xff919EAB)
        ),
      ),
      SizedBox(height: SizeConfig.h(5)),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xff919EAB)
          )
        ),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10), vertical: SizeConfig.h(10)),
        child: (product.isEmpty || price.isEmpty || total.isEmpty)
      ? Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(30)),
          child: Center(
            child: Text(
              'Select the model first',
              style: customtext(
                fs12,
                Color(0xff919EAB),
              ),
            ),
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10), vertical: SizeConfig.h(5)),
                  child: Text(
                    'Products',
                    style: customtext(
                      fs10,
                      Color(0xff494949),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10), vertical: SizeConfig.h(5)),
                  child: Text(
                    'Price',
                    style: customtext(
                      fs10,
                      Color(0xff494949),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(2), vertical: SizeConfig.h(3)),
              child: SizedBox(
                height: product.length <= 5
                  ? null
                  : SizeConfig.h(120),
                child: ListView.builder(
                  shrinkWrap: product.length <= 5,
                  physics: product.length <= 5
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: SizeConfig.h(5)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              product[index],
                              style: customtext(fs12, kblack),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                price[index],
                                style: customtext(fs12, kblack),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: SizeConfig.h(10)),
            Text(
              'Total: $total',
              style: textmedium12,
            ),
          ],
        ),
      ),
    ]
  ),
);