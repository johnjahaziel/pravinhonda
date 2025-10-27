import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {

  void _launchWebsite() async {
    final Uri url = Uri.parse('https://bluontech.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.only(right: 60),
        child: Drawer(
          backgroundColor: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuicontitle(
                    Icons.home_outlined,
                    "Home",
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.groups_2_outlined,
                    "About Pravin Honda",
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.menu_book_sharp,
                    'Catalog',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.calculate,
                    'EMI Calculator',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.edit_square,
                    'Task',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.person_search_outlined,
                    'Search Customer',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.change_circle_outlined,
                    'Exchange',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.sentiment_dissatisfied_outlined,
                    'Lost Customer',
                    () {},
                  ),
                  _buildDivider(),
                  menuicontitle(
                    Icons.support,
                    'Support',
                    () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 24,
                      color: kred,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: kred,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Developed & Maintained By ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs10
                        ),
                      ),
                      GestureDetector(
                        onTap: _launchWebsite,
                        child: Text(
                          'Bluon Tech',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fs10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey.withOpacity(0.4),
        height: 2,
      ),
    );
  }
}

menuicontitle(IconData icon, String title, VoidCallback onTap) => Padding(
  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
  child: ListTile(
    leading: Icon(
      icon,
      size: 22,
      color: kgrey,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: kgrey,
        fontSize: fs12
      ),
    ),
    onTap: onTap,
  ),
);