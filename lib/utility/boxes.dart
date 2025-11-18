import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pravinhonda/loginscreens/mainscreens/lostcustomerreason.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Hondabox extends StatefulWidget {
  final String id;
  final String customername;
  final String contactnumber;
  final String status;
  final String cashfinance;
  final String textride;
  final String exchange;
  const Hondabox({
    super.key,
    required this.id,
    required this.customername,
    required this.contactnumber,
    required this.status,
    required this.cashfinance,
    this.textride = 'No',
    this.exchange = 'finance',
  });

  @override
  State<Hondabox> createState() => _HondaboxState();
}

class _HondaboxState extends State<Hondabox> {

  void callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void openWhatsApp(String number) async {
    final whatsappUrl = Uri.parse('https://wa.me/91${number}');
    
    launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.h(5),bottom: SizeConfig.h(5)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kgrey
          )
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(10),vertical: SizeConfig.h(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.id,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          widget.customername,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          widget.contactnumber,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          widget.status,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          // callNumber(widget.contactnumber);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => ReviewBoxes(
                              name: "Rojar",
                              number: "87548 01550",
                            ),
                          );
                        },
                        constraints: BoxConstraints.tightFor(
                          height: SizeConfig.h(40),
                          width: SizeConfig.w(40)
                        ),
                        fillColor: kgreen2,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.call,
                          color: kwhite,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(7)),
                      RawMaterialButton(
                        onPressed: () {
                          openWhatsApp(widget.contactnumber);
                        },
                        constraints: BoxConstraints.tightFor(
                          height: SizeConfig.h(40),
                          width: SizeConfig.w(40)
                        ),
                        fillColor: kgreen,
                        shape: CircleBorder(),
                        child: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: kwhite,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: SizeConfig.h(5)),
              Row(
                children: [
                  if(widget.textride == 'yes')
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kyellow,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                        child: Text(
                          'Test Ride',
                          style: textmedium8,
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(4)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kblue,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                        child: Text(
                          widget.cashfinance,
                          style: textmedium8,
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(4)),
                    ],
                  ),
                  if(widget.exchange == 'finance')
                  Container(
                    decoration: BoxDecoration(
                      color: kgreen2,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                    child: Text(
                      'Exchange',
                      style: textmedium8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewBoxes extends StatefulWidget {
  final String name;
  final String number;

  const ReviewBoxes({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  State<ReviewBoxes> createState() => _ReviewBoxesState();
}

class _ReviewBoxesState extends State<ReviewBoxes> {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController commemts = TextEditingController();

  bool isChecked = false;

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
                      "Name : ${widget.name}",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : ${widget.number}",
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
          description(
            'Comments',
            commemts,
            padding: true,
          ),
          SizedBox(height: SizeConfig.h(10)),
          Customdatefield(
            title: 'Next Follow Up Date',
            datecontroller: datecontroller,
            padding: true,
          ),
          SizedBox(height: SizeConfig.h(10)),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.w(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: kred,
                ),
                Text(
                  'Lost Customer',
                  style: text12,
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.h(10)),
          button(
            'Update',
            () {
              if(isChecked == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Lostcustomer(
                    name: "Rojar",
                    number: "87548 01550",
                  ),
                );
              }
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}

class Lostcustomer extends StatefulWidget {
  final String name;
  final String number;
  const Lostcustomer({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  State<Lostcustomer> createState() => _LostcustomerState();
}

class _LostcustomerState extends State<Lostcustomer> {
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
                      "Name : ${widget.name}",
                      style: textmedium12,
                    ),
                    Text(
                      "Number : ${widget.number}",
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
              'lottie/sad.json',
            ),
          ),
          SizedBox(height: SizeConfig.h(10)),
          Text(
            "Are You Sure that the customer is not\nInterested in Purchase the bike",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(20)),
          Text(
            "That action can’t be revert.",
            textAlign: TextAlign.center,
            style: textmedium12
          ),
          SizedBox(height: SizeConfig.h(30)),
          button(
            'Yes',
            () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LostcustomerReason()),
                ((route) => false)
              );
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ]
      ),
    );
  }
}