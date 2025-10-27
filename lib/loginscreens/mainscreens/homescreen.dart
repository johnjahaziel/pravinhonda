import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: AspectRatio(
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
                          ),
                          Flexible(
                            child: AspectRatio(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
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
}

