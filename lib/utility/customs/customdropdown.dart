
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? selectedCustomDropdown;
  final List<Map<String, String>> customDropdownItems;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.selectedCustomDropdown,
    required this.customDropdownItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              // Text(
              //   '*',
              //   style: TextStyle(
              //     fontFamily: 'Poppins',
              //     color: kred
              //   ),
              // ),
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
                value: selectedCustomDropdown,
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
                      item['label']!,
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
    );
  }
}