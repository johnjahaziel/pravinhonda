import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

const List<Map<String, String>> helperItems = [
  {'label': 'Helper 1', 'value': 'Helper 1'},
  {'label': 'Helper 2', 'value': 'Helper 2'},
  {'label': 'Helper 3', 'value': 'Helper 3'},
  {'label': 'Helper 4', 'value': 'Helper 4'},
];

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
  {'label': 'Other', 'value': 'Other'},
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

class Minimumpackage extends StatefulWidget {
  final String title;
  final List<dynamic> product;
  final List<dynamic> price;
  final String total;
  final void Function(String answer) onChanged;
  const Minimumpackage({
    super.key,
    required this.title,
    required this.product,
    required this.price,
    required this.total,
    required this.onChanged,
  });

  @override
  State<Minimumpackage> createState() => _MinimumpackageState();
}

class _MinimumpackageState extends State<Minimumpackage> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
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
            child: (widget.product.isEmpty || widget.price.isEmpty || widget.total.isEmpty)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(30)),
              child: Center(
                child: Text(
                  'Select the Model first',
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
                    height: widget.product.length <= 5
                      ? null
                      : SizeConfig.h(120),
                    child: ListView.builder(
                      shrinkWrap: widget.product.length <= 5,
                      physics: widget.product.length <= 5
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                      itemCount: widget.product.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: SizeConfig.h(5)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  widget.product[index],
                                  style: customtext(fs12, kblack),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.price[index],
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
                  'Total: ${widget.total}',
                  style: textmedium12,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.h(8)),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: selectedAnswer == 'yes',
                    onChanged: (val) {
                      setState(() {
                        selectedAnswer = 'yes';
                      });
                      widget.onChanged('yes');
                    },
                    activeColor: kred,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  SizedBox(width: SizeConfig.w(2)),
                  Text(
                    'Yes',
                    style: customtext(fs12, kblack),
                  ),
                ],
              ),
              SizedBox(width: SizeConfig.w(10)),
              Row(
                children: [
                  Checkbox(
                    value: selectedAnswer == 'no',
                    onChanged: (val) {
                      setState(() {
                        selectedAnswer = 'no';
                      });
                      widget.onChanged('no');
                    },
                    activeColor: kred,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  SizedBox(width: SizeConfig.w(2)),
                  Text(
                    'No',
                    style: customtext(fs12, kblack),
                  ),
                ],
              ),
            ],
          )
        ]
      ),
    );
  }
}

class Extrafittings extends StatefulWidget {
  final String title;
  final List<dynamic> product;
  final List<dynamic> price;
  final void Function(List<String> selectedProducts) onChanged;
  const Extrafittings({
    super.key,
    required this.title,
    required this.product,
    required this.price,
    required this.onChanged,
  });

  @override
  State<Extrafittings> createState() => _ExtrafittingsState();
}

class _ExtrafittingsState extends State<Extrafittings> {

  void selectedvalue() {
    List<String> selectedProducts = [];

    for (int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        selectedProducts.add(widget.product[i].toString());
      }
    }

