import 'package:flutter/material.dart';
import 'package:pravinhonda/pdimanager/customdrawer.dart';
import 'package:pravinhonda/rtomanager/mainscreens/accepted.dart';
import 'package:pravinhonda/rtomanager/mainscreens/completedRTO.dart';
import 'package:pravinhonda/rtomanager/mainscreens/pending.dart';
import 'package:pravinhonda/rtomanager/mainscreens/readyforregistration.dart';
import 'package:pravinhonda/rtomanager/mainscreens/waitingfornoplate.dart';
import 'package:pravinhonda/rtomanager/mainscreens/waitingforrccard.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RtoNavEntry {
  final String accessKey;
  final Widget screen;
  final IconData icon;
  final String label;
  const _RtoNavEntry(this.accessKey, this.screen, this.icon, this.label);
}

const List<_RtoNavEntry> _allRtoNavEntries = [
  _RtoNavEntry('Pending', PendingRTO(), Icons.hourglass_empty, 'Pending'),
  _RtoNavEntry('Accepted', AcceptedRTO(), Icons.check_box_outline_blank, 'Accepted'),
  _RtoNavEntry('Ready For Registration', ReadyforregistrationRTO(), Icons.help_outline, 'Ready for Registration'),
  _RtoNavEntry('No Plate', WaitingfornoplateRTO(), Icons.work_outline, 'No plate'),
  _RtoNavEntry('RC Card', WaitingforrccardRTO(), Icons.card_giftcard, 'RC Card'),
  _RtoNavEntry('Completed', Completedrto(), Icons.check_circle_outline, 'Completed'),
];

class NavigationRTO extends StatefulWidget {
  final int initialIndex;
  const NavigationRTO({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NavigationRTO> createState() => _NavigationRTOState();
}

class _NavigationRTOState extends State<NavigationRTO> {
  late PageController pageController;
  int currentIndex = 0;
  List<_RtoNavEntry> entries = const [];

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
        ? _allRtoNavEntries
        : _allRtoNavEntries.where((e) => access.contains(e.accessKey)).toList();

    final list = filtered.isEmpty ? _allRtoNavEntries : filtered;
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
