import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/login.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Districtcity extends StatefulWidget {
  final String? selecteddistrict;
  final String? selectedcity;

  final String districte;
  final String citye;

  final bool edit;

  final void Function(String?) ondistrictChanged;
  final void Function(String?) oncityChanged;

  const Districtcity({
    super.key,
    this.edit = false,
    required this.districte,
    required this.citye,
    required this.selecteddistrict,
    required this.selectedcity,
    required this.ondistrictChanged,
    required this.oncityChanged,
  });

  @override
  State<Districtcity> createState() => _DistrictcityState();
}

class _DistrictcityState extends State<Districtcity> {
  String districte = '';
  String citye = '';

  String? selecteddistrictitems;
  String? selectedcityitems;

  List<Map<String, String>> districtitems = [];
  List<Map<String, String>> cityitems = [];

  @override
  void initState() {
    super.initState();

    selecteddistrictitems = widget.selecteddistrict;
    selectedcityitems = widget.selectedcity;

    fetchdistrict().then((_) {
      if (selecteddistrictitems != null && districtitems.isNotEmpty) {

        final name = districtitems.firstWhere(
          (item) => item['name'] == selecteddistrictitems,
          orElse: () => <String, String>{},
        );

        if (name.isNotEmpty && name['id'] != null) {
          fetchcity(name['id']!);
        }
      }
    });
  }

  Future<void> fetchdistrict() async {
    final districtUrl = Uri.parse('https://app.pravinhonda.com/api/districts');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        districtUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> districts = data['data'];

        setState(() {
          districtitems = districts.map((item) {
            return {
              'id': item['district_code'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
        });
      } else if(data['message'] == 'Token has expired') {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');

        BlocProvider.of<AuthCubit>(context).cleartoken();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
        );

        Fluttertoast.showToast(msg: data['message']);
      } else if(response.statusCode == 404) {

        Fluttertoast.showToast(msg: data['message']);

      } else {
        print("Failed to load districts. Status code: ${response.statusCode}");
        print("Error: $data");

        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      print("District fetch error: $e");
    }
  }

  Future<void> fetchcity(String districtCode) async {
    final cityUrl = Uri.parse('https://app.pravinhonda.com/api/villages?district_code=$districtCode');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        cityUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> citys = data['data'];

        setState(() {
          cityitems = citys.map((item) {
            return {
              'id': item['village_code'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
        });
      } else if(data['message'] == 'Token has expired') {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');

        BlocProvider.of<AuthCubit>(context).cleartoken();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
        );

        Fluttertoast.showToast(msg: data['message']);
      } else if(response.statusCode == 404) {

        Fluttertoast.showToast(msg: data['message']);

      } else {
        print("Failed to load citys. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("City fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDCDropdown(
          title: 'District',
          selectedCustomDropdown: selecteddistrictitems,
          customDropdownItems:districtitems,
          onChanged: (newValue) {
            setState(() {
              selecteddistrictitems = newValue;
              selectedcityitems = null;
            });

            final selected = districtitems.firstWhere(
              (item) => item['name'] == newValue,
              orElse: () => {},
            );

            if (selected.isNotEmpty && selected['id'] != null) {
              fetchcity(selected['id']!);
            }

            widget.ondistrictChanged(newValue);
          },
          readOnly: widget.edit,
        ),
        if(widget.districte.isNotEmpty)
        errormessage(widget.districte),
        CustomDCDropdown(
          title: 'City',
          selectedCustomDropdown: selectedcityitems,
          customDropdownItems: cityitems,
          onChanged: (newValue) {
            setState(() {
              selectedcityitems = newValue;
            });
            widget.oncityChanged(newValue);
          },
          readOnly: widget.edit,
        ),
        if(widget.citye.isNotEmpty)
        errormessage(widget.citye),
      ],
    );
  }
}

class CustomDCDropdown extends StatelessWidget {
  final String title;
  final String? selectedCustomDropdown;
  final List<Map<String, String>> customDropdownItems;
  final Function(String?) onChanged;
  final bool padding;
  final bool star;
  final bool readOnly;

  const CustomDCDropdown({
    super.key,
    required this.title,
    required this.selectedCustomDropdown,
    required this.customDropdownItems,
    required this.onChanged,
    this.padding = false,
    this.star = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Padding(
      padding: padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(30)) : EdgeInsetsGeometry.zero,
      child: Opacity(
        opacity: readOnly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: readOnly,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff919EAB),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    value: selectedCustomDropdown,
                    items: customDropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['name'],
                        child: Text(
                          item['name']!,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                
                    onChanged: onChanged,
                
                    buttonStyleData: ButtonStyleData(
                      height: 58,
                      padding: EdgeInsets.only(right: SizeConfig.w(12)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff919EAB)),
                      ),
                    ),
                
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                
                    dropdownSearchData: DropdownSearchData(
                      searchController: searchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value!
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}