import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class TimeField extends StatefulWidget {
  final String title;
  final TextEditingController timeController;
  final bool padding;
  final bool star;
  final bool readOnly;

  const TimeField({
    super.key,
    required this.title,
    required this.timeController,
    this.padding = false,
    this.star = true,
    this.readOnly = false,
  });

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

    if (pickedTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      final formattedTime = DateFormat('HH:mm').format(dateTime);
      setState(() {
        widget.timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding
          ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20))
          : EdgeInsets.zero,
      child: Opacity(
        opacity: widget.readOnly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: widget.readOnly,
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
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff919EAB),
                      ),
                    ),
                    if (widget.star)
                      Text(
                        '*',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kred,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: widget.timeController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    TimeInputFormatter(),
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
                      icon: const Icon(Icons.access_time),
                      onPressed: _selectTime,
                    ),
                    hintText: "HH:mm",
                    hintStyle: TextStyle(fontSize: fs10),
                  ),
                  onChanged: (value) {
                    if (value.length == 5) {
                      final reg = RegExp(
                          r'^([0-1][0-9]|2[0-3]):[0-5][0-9]$'); // 00:00–23:59
                      if (!reg.hasMatch(value)) {
                        Fluttertoast.showToast(
                            msg: "Invalid time. Use 00:00 to 23:59");
                        widget.timeController.clear();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String formatted = '';
    if (digits.length <= 2) {
      formatted = digits;
    } else {
      formatted = digits.substring(0, 2) + ':' + digits.substring(2);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
