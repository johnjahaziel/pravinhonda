import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Viewexchange extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  const Viewexchange({
    super.key,
    required this.apiResponse
  });

  @override
  State<Viewexchange> createState() => _ViewexchangeState();
}

class DealerField {
  String? selectedDealer;
  TextEditingController priceController;

  DealerField({
    this.selectedDealer,
    String price = '',
  }) : priceController = TextEditingController(text: price);
}

class _ViewexchangeState extends State<Viewexchange> {
  // late TextEditingController vehiclemodal; 
  late TextEditingController vehicleownername;
  late TextEditingController vehicleowneraddress;
  late TextEditingController vehicleownerphone;
  late TextEditingController presentmodelowned;
  late TextEditingController noofowners;
  late TextEditingController colour;
  late TextEditingController regno;
  late TextEditingController kmrun;
  late TextEditingController yearofpurchase;
  // late TextEditingController vehicleyear;
  late TextEditingController expectedprice;
  
  String? finalizeddealer;

  late TextEditingController finalizedprice;

  // String vehiclemodale = '';
  String vehicleownernamee = '';
  String vehicleowneraddresse = '';
  String vehicleownerphonee = '';
  String presentmodelownede = '';
  String noofownerse = '';
  String coloure = '';
  String regnoe = '';
  String kmrune = '';
  String yearofpurchasee = '';
  // String vehicleyeare = '';
  String expectedpricee = '';

  String finalizeddealere = '';
  String finalizedpricee = '';

  List<DealerField> dealers = [DealerField()];
  final int maxdealers = 10;

  Map<String, dynamic> buildDealerApiData() {
    final Map<String, dynamic> data = {};

    for (int i = 0; i < dealers.length; i++) {
      data['dealer_name${i + 1}'] = dealers[i].selectedDealer;
      data['price${i + 1}'] =
          dealers[i].priceController.text.trim();
    }

    return data;
  }

  bool readonly = true;

