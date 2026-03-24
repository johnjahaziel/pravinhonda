import 'package:flutter/material.dart';
import 'package:pravinhonda/salesexecutive/districtcity.dart';
import 'package:pravinhonda/salesexecutive/namevariantcolor.dart';
import 'package:pravinhonda/utility/customs/customdatefield.dart';

class Filterscreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const Filterscreen({super.key, this.initialFilters});

  @override
  State<Filterscreen> createState() => _FilterscreenState();
}

class _FilterscreenState extends State<Filterscreen> {
  late TextEditingController mobileCtrl;
  late TextEditingController datecontroller;

  String? selecteddistrictitems;
  String? selectedcityitems;

  String? selectedmodelnameitems;
  String? selectedmodelcoloritems;

  List<String> finance = [];
  List<String> exchange = [];
  List<String> testRide = [];
  List<String> gender = [];
  List<String> status = [];

  @override
  void initState() {
    super.initState();

    final data = widget.initialFilters ?? {};

    mobileCtrl = TextEditingController(text: data["mobile"] ?? "");
    datecontroller = TextEditingController(
      text: data["date"] ?? "",
    );

    selecteddistrictitems = data["district"];
    selectedcityitems = data["city"];

    selectedmodelnameitems = data["model"];
    selectedmodelcoloritems = data["color"];

    finance = List<String>.from(data["finance"] ?? []);
    exchange = List<String>.from(data["exchange"] ?? []);
    testRide = List<String>.from(data["testRide"] ?? []);
    gender = List<String>.from(data["gender"] ?? []);
    status = List<String>.from(data["status"] ?? []);
  }

  Widget chipSelector(
    String title,
    List<String> options,
    List<String> selectedList,
    Function(List<String>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((e) {
            final isSelected = selectedList.contains(e);

            return FilterChip(
              label: Text(e),
              selected: isSelected,
              onSelected: (_) {
                List<String> newList = List.from(selectedList);

                if (isSelected) {
                  newList.remove(e); // unselect
                } else {
                  newList.add(e); // select
                }

                onChanged(newList);
              },
              selectedColor: Colors.red.shade100,
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context,<String, dynamic>{}); // clear filters
                },
                child: Text("Clear"),
              )
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  /// DATE
                  buildCard(
                    TaskUp(
                      title: "Follow up",
                      datecontroller: datecontroller,
                      star: false,
                    )
                  ),

                  /// TEXT INPUTS
                  buildCard(
                    Column(
                      children: [
                        TextField(
                          controller: mobileCtrl,
                          decoration: InputDecoration(labelText: "Mobile No"),
                        ),

                        const SizedBox(height: 12),

                        Districtcity(
                          districte: '',
                          citye: '',
                          selecteddistrict: selecteddistrictitems,
                          selectedcity: selectedcityitems,
                          ondistrictChanged: (value) {
                            setState(() {
                              selecteddistrictitems = value;
                              selectedcityitems = null;
                            });
                          },
                          oncityChanged: (value) {
                            setState(() {
                              selectedcityitems = value;
                            });
                          },
                          edit: false,
                          star: false,
                        ),

                        const SizedBox(height: 12),

                        /// MODEL + COLOR
                        Namevariantcolor(
                          modelnamee: '',
                          modelcolore: '',
                          selectedname: selectedmodelnameitems,
                          selectedcolor: selectedmodelcoloritems,
                          onNameChanged: (value) {
                            setState(() {
                              selectedmodelnameitems = value;
                            });
                          },
                          onColorChanged: (value) {
                            setState(() {
                              selectedmodelcoloritems = value;
                            });
                          },
                          edit: false,
                          star: false,
                        ),
                      ],
                    ),
                  ),

                  /// CHIPS
                  buildCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chipSelector("Finance", ["cash", "finance"], finance,
                            (v) => setState(() => finance = v)),

                        chipSelector("Exchange", ["yes", "no"], exchange,
                            (v) => setState(() => exchange = v)),

                        chipSelector("Test Ride", ["yes", "no"], testRide,
                            (v) => setState(() => testRide = v)),

                        chipSelector("Gender", ["Male", "Female"], gender,
                            (v) => setState(() => gender = v)),

                        chipSelector(
                          "Status",
                          [
                            "Enquiry",
                            "Waiting for approval",
                            "Booking",
                            "Sales pdi approval",
                            "Accepted",
                            "Allocated helper",
                            "Working",
                            "Completed",
                            "Delivery",
                            "Lost customer",
                          ],
                          status,
                            (v) => setState(() => status = v)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// APPLY BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop<Map<String, dynamic>>(context, {
                  "date": datecontroller.text,
                  "district": selecteddistrictitems,
                  "city": selectedcityitems,
                  "model": selectedmodelnameitems,
                  "color": selectedmodelcoloritems,
                  "mobile": mobileCtrl.text,
                  "finance": finance,
                  "exchange": exchange,
                  "testRide": testRide,
                  "gender": gender,
                  "status": status,
                });
              },
              child: Text("Apply Filters", style: TextStyle(color: Colors.white)),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}