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

class Namevariantcolor extends StatefulWidget {
  final bool edit;

  final String modelnamee;
  // final String modelvariante;
  final String modelcolore;

  final String? selectedname;
  // final String? selectedvariant;
  final String? selectedcolor;

  final bool star;

  final void Function(String?) onNameChanged;
  // final void Function(String?) onVariantChanged;
  final void Function(String?) onColorChanged;

  const Namevariantcolor({
    super.key,
    this.edit = false,
    required this.modelnamee,
    // required this.modelvariante,
    required this.modelcolore,
    required this.selectedname,
    // required this.selectedvariant,
    required this.selectedcolor,
    required this.onNameChanged,
    // required this.onVariantChanged,
    required this.onColorChanged,
    this.star = false
  });

  @override
  State<Namevariantcolor> createState() => _NamevariantcolorState();
}

class _NamevariantcolorState extends State<Namevariantcolor> {
  List<Map<String, String>> modelnameitems = [];
  // List<Map<String, String>> modelvariantitems = [];
  List<Map<String, String>> modelcoloritems = [];

  String? selectedmodelnameitems;
  // String? selectedmodelvariantitems;
  String? selectedmodelcoloritems;

  @override
  void initState() {
    super.initState();

    selectedmodelnameitems = widget.selectedname;
    // selectedmodelvariantitems = widget.selectedvariant;
    selectedmodelcoloritems = widget.selectedcolor;

    fetchName().then((_) {
      if (selectedmodelnameitems != null) {
        final name = modelnameitems.firstWhere(
          (item) => item['name'] == selectedmodelnameitems,
          orElse: () => <String, String>{},
        );

        if (name.isNotEmpty && name['id'] != null) {
          // Directly fetch color using model id
          fetchColor(name['id']!);
        }
      }
    });
  }

  Future<void> fetchName() async {
    final nameUrl = Uri.parse('https://app.pravinhonda.com/api/models');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        nameUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> names = data['data'];

        setState(() {
          modelnameitems = names.map((item) {
            return {
              'id': item['model_id'].toString(),
              'name': item['model'].toString(),
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
        print("Failed to load names. Status code: ${response.statusCode}");
        print("Error: $data");

        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      print("Name fetch error: $e");
    }
  }

  // Future<void> fetchVariant(String nameCode) async {
  //   final variantUrl = Uri.parse('https://app.pravinhonda.com/api/variants/$nameCode');

  //   final token = BlocProvider.of<AuthCubit>(context).state.token;

  //   try {
  //     final response = await http.get(
  //       variantUrl,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //     );

  //     final Map<String, dynamic> data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> variants = data['data'];

  //       setState(() {
  //         modelvariantitems = variants.map((item) {
  //           return {
  //             'id': item['variant_id'].toString(),
  //             'name': item['variant'].toString(),
  //           };
  //         }).toList();
  //       });
  //     } else if(data['message'] == 'Token has expired') {
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.remove('token');

  //       BlocProvider.of<AuthCubit>(context).cleartoken();

  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (_) => Login()),
  //         (route) => false,
  //       );

  //       Fluttertoast.showToast(msg: data['message']);
  //     } else if(response.statusCode == 404) {

  //       Fluttertoast.showToast(msg: data['message']);

  //     } else {
  //       print("Failed to load variants. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Variant fetch error: $e");
  //   }
  // }

  Future<void> fetchColor(String modelCode) async {
    final colorUrl = Uri.parse('https://app.pravinhonda.com/api/colors/$modelCode');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.get(
        colorUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> colorData = data['data'];

        setState(() {
          modelcoloritems = colorData.map((item) {
            return {
              'id': item['color_id'].toString(),
              'name': item['color'].toString(),
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
        print("Failed to load variants. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Color fetch error: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNVCDropdown(
          title: 'Model Name',
          selectedCustomDropdown: selectedmodelnameitems,
          customDropdownItems: modelnameitems,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                selectedmodelnameitems = newValue;
                // selectedmodelvariantitems = null;
                selectedmodelcoloritems = null;
              });
              widget.onNameChanged(newValue);
              final name = modelnameitems.firstWhere(
                (item) => item['name'] == newValue,
                orElse: () => {},
              );

              final nameCode = name['id'];
              if (nameCode != null) {
                fetchColor(nameCode);
              }
            }
          },
          readOnly: widget.edit,
          star: widget.star,
        ),
        if(widget.modelnamee.isNotEmpty)
        errormessage(widget.modelnamee),
        // CustomNVCDropdown(
        //   title: 'Model Variant',
        //   selectedCustomDropdown: selectedmodelvariantitems,
        //   customDropdownItems: modelvariantitems,
        //   onChanged: (newValue) {
        //     if (newValue != null) {
        //       setState(() {
        //         selectedmodelvariantitems = newValue;
        //         selectedmodelcoloritems = null;
        //       });
        //       widget.onVariantChanged(newValue);
        //       final variant = modelvariantitems.firstWhere(
        //         (item) => item['name'] == newValue,
        //         orElse: () => {},
        //       );

        //       final variantCode = variant['id'];
        //       final name = modelnameitems.firstWhere(
        //         (item) => item['name'] == widget.selectedname,
        //         orElse: () => {},
        //       );

        //       final nameCode = name['id'];
        //       if (variantCode != null && nameCode != null) {
        //         fetchColor(nameCode, variantCode);
        //       }
        //     }
        //   },
        //   readOnly: widget.edit,
        // ),
        // if(widget.modelvariante.isNotEmpty)
        // errormessage(widget.modelvariante),
        CustomNVCDropdown(
          title: 'Model Color',
          selectedCustomDropdown: selectedmodelcoloritems,
          customDropdownItems: modelcoloritems,
          onChanged: (newValue) {
            setState(() {
              selectedmodelcoloritems = newValue;
            });
            widget.onColorChanged(newValue);
          },
          readOnly: widget.edit,
          star: widget.star,
        ),
        if(widget.modelcolore.isNotEmpty)
        errormessage(widget.modelcolore),
      ],
    );
  }
}


class CustomNVCDropdown extends StatelessWidget {
  final String title;
  final String? selectedCustomDropdown;
  final List<Map<String, String>> customDropdownItems;
  final Function(String?) onChanged;
  final bool padding;
  final bool star;
  final bool readOnly;

  const CustomNVCDropdown({
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