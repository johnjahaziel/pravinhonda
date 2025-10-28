import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pravinhonda/loginscreens/mainscreens/createenquiry.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool recentactivity = true;
  bool todolist = false;

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
                SizedBox(
                  height: SizeConfig.h(20)
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(10),
                    vertical: SizeConfig.h(10),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(SizeConfig.w(10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Welcome XXXXX',
                                style: customtext(fs14, kred, FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: SizeConfig.h(5)),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Monthly Target : 20', style: textmedium12),
                            ),
                            SizedBox(height: SizeConfig.h(3)),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Target Achieved : 12', style: textmedium12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: SizeConfig.w(20),
                                        sectionsSpace: 0,
                                        startDegreeOffset: 270,
                                        sections: _showingSections(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.h(4)),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Daily Conversion%',
                                      style: textmedium8
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.w(10),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: SizeConfig.w(20),
                                        sectionsSpace: 0,
                                        startDegreeOffset: 270,
                                        sections: _showingSections(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.h(4)),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Monthly Conversion%',
                                      style: textmedium8
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      rowdetails(
                        '210',
                        'Total\nEnquiry',
                        kred
                      ),
                      rowdetails(
                        '20',
                        'Open\nEnquiry',
                        kyellow
                      ),
                      rowdetails(
                        '87',
                        'Booking',
                        klightgreen
                      ),
                      rowdetails(
                        '34',
                        'Delivered',
                        kdarkblue
                      ),
                      rowdetails(
                        '19',
                        'Lost\nCustomer',
                        kpurple
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kgrey
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.h(8),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    recentactivity = true;
                                    todolist = false;
                                  });
                                },
                                constraints: BoxConstraints(),
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                fillColor: recentactivity ? kred : kwhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'Recent Activities',
                                  style: customtext(
                                    fs14,
                                    recentactivity ? kwhite : kred,
                                    FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.w(10),
                            ),
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    recentactivity = false;
                                    todolist = true;
                                  });
                                },
                                constraints: BoxConstraints(),
                                fillColor: todolist ? kred : kwhite,
                                padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  side: BorderSide(
                                    color: kgrey
                                  )
                                ),
                                child: Text(
                                  'To Do List',
                                  style: customtext(
                                    fs14,
                                    todolist ? kwhite : kred,
                                    FontWeight.w500
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.h(5)
                        ),
                        if(recentactivity == true && todolist == false)
                        recentactivitycolumn(),
                        if(recentactivity == false && todolist == true)
                        recentactivitycolumn(),
                        SizedBox(
                          height: SizeConfig.h(5)
                        )
                      ],
                    ),
                  )
                ),
                SizedBox(
                  height: SizeConfig.h(20)
                )
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          height: SizeConfig.h(40),
          width: SizeConfig.w(40),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Createenquiry())
              );
            },
            shape: CircleBorder(),
            elevation: 10,
            backgroundColor: kred,
            child: Icon(
              Icons.add_circle_outline_rounded,
              color: kwhite,
              size: 30,
            ),
          ),
        ),
      )
    );
  }

  List<PieChartSectionData> _showingSections() {
    List<double> values = [50, 30, 20];
    List<Color> colors = [Colors.blue, Colors.greenAccent, Colors.orangeAccent];

    return List.generate(values.length, (i) {
      final double fontSize = fs6;
      final double radius = 15;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: '${values[i]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget rowdetails(
    String count,
    String title,
    Color color
  ) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.w(5)),
      child: RawMaterialButton(
        onPressed: () {},
        constraints: BoxConstraints.tightFor(
          height: SizeConfig.h(70),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          side: BorderSide(
            color: kgrey
          )
        ),
        padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: customtext(
                fs18,
                color,
                FontWeight.bold
              ),
            ),
            SizedBox(height: SizeConfig.h(2)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: customtext(
                fs12,
                color,
                FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recentactivitycolumn() {
    return Column(
      children: [
        recentactivitybox(
          'ID',
          'Customer Name',
          'Contact Number',
          'Status'
        ),
        recentactivitybox(
          'ID',
          'Customer Name',
          'Contact Number',
          'Status'
        ),
        recentactivitybox(
          'ID',
          'Customer Name',
          'Contact Number',
          'Status'
        ),
        recentactivitybox(
          'ID',
          'Customer Name',
          'Contact Number',
          'Status'
        ),recentactivitybox(
          'ID',
          'Customer Name',
          'Contact Number',
          'Status'
        ),
      ],
    );
  }

  Widget recentactivitybox(
    String id,
    String customername,
    String contactnumber,
    String status
  ) {
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
                          id,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          customername,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          contactnumber,
                          style: textmedium12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: SizeConfig.h(5)),
                        Text(
                          status,
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
                        onPressed: () {},
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
                      SizedBox(height: SizeConfig.h(5)),
                      RawMaterialButton(
                        onPressed: () {},
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
                  Container(
                    decoration: BoxDecoration(
                      color: kblue,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(5),vertical: SizeConfig.h(1)),
                    child: Text(
                      'Finance',
                      style: textmedium8,
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(4)),
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