    widget.onChanged(selectedProducts);
  }

  late List<bool> selected;

  String get total {
    int sum = 0;

    for (int i = 0; i < widget.price.length; i++) {
      if (selected[i]) {
        sum += int.tryParse(widget.price[i].toString()) ?? 0;
      }
    }

    return sum.toString();
  }

  @override
  void initState() {
    super.initState();
    selected = List.generate(widget.product.length, (_) => false);
  }

  @override
  void didUpdateWidget(covariant Extrafittings oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.length != widget.product.length) {
      selected = List.generate(widget.product.length, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
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
            child: (widget.product.isEmpty || widget.price.isEmpty)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(30)),
              child: Center(
                child: Text(
                  'Select the Model first',
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
                    height: widget.product.length <= 5
                      ? null
                      : SizeConfig.h(120),
                    child: ListView.builder(
                      shrinkWrap: widget.product.length <= 5,
                      physics: widget.product.length <= 5
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                      itemCount: widget.product.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selected[index] = !selected[index];
                            });
                            selectedvalue();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: SizeConfig.h(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: kred,
                                        value: selected[index],
                                        onChanged: (val) {
                                          setState(() {
                                            selected[index] = val ?? false;
                                          });
                                          selectedvalue();
                                        },
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      SizedBox(width: SizeConfig.w(2)),
                                      Text(
                                        widget.product[index],
                                        style: customtext(fs12, kblack),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      widget.price[index],
                                      style: customtext(fs12, kblack),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
  }
}

class EditMinimumpackage extends StatefulWidget {
  final String title;
  final List<dynamic> product;
  final List<dynamic> price;
  final String total;
  final void Function(String answer) onChanged;
  final bool readonly;
  const EditMinimumpackage({
    super.key,
    required this.title,
    required this.product,
    required this.price,
    required this.total,
    required this.onChanged,
    this.readonly = false,
  });

  @override
  State<EditMinimumpackage> createState() => _EditMinimumpackageState();
}

class _EditMinimumpackageState extends State<EditMinimumpackage> {
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _setAnswerFromPackage();
  }

  @override
  void didUpdateWidget(covariant EditMinimumpackage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product != widget.product) {
      _setAnswerFromPackage();
    }
  }

  void _setAnswerFromPackage() {
    final newAnswer = widget.product.isNotEmpty ? 'yes' : 'no';

    if (selectedAnswer == newAnswer) return;

    selectedAnswer = newAnswer;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onChanged(newAnswer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Opacity(
        opacity: widget.readonly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: widget.readonly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
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
                child: (widget.product.isEmpty || widget.price.isEmpty || widget.total.isEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(30)),
                  child: Center(
                    child: Text(
                      'Select the Model first',
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
                        height: widget.product.length <= 5
                          ? null
                          : SizeConfig.h(120),
                        child: ListView.builder(
                          shrinkWrap: widget.product.length <= 5,
                          physics: widget.product.length <= 5
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(),
                          itemCount: widget.product.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: SizeConfig.h(5)),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      widget.product[index],
                                      style: customtext(fs12, kblack),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        widget.price[index],
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
                      'Total: ${widget.total}',
                      style: textmedium12,
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.h(8)),
              Row(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: selectedAnswer == 'yes',
                        onChanged: (val) {
                          setState(() {
                            selectedAnswer = 'yes';
                          });
                          widget.onChanged('yes');
                        },
                        activeColor: kred,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(width: SizeConfig.w(2)),
                      Text(
                        'Yes',
                        style: customtext(fs12, kblack),
                      ),
                    ],
                  ),
                  SizedBox(width: SizeConfig.w(10)),
                  Row(
                    children: [
                      Checkbox(
                        value: selectedAnswer == 'no',
                        onChanged: (val) {
                          setState(() {
                            selectedAnswer = 'no';
                          });
                          widget.onChanged('no');
                        },
                        activeColor: kred,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(width: SizeConfig.w(2)),
                      Text(
                        'No',
                        style: customtext(fs12, kblack),
                      ),
                    ],
                  ),
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}

class EditExtrafittings extends StatefulWidget {
  final String title;
  final List<dynamic> product;
  final List<dynamic> price;
  final void Function(List<String> selectedProducts) onChanged;
  final List<String> initialSelected;
  final bool readonly;
  const EditExtrafittings({
    super.key,
    required this.title,
    required this.product,
    required this.price,
    required this.onChanged,
    required this.initialSelected,
    this.readonly = false,
  });

  @override
  State<EditExtrafittings> createState() => _EditExtrafittingsState();
}

class _EditExtrafittingsState extends State<EditExtrafittings> {

  bool _initialApplied = false;

  void selectedvalue() {
    List<String> selectedProducts = [];

    for (int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        selectedProducts.add(widget.product[i].toString());
      }
    }

    widget.onChanged(selectedProducts);
  }

  late List<bool> selected;

  String get total {
    int sum = 0;

    for (int i = 0; i < widget.price.length; i++) {
      if (selected[i]) {
        sum += int.tryParse(widget.price[i].toString()) ?? 0;
      }
    }

    return sum.toString();
  }

  @override
  void initState() {
    super.initState();
    selected = [];
  }

  @override
  void didUpdateWidget(covariant EditExtrafittings oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.product.isNotEmpty &&
        widget.product.length != oldWidget.product.length) {

      selected = List.generate(widget.product.length, (_) => false);
      _initialApplied = false; 
    }

    if (!_initialApplied &&
        widget.product.isNotEmpty &&
        widget.initialSelected.isNotEmpty) {

      _applyInitialSelection();
      _initialApplied = true;
    }
  }

  void _applyInitialSelection() {
    for (int i = 0; i < widget.product.length; i++) {
      final product = widget.product[i].toString().trim().toLowerCase();

      if (widget.initialSelected.any(
        (e) => e.trim().toLowerCase() == product,
      )) {
        selected[i] = true;
      }
    }

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedvalue();
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Opacity(
        opacity: widget.readonly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: widget.readonly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
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
                child: (widget.product.isEmpty || widget.price.isEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(30)),
                  child: Center(
                    child: Text(
                      'Select the Model first',
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
                        height: widget.product.length <= 5
                          ? null
                          : SizeConfig.h(120),
                        child: ListView.builder(
                          shrinkWrap: widget.product.length <= 5,
                          physics: widget.product.length <= 5
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(),
                          itemCount: widget.product.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selected[index] = !selected[index];
                                });
                                selectedvalue();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: SizeConfig.h(5)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: kred,
                                            value: selected[index],
                                            onChanged: (val) {
                                              setState(() {
                                                selected[index] = val ?? false;
                                              });
                                              selectedvalue();
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          SizedBox(width: SizeConfig.w(2)),
                                          Text(
                                            widget.product[index],
                                            style: customtext(fs12, kblack),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          widget.price[index],
                                          style: customtext(fs12, kblack),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        ),
      ),
    );
  }
}