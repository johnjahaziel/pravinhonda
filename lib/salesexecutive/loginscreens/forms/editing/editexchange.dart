import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/forms/editing/createquotation.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Editexchange extends StatefulWidget {
  final int enquiryid;
  final Map<String, dynamic> apiResponse;

  final bool edit;
  const Editexchange({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
    required this.edit
  });

  @override
  State<Editexchange> createState() => _EditexchangeState();
}

class DealerField {
  String? selectedDealer;
  TextEditingController priceController;

  DealerField({
    this.selectedDealer,
    String price = '',
  }) : priceController = TextEditingController(text: price);
}

class _EditexchangeState extends State<Editexchange> {
  late TextEditingController vehiclemodal;
  late TextEditingController vehiclemodalyr;
  late TextEditingController noofowners;
  late TextEditingController expectedprice;
  late TextEditingController assessedby;

  String? finalizeddealer;

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
      data['dealer_name${i + 1}'] = dealers[i].selectedDealer;
      data['price${i + 1}'] =
          dealers[i].priceController.text.trim();
    }

    return data;
  }

  @override
  void initState() {
    super.initState();
    // print('Api Response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp['data'] ?? {};

    vehiclemodal = TextEditingController(text: (enquiry['vehicle_model'] ?? '').toString());
    vehiclemodalyr = TextEditingController(text: (enquiry['vehicle_year'] ?? '').toString());
    noofowners = TextEditingController(text: (enquiry['no_of_owners'] ?? '').toString());
    expectedprice = TextEditingController(text: (enquiry['expected_price'] ?? '').toString());
    assessedby = TextEditingController(text: (enquiry['assessed_by'] ?? '').toString());
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

  Future<void> exchangeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/enquiries/${widget.enquiryid}');

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'vehicle_model': vehiclemodal.text,
          'vehicle_year': vehiclemodalyr.text,
          'no_of_owners' : noofowners.text,
          'expected_price': expectedprice.text,
          
          'assessed_by': assessedby.text,

          'finalized_dealer': finalizeddealer,
          'finalized_price': finalizedprice.text,

          ...buildDealerApiData(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('response data: $responseData');

        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => QuotationSuccessPopup(
                  name: '${responseData['data']['customer_name']}',
                  number: '${responseData['data']['customer_contact_number']}',
                  enquiryid: responseData['data']['enquiry_id'],
                ),
              );
          },
          nextpage: 'Quotation'
        );

      } else if (response.statusCode == 422) {
        final errors = responseData['errors'] ?? {};

        setState(() {
          vehiclemodale = errors['vehicle_model']?.toString() ?? '';
          vehiclemodalyre = errors['vehicle_year']?.toString() ?? '';
          noofownerse = errors['no_of_owners']?.toString() ?? '';
          expectedpricee = errors['expected_price']?.toString() ?? '';

          assessedbye = errors['assessed_by']?.toString() ?? '';

          finalizeddealere = errors['finalized_dealer']?.toString() ?? '';
          finalizedpricee = errors['finalized_price']?.toString() ?? '';
        });

        Fluttertoast.showToast(msg: responseData['message']);
        print(response.body);
      } else {
        showMessagePopup(
          context,
          responseData['message'],
          () {
            Navigator.pop(context);
          }
        );
        print(response.body);
      }
    } catch (error) {
      print('Error submitting finance form: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            children: [
              textfieldy(
                'Vehicle Modal',
                vehiclemodal,
                readonly: widget.edit
              ),
              if(vehiclemodale.isNotEmpty)
              errormessage(vehiclemodale),
              textfieldy(
                'Vehicle Year',
                vehiclemodalyr,
                readonly: widget.edit
              ),
              if(vehiclemodalyre.isNotEmpty)
              errormessage(vehiclemodalyre),
              textfieldy(
                'No of Owners',
                noofowners,
                readonly: widget.edit
              ),
              if(noofownerse.isNotEmpty)
              errormessage(noofownerse),
              textfieldy(
                'Expected Price',
                expectedprice,
                readonly: widget.edit
              ),
              if(expectedpricee.isNotEmpty)
              errormessage(expectedpricee),
              textfieldy(
                'Assessed By',
                assessedby,
                star: false,
                readonly: widget.edit
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
                                Dealerdropdown(
                                  title: 'Dealer ${index + 1}',
                                  selectedDealer: dealers[index].selectedDealer,
                                  onChanged: (value) {
                                    setState(() {
                                      dealers[index].selectedDealer = value;
                                    });
                                  },
                                  readonly: widget.edit,
                                ),
                                textfieldy(
                                  'Price ${index + 1}',
                                  dealers[index].priceController,
                                  numpad: true,
                                  star: false,
                                  readonly: widget.edit
                                ),
                              ],
                            ),

                            if(widget.edit == false)
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

                  if(widget.edit == false)
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
                readonly: widget.edit,
              ),
              if(finalizeddealere.isNotEmpty)
              errormessage(finalizeddealere),
              textfieldy(
                'Finalised Price',
                finalizedprice,
                readonly: widget.edit,
                star: false
              ),
              if(finalizedpricee.isNotEmpty)
              errormessage(finalizedpricee),
              SizedBox(height: SizeConfig.h(10)),
              button(
                'Submit',
                () {
                  exchangeform();
                },
              ),
              SizedBox(height: SizeConfig.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}