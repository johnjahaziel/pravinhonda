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
  TextEditingController nameController;
  TextEditingController priceController;

  DealerField({
    String name = '',
    String price = '',
  })  : nameController = TextEditingController(text: name),
        priceController = TextEditingController(text: price);
}

class _ViewexchangeState extends State<Viewexchange> {
  late TextEditingController vehiclemodal;
  late TextEditingController vehiclemodalyr;
  late TextEditingController noofowners;
  late TextEditingController expectedprice;
  late TextEditingController assessedby;
  late TextEditingController finalizeddealer;
  late TextEditingController finalizedprice;

  String vehiclemodale = '';
  String vehiclemodalyre = '';
  String noofownerse = '';
  String expectedpricee = '';
  String assessedbye = '';

  String finalizeddealere = '';
  String finalizedpricee = '';

  List<DealerField> dealers = [DealerField()];
  final int maxdealers = 10;

  Map<String, dynamic> buildDealerApiData() {
    final Map<String, dynamic> data = {};

    for (int i = 0; i < dealers.length; i++) {
      data['dealer_name${i + 1}'] =
          dealers[i].nameController.text.trim();
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

    vehiclemodal = TextEditingController(text: (enquiry['vehicle_model'] ?? '').toString());
    vehiclemodalyr = TextEditingController(text: (enquiry['vehicle_year'] ?? '').toString());
    noofowners = TextEditingController(text: (enquiry['no_of_owners'] ?? '').toString());
    expectedprice = TextEditingController(text: (enquiry['expected_price'] ?? '').toString());
    assessedby = TextEditingController(text: (enquiry['assessed_by'] ?? '').toString());
    finalizeddealer = TextEditingController(text: (enquiry['finalized_dealer'] ?? '').toString());
    finalizedprice = TextEditingController(text: (enquiry['finalized_price'] ?? '').toString());

    dealers.clear();

    for (int i = 1; i <= maxdealers; i++) {
      final dealerNameKey = 'dealer_name$i';
      final priceKey = 'price$i';

      if (enquiry[dealerNameKey] != null &&
          enquiry[dealerNameKey].toString().isNotEmpty) {
        dealers.add(
          DealerField(
            name: enquiry[dealerNameKey].toString(),
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
          textfieldy(
            'Vehicle Modal',
            vehiclemodal,
            readonly: readonly
          ),
          if(vehiclemodale.isNotEmpty)
          errormessage(vehiclemodale),
          textfieldy(
            'Vehicle Year',
            vehiclemodalyr,
            readonly: readonly
          ),
          if(vehiclemodalyre.isNotEmpty)
          errormessage(vehiclemodalyre),
          textfieldy(
            'No of Owners',
            noofowners,
            readonly: readonly
          ),
          if(noofownerse.isNotEmpty)
          errormessage(noofownerse),
          textfieldy(
            'Expected Price',
            expectedprice,
            readonly: readonly
          ),
          if(expectedpricee.isNotEmpty)
          errormessage(expectedpricee),
          textfieldy(
            'Assessed By',
            assessedby,
            star: false,
            readonly: readonly
          ),
          if(assessedbye.isNotEmpty)
          errormessage(assessedbye),

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
                            textfieldy(
                              'Dealer ${index + 1}',
                              dealers[index].nameController,
                              star: false,
                              readonly: readonly
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
          textfieldy(
            'Finalised Dealer',
            finalizeddealer,
            readonly: readonly,
            star: false
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