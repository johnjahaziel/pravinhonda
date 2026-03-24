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

class Addexchange extends StatefulWidget {
  final String enquiryid;
  const Addexchange({
    super.key,
    required this.enquiryid,
  });

  @override
  State<Addexchange> createState() => _AddexchangeState();
}

class DealerField {
  String? selectedDealer;
  TextEditingController priceController = TextEditingController();
}

class _AddexchangeState extends State<Addexchange> {

  // TextEditingController vehiclemodal = TextEditingController(); 
  TextEditingController vehicleownername = TextEditingController();
  TextEditingController vehicleowneraddress = TextEditingController();
  TextEditingController vehicleownerphone = TextEditingController();
  TextEditingController presentmodelowned = TextEditingController();
  TextEditingController noofowners = TextEditingController();
  TextEditingController colour = TextEditingController();
  TextEditingController regno = TextEditingController();
  TextEditingController kmrun = TextEditingController();
  TextEditingController yearofpurchase = TextEditingController();
  // TextEditingController vehicleyear = TextEditingController();
  TextEditingController expectedprice = TextEditingController();

  TextEditingController price1 = TextEditingController();

  String? finalizeddealer;
  TextEditingController finalizedprice = TextEditingController();

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
      data['dealer_name${i + 1}'] =
          dealers[i].selectedDealer;
      data['price${i + 1}'] =
          dealers[i].priceController.text.trim();
    }

    return data;
  }

  Future<void> exchangeform() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/exchange/${widget.enquiryid}');

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

          // 'vehicle_model': 'asda',
          // 'vehicle_year': '2018',
          // 'no_of_owners' : '1',
          // 'expected_price': '50000',

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Createquotation(
                  enquiryid: responseData['data']['enquiry_id'],
                  apiResponse: responseData,
                )
              )
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
    SizeConfig.init(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // textfieldy(
              //   'Vehicle Modal',
              //   vehiclemodal
              // ),
              // if(vehiclemodale.isNotEmpty)
              // errormessage(vehiclemodale),
              textfieldy(
                'Vehicle Owner Name',
                vehicleownername
              ),
              if(vehicleownernamee.isNotEmpty)
              errormessage(vehicleownernamee),
              textfieldy(
                'Vehicle Owner Address',
                vehicleowneraddress
              ),
              if(vehicleowneraddresse.isNotEmpty)
              errormessage(vehicleowneraddresse),
              textfieldy(
                'Vehicle Owner Phone',
                vehicleownerphone,
                numpad: true
              ),
              if(vehicleownerphonee.isNotEmpty)
              errormessage(vehicleownerphonee),
              textfieldy(
                'Present Model Owned',
                presentmodelowned
              ),
              if(presentmodelownede.isNotEmpty)
              errormessage(presentmodelownede),
              textfieldy(
                'Colour',
                colour
              ),
              if(coloure.isNotEmpty)
              errormessage(coloure),
              textfieldy(
                'Reg No',
                regno
              ),
              if(regnoe.isNotEmpty)
              errormessage(regnoe),
              textfieldy(
                'KM Run',
                kmrun
              ),
              if(kmrune.isNotEmpty)
              errormessage(kmrune),
              textfieldy(
                'Year Of Purchase',
                yearofpurchase
              ),
              if(yearofpurchasee.isNotEmpty)
              errormessage(yearofpurchasee),
              textfieldy(
                'No of Owners',
                noofowners
              ),
              if(noofownerse.isNotEmpty)
              errormessage(noofownerse),
              // textfieldy(
              //   'Vehicle Year',
              //   vehicleyear
              // ),
              // if(vehicleyeare.isNotEmpty)
              // errormessage(vehicleyeare),
              textfieldy(
                'Expected Price',
                expectedprice
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
                                ),
                                textfieldy(
                                  'Price ${index + 1}',
                                  dealers[index].priceController,
                                  numpad: true,
                                  star: false
                                ),
                              ],
                            ),

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
              ),
              if(finalizeddealere.isNotEmpty)
              errormessage(finalizeddealere),
              textfieldy(
                'Finalised Price',
                finalizedprice,
                star: false
              ),
              if(finalizedpricee.isNotEmpty)
              errormessage(finalizedpricee),
              SizedBox(height: SizeConfig.h(10)),
              button(
                'Submit',
                () async {
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