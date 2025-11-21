import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Customdatefield extends StatefulWidget {
  final String title;
  final TextEditingController datecontroller;
  final bool padding;
  final bool star;

  const Customdatefield({
    super.key,
    required this.title,
    required this.datecontroller,
    this.padding = false,
    this.star = true
    });

  @override
  State<Customdatefield> createState() => _CustomdatefieldState();
}

class _CustomdatefieldState extends State<Customdatefield> {

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kred,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kred,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        widget.datecontroller.text = formattedDate;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xff919EAB)
                  ),
                ),
                if(widget.star)
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
            child: TextField(
              controller: widget.datecontroller,
              keyboardType: TextInputType.datetime,
              maxLines: 1,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kgrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kgrey),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: _selectDate,
                ),
                hintText: "dd-mm-yyyy",
                hintStyle: TextStyle(
                  fontSize: fs10
                )
              ),
              onChanged: (value) {
                if (value.length == 10) {
                  try {
                    DateTime dob = DateFormat("dd-MM-yyyy").parseStrict(value);
      
                    if (dob.isAfter(DateTime.now())) {
                      Fluttertoast.showToast(msg: "Date cannot be in the future");
                      widget.datecontroller.clear();
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: "Invalid date format or value");
                    widget.datecontroller.clear();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}