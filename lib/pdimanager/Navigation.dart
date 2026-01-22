import 'package:flutter/material.dart';
import 'package:pravinhonda/pdimanager/customdrawer.dart';
import 'package:pravinhonda/pdimanager/mainscreens/accepted.dart';
import 'package:pravinhonda/pdimanager/mainscreens/allocated.dart';
import 'package:pravinhonda/pdimanager/mainscreens/completed.dart';
import 'package:pravinhonda/pdimanager/mainscreens/deliverypdi.dart';
import 'package:pravinhonda/pdimanager/mainscreens/sparedept.dart';
import 'package:pravinhonda/pdimanager/mainscreens/waitingforaccept.dart';
import 'package:pravinhonda/pdimanager/mainscreens/working.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class NavigationPdi extends StatefulWidget {
  final int initialIndex;
  const NavigationPdi({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NavigationPdi> createState() => _NavigationPdiState();
}

class _NavigationPdiState extends State<NavigationPdi> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        drawer: CustomdrawerPdi(),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            Waitingforaccept(),
            Accepted(),
            Allocated(),
            Sparedept(),
            Working(),
            Completed(),
            DeliveryPdi()
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: SizeConfig.h(55),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: kred,
            unselectedItemColor: const Color.fromARGB(255, 50, 50, 50),
            selectedFontSize: fs10,
            unselectedFontSize:fs8,
            backgroundColor: kwhite,
            unselectedLabelStyle: TextStyle(
              color: kblack,
            ),
            onTap: (index) {
              setState(() {
                currentIndex = index;
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_empty),
                label: 'Waiting',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outline_blank),
                label: 'Accepted',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help_outline),
                label: 'Allocated Helper',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build_circle_outlined),
                label: 'Spare Dept',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                label: 'Working',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Completed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trolley),
                label: 'Delivery',
              ),
            ],
          ),
        ),
      ),
    );
  }
}