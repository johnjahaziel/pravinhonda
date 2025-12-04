import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/login.dart';
import 'package:pravinhonda/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
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
        CustomNVCDropdown(
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
        CustomNVCDropdown(
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