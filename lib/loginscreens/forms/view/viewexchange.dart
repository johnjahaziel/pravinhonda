import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';

class Viewexchange extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Viewexchange({
    super.key,
    required this.apiResponse
  });

  @override
  State<Viewexchange> createState() => _ViewexchangeState();
}

class _ViewexchangeState extends State<Viewexchange> {
  late TextEditingController name;
  late TextEditingController address;
  late TextEditingController vehiclemodal;
  late TextEditingController newvehiclemodal;
  late TextEditingController expectedprice;
  late TextEditingController finalizedprice;
  late TextEditingController assessedby;

  String namee = '';
  String addresse = '';
  String vehiclemodale = '';
  String newvehiclemodale = '';
  String expectedpricee = '';
  String finalizedpricee = '';
  String assessedbye = '';

  bool readonly = true;

  @override
  void initState() {
    super.initState();
    // print('Api Response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    name = TextEditingController(text: (enquiry['exchange_name'] ?? '').toString());
    address = TextEditingController(text: (enquiry['exchange_address'] ?? '').toString());
    vehiclemodal = TextEditingController(text: (enquiry['vehicle_model'] ?? '').toString());
    newvehiclemodal = TextEditingController(text: (enquiry['new_vehicle_model'] ?? '').toString());
    expectedprice = TextEditingController(text: (enquiry['expected_price'] ?? '').toString());
    finalizedprice = TextEditingController(text: (enquiry['finalized_price'] ?? '').toString());
    assessedby = TextEditingController(text: (enquiry['assessed_by'] ?? '').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        children: [
          textfieldy(
            'Name',
            name,
            readonly: readonly,
          ),
          if(namee.isNotEmpty)
          errormessage(namee),
          description(
            'Address',
            address,
            star: true,
            readonly: readonly,
          ),
          if(addresse.isNotEmpty)
          errormessage(addresse),
          textfieldy(
            'Vehicle Modal',
            vehiclemodal,
            readonly: readonly,
          ),
          if(vehiclemodale.isNotEmpty)
          errormessage(vehiclemodale),
          textfieldy(
            'New Vehicle Modal',
            newvehiclemodal,
            readonly: readonly,
          ),
          if(newvehiclemodale.isNotEmpty)
          errormessage(newvehiclemodale),
          textfieldy(
            'Expected Price',
            expectedprice,
            readonly: readonly,
          ),
          if(expectedpricee.isNotEmpty)
          errormessage(expectedpricee),
          textfieldy(
            'Finalized Price',
            finalizedprice,
            readonly: readonly,
          ),
          if(finalizedpricee.isNotEmpty)
          errormessage(finalizedpricee),
          textfieldy(
            'Assessed By',
            assessedby,
            readonly: readonly,
          ),
          if(assessedbye.isNotEmpty)
          errormessage(assessedbye),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}