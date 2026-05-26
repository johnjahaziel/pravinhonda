import 'package:flutter/material.dart';
import 'package:pravinhonda/pdimanager/customdrawer.dart';
import 'package:pravinhonda/pdimanager/mainscreens/accepted.dart';
import 'package:pravinhonda/pdimanager/mainscreens/allocated.dart';
import 'package:pravinhonda/pdimanager/mainscreens/completed.dart';
import 'package:pravinhonda/pdimanager/mainscreens/deliverypdi.dart';
import 'package:pravinhonda/pdimanager/mainscreens/waitingforaccept.dart';
import 'package:pravinhonda/pdimanager/mainscreens/working.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PdiNavEntry {
  final String accessKey;
  final Widget screen;
  final IconData icon;
  final String label;
  const _PdiNavEntry(this.accessKey, this.screen, this.icon, this.label);
}

const List<_PdiNavEntry> _allPdiNavEntries = [
  _PdiNavEntry('Waiting', Waitingforaccept(), Icons.hourglass_empty, 'Waiting'),
  _PdiNavEntry('Accepted', Accepted(), Icons.check_box_outline_blank, 'Accepted'),
  _PdiNavEntry('Allocated Helper', Allocated(), Icons.help_outline, 'Allocated Helper'),
  _PdiNavEntry('Working', Working(), Icons.work_outline, 'Working'),
  _PdiNavEntry('Completed', Completed(), Icons.check_circle_outline, 'Completed'),
  _PdiNavEntry('Delivered', DeliveryPdi(), Icons.trolley, 'Delivered'),
];

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
  List<_PdiNavEntry> entries = const [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _loadAccess();
  }

  Future<void> _loadAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getStringList('access_list');
    if (!mounted) return;

    final filtered = access == null
        ? _allPdiNavEntries
        : _allPdiNavEntries.where((e) => access.contains(e.accessKey)).toList();

    final list = filtered.isEmpty ? _allPdiNavEntries : filtered;
    final start = list.length == 1
        ? 0
        : widget.initialIndex.clamp(0, list.length - 1);

    setState(() {
      entries = list;
      currentIndex = start;
    });
    pageController.jumpToPage(start);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    if (entries.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: appBar(),
          body: Center(child: CircularProgressIndicator(color: kred)),
        ),
      );
    }

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
          children: entries.map((e) => e.screen).toList(),
        ),
        bottomNavigationBar: SizedBox(
          height: SizeConfig.h(55),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: kred,
            unselectedItemColor: const Color.fromARGB(255, 50, 50, 50),
            selectedFontSize: fs10,
            unselectedFontSize: fs8,
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
            items: entries
                .map((e) => BottomNavigationBarItem(
                      icon: Icon(e.icon),
                      label: e.label,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
