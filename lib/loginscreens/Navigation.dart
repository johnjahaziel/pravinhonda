import 'package:flutter/material.dart';
import 'package:pravinhonda/loginscreens/forms/creating/createenquiry.dart';
import 'package:pravinhonda/loginscreens/mainscreens/booking.dart';
import 'package:pravinhonda/loginscreens/mainscreens/delivery.dart';
import 'package:pravinhonda/loginscreens/mainscreens/enquiry.dart';
import 'package:pravinhonda/loginscreens/mainscreens/homescreen.dart';
import 'package:pravinhonda/loginscreens/mainscreens/pdi.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Navigation extends StatefulWidget {
  final int initialIndex;
  const Navigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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
        drawer: Customdrawer(),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            Homescreen(),
            Enquiry(),
            Booking(),
            Pdi(),
            Delivery(),
          ],
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
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_quote_outlined),
                label: 'Enquiry',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_outlined),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.handyman_outlined),
                label: 'PDI',
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

// void _showpopupmobilenumber(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//           'Mobile Number',
//           style: customtext(
//             fs16,
//             kblack,
//             FontWeight.w600
//           ),
//         ),
//         content: Text(
//           'Please update your mobile number to proceed further.',
//           style: customtext(
//             fs14,
//             kblack,
//             FontWeight.w400
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'OK',
//               style: customtext(
//                 fs14,
//                 kred,
//                 FontWeight.w500
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }