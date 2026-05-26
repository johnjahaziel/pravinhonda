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

class EditexchangeMB extends StatefulWidget {
  final String enquiryid;
  final Map<String, dynamic> apiResponse;

  final bool edit;
  const EditexchangeMB({
    super.key,
    required this.enquiryid,
    required this.apiResponse,
    required this.edit
  });

  @override
  State<EditexchangeMB> createState() => _EditexchangeMBState();
}

class DealerField {
  String? selectedDealer;
  TextEditingController priceController;

  DealerField({
    this.selectedDealer,
    String price = '',
  }) : priceController = TextEditingController(text: price);
}

class _EditexchangeMBState extends State<EditexchangeMB> {
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

  Map<String, dynamic> originalEnquiry = {};

  @override
  void initState() {
    super.initState();
    // print('Api Response: ${widget.apiResponse}');
    initControllersFromResponse(widget.apiResponse);
  }

  void initControllersFromResponse(Map<String, dynamic> resp) {
    final enquiry = resp;

    originalEnquiry = Map<String, dynamic>.from(enquiry);

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

  bool isEdited() {
    return
      // vehiclemodal.text != (originalEnquiry['vehicle_model'] ?? '') ||
      vehicleownername.text != (originalEnquiry['vehicle_owner_name'] ?? '') ||
      vehicleowneraddress.text != (originalEnquiry['vehicle_owner_address'] ?? '') ||
      vehicleownerphone.text != (originalEnquiry['vehicle_owner_phone'] ?? '') ||
      presentmodelowned.text != (originalEnquiry['present_model_owned'] ?? '') ||
      noofowners.text != (originalEnquiry['colour'] ?? '') ||
      colour.text != (originalEnquiry['reg_no'] ?? '') ||
      regno.text != (originalEnquiry['km_run'] ?? '') ||
      kmrun.text != (originalEnquiry['year_of_purchase'] ?? '') ||
      yearofpurchase.text != (originalEnquiry['no_of_owners'] ?? '') ||
      // vehicleyear.text != (originalEnquiry['vehicle_year'] ?? '') ||
      expectedprice.text != (originalEnquiry['expected_price'] ?? '') ||

      finalizeddealer != (originalEnquiry['finalized_dealer'] ?? '') ||
      finalizedprice.text != (originalEnquiry['finalized_price'] ?? '');
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
          // "vehicle_model": vehiclemodal.text,
          "vehicle_owner_name": vehicleownername.text,
          "vehicle_owner_address": vehicleowneraddress.text,
          "vehicle_owner_phone": vehicleownerphone.text,
          "present_model_owned": presentmodelowned.text,
          "colour": colour.text,
          "reg_no": regno.text,
          "km_run": kmrun.text,
          "year_of_purchase": yearofpurchase.text,
          "no_of_owners": noofowners.text,
          // "vehicle_year": vehicleyear.text,
          "expected_price": expectedprice.text,

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
          // vehiclemodale = errors['vehicle_model']?.toString() ?? '';
          vehicleownernamee = errors['vehicle_owner_name']?.toString() ?? '';
          vehicleowneraddresse = errors['vehicle_owner_address']?.toString() ?? '';
          vehicleownerphonee = errors['vehicle_owner_phone']?.toString() ?? '';
          presentmodelownede = errors['present_model_owned']?.toString() ?? '';
          noofownerse = errors['colour']?.toString() ?? '';
          coloure = errors['reg_no']?.toString() ?? '';
          regnoe = errors['km_run']?.toString() ?? '';
          kmrune = errors['year_of_purchase']?.toString() ?? '';
          yearofpurchasee = errors['no_of_owners']?.toString() ?? '';
          // vehicleyeare = errors['vehicle_year']?.toString() ?? '';
          expectedpricee = errors['expected_price']?.toString() ?? '';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
      child: Column(
        children: [
          // textfieldy(
          //   'Vehicle Modal',
          //   vehiclemodal,
          //   readonly: widget.edit
          // ),
          // if(vehiclemodale.isNotEmpty)
          // errormessage(vehiclemodale),
          textfieldy(
            'Vehicle Owner Name',
            vehicleownername,
            readonly: widget.edit
          ),
          if(vehicleownernamee.isNotEmpty)
          errormessage(vehicleownernamee),
          textfieldy(
            'Vehicle Owner Address',
            vehicleowneraddress,
            readonly: widget.edit
          ),
          if(vehicleowneraddresse.isNotEmpty)
          errormessage(vehicleowneraddresse),
          textfieldy(
            'Vehicle Owner Phone',
            vehicleownerphone,
            numpad: true,
            readonly: widget.edit
          ),
          if(vehicleownerphonee.isNotEmpty)
          errormessage(vehicleownerphonee),
          textfieldy(
            'Present Model Owned',
            presentmodelowned,
            readonly: widget.edit
          ),
          if(presentmodelownede.isNotEmpty)
          errormessage(presentmodelownede),
          textfieldy(
            'Colour',
            colour,
            readonly: widget.edit
          ),
          if(coloure.isNotEmpty)
          errormessage(coloure),
          textfieldy(
            'Reg No',
            regno,
            readonly: widget.edit
          ),
          if(regnoe.isNotEmpty)
          errormessage(regnoe),
          textfieldy(
            'KM Run',
            kmrun,
            readonly: widget.edit,
            numpad: true,
          ),
          if(kmrune.isNotEmpty)
          errormessage(kmrune),
          textfieldy(
            'Year Of Purchase',
            yearofpurchase,
            readonly: widget.edit,
            numpad: true,
          ),
          if(yearofpurchasee.isNotEmpty)
          errormessage(yearofpurchasee),
          textfieldy(
            'No of Owners',
            noofowners,
            readonly: widget.edit,
            numpad: true,
          ),
          if(noofownerse.isNotEmpty)
          errormessage(noofownerse),
          // textfieldy(
          //   'Vehicle Year',
          //   vehicleyear,
          //   readonly: widget.edit
          // ),
          // if(vehicleyeare.isNotEmpty)
          // errormessage(vehicleyeare),
          textfieldy(
            'Expected Price',
            expectedprice,
            readonly: widget.edit,
            numpad: true,
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
          if(isEdited() == true)
          SizedBox(height: SizeConfig.h(25)),
          if(isEdited() == true)
          button(
            'Update Quotation',
            () {
              exchangeform();
            }
          ),
          SizedBox(height: SizeConfig.h(30)),
        ],
      ),
    );
  }
}