
import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? selectedCustomDropdown;
  final List<Map<String, String>> customDropdownItems;
  final Function(String?) onChanged;
  final bool padding;
  final bool star;
  final bool readOnly;

  const CustomDropdown({
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
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xff919EAB)
                    )
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: customDropdownItems.any((item) => item['value'] == selectedCustomDropdown) ? selectedCustomDropdown : null,
                      hint: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 137, 137, 137),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      icon: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      items: customDropdownItems.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Text(
                            item['label'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: onChanged,
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