  @override
  void initState() {
    super.initState();
    // print('Api Response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    // vehiclemodal = TextEditingController(text: (enquiry['vehicle_model'] ?? '').toString());
    vehicleownername = TextEditingController(text: (enquiry['vehicle_owner_name'] ?? '').toString());
    vehicleowneraddress = TextEditingController(text: (enquiry['vehicle_owner_address'] ?? '').toString());
    vehicleownerphone = TextEditingController(text: (enquiry['vehicle_owner_phone'] ?? '').toString());
    presentmodelowned = TextEditingController(text: (enquiry['present_model_owned'] ?? '').toString());
    noofowners = TextEditingController(text: (enquiry['colour'] ?? '').toString());
    colour = TextEditingController(text: (enquiry['reg_no'] ?? '').toString());
    regno = TextEditingController(text: (enquiry['km_run'] ?? '').toString());
    kmrun = TextEditingController(text: (enquiry['year_of_purchase'] ?? '').toString());
    yearofpurchase = TextEditingController(text: (enquiry['no_of_owners'] ?? '').toString());
    // vehicleyear = TextEditingController(text: (enquiry['vehicle_year'] ?? '').toString());
    expectedprice = TextEditingController(text: (enquiry['expected_price'] ?? '').toString());

    finalizeddealer = enquiry['finalized_dealer'].toString();
    finalizedprice = TextEditingController(text: (enquiry['finalized_price'] ?? '').toString());

    dealers.clear();

    for (int i = 1; i <= maxdealers; i++) {
      final dealerNameKey = 'dealer_name$i';
      final priceKey = 'price$i';

      if (enquiry[dealerNameKey] != null &&
          enquiry[dealerNameKey].toString().isNotEmpty) {
        dealers.add(
          DealerField(
            selectedDealer: enquiry[dealerNameKey].toString(),
            price: (enquiry[priceKey] ?? '').toString(),
          ),
        );
      }
    }

    if (dealers.isEmpty) {
      dealers.add(DealerField());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        children: [
          // textfieldy(
          //   'Vehicle Modal',
          //   vehiclemodal,
          //   readonly: readonly
          // ),
          // if(vehiclemodale.isNotEmpty)
          // errormessage(vehiclemodale),
          textfieldy(
            'Vehicle Owner Name',
            vehicleownername,
            readonly: readonly
          ),
          if(vehicleownernamee.isNotEmpty)
          errormessage(vehicleownernamee),
          textfieldy(
            'Vehicle Owner Address',
            vehicleowneraddress,
            readonly: readonly
          ),
          if(vehicleowneraddresse.isNotEmpty)
          errormessage(vehicleowneraddresse),
          textfieldy(
            'Vehicle Owner Phone',
            vehicleownerphone,
            numpad: true,
            readonly: readonly
          ),
          if(vehicleownerphonee.isNotEmpty)
          errormessage(vehicleownerphonee),
          textfieldy(
            'Present Model Owned',
            presentmodelowned,
            readonly: readonly
          ),
          if(presentmodelownede.isNotEmpty)
          errormessage(presentmodelownede),
          textfieldy(
            'Colour',
            colour,
            readonly: readonly
          ),
          if(coloure.isNotEmpty)
          errormessage(coloure),
          textfieldy(
            'Reg No',
            regno,
            readonly: readonly
          ),
          if(regnoe.isNotEmpty)
          errormessage(regnoe),
          textfieldy(
            'KM Run',
            kmrun,
            readonly: readonly
          ),
          if(kmrune.isNotEmpty)
          errormessage(kmrune),
          textfieldy(
            'Year Of Purchase',
            yearofpurchase,
            readonly: readonly
          ),
          if(yearofpurchasee.isNotEmpty)
          errormessage(yearofpurchasee),
          textfieldy(
            'No of Owners',
            noofowners,
            readonly: readonly
          ),
          if(noofownerse.isNotEmpty)
          errormessage(noofownerse),
          // textfieldy(
          //   'Vehicle Year',
          //   vehicleyear,
          //   readonly: readonly
          // ),
          // if(vehicleyeare.isNotEmpty)
          // errormessage(vehicleyeare),
          textfieldy(
            'Expected Price',
            expectedprice,
            readonly: readonly
          ),
          if(expectedpricee.isNotEmpty)
          errormessage(expectedpricee),


          Column(
            children: [
              ListView.builder(
                itemCount: dealers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Dealerdropdown(
                              title: 'Dealer ${index + 1}',
                              selectedDealer: dealers[index].selectedDealer,
                              onChanged: (value) {
                                setState(() {
                                  dealers[index].selectedDealer = value;
                                });
                              },
                              readonly: readonly,
                            ),
                            textfieldy(
                              'Price ${index + 1}',
                              dealers[index].priceController,
                              numpad: true,
                              star: false,
                              readonly: readonly
                            ),
                          ],
                        ),

                        if(readonly == false)
                        if (dealers.length > 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  dealers.removeAt(index);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(10)),

              if(readonly == false)
              if (dealers.length < maxdealers)
              OutlinedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(2)
                    )
                  )
                ),
                onPressed: () {
                  setState(() {
                    dealers.add(DealerField());
                  });
                },
                child: Text(
                  'Add Another Dealer',
                  style: textmedium12.copyWith(
                    color: kred
                  ),
                ),
              ),
            ],
          ),
          Dealerdropdown(
            title: 'Finalized Dealer',
            selectedDealer: finalizeddealer,
            onChanged: (value) {
              setState(() {
                finalizeddealer = value;
              });
            },
            readonly: readonly,
          ),
          if(finalizeddealere.isNotEmpty)
          errormessage(finalizeddealere),
          textfieldy(
            'Finalised Price',
            finalizedprice,
            readonly: readonly,
            star: false
          ),
          if(finalizedpricee.isNotEmpty)
          errormessage(finalizedpricee),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}