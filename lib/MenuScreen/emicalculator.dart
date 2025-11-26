import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pravinhonda/utility/customs/customappBar.dart';
import 'package:pravinhonda/utility/customs/customdrawer.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Emicalculator extends StatefulWidget {
  const Emicalculator({super.key});

  @override
  State<Emicalculator> createState() => _EmicalculatorState();
}

class _EmicalculatorState extends State<Emicalculator> {
  final TextEditingController loanamount = TextEditingController();
  final TextEditingController interestrate = TextEditingController();
  final TextEditingController loanterm = TextEditingController();

  double interestValue = 4.0;
  int loanTermValue = 1;

  @override
  void initState() {
    super.initState();
    interestrate.text = interestValue.toStringAsFixed(1);
    loanterm.text = loanTermValue.toString();

    loanamount.addListener(_updateState);
    interestrate.addListener(_updateState);
    loanterm.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      // Parse and update interestValue
      final parsedInterest = double.tryParse(interestrate.text);
      if (parsedInterest != null && parsedInterest >= 4 && parsedInterest <= 20) {
        interestValue = parsedInterest;
      }

      // Parse and update loanTermValue
      final parsedLoanTerm = int.tryParse(loanterm.text);
      if (parsedLoanTerm != null && parsedLoanTerm >= 1 && parsedLoanTerm <= 1000) {
        loanTermValue = parsedLoanTerm;
      }
    });
  }

  @override
  void dispose() {
    loanamount.removeListener(_updateState);
    interestrate.removeListener(_updateState);
    loanterm.removeListener(_updateState);

    loanamount.dispose();
    interestrate.dispose();
    loanterm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Customdrawer(),
        drawerEnableOpenDragGesture: false,
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // EMI Results Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: () {
                      double principal = double.tryParse(loanamount.text) ?? 0;
                      double annualRate = double.tryParse(interestrate.text) ?? 0;
                      int term = int.tryParse(loanterm.text) ?? 0;
            
                      if (principal == 0 || annualRate == 0 || term == 0) {
                        return [
                          Center(
                            child: Text("Enter Amount to calculate EMI",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black
                              )
                            ),
                          ),
                        ];
                      }
            
                      double monthlyRate = annualRate / 12 / 100;
                      double emi = (principal * monthlyRate * pow(1 + monthlyRate, term)) /
                          (pow(1 + monthlyRate, term) - 1);
            
                      double totalPayment = emi * term;
                      double totalInterest = totalPayment - principal;
                      double interestPercentage = (totalInterest / principal) * 100;
            
                      return [
                        Row(
                          children: [
                            _buildBox("Monthly EMI", "₹${emi.toStringAsFixed(2)}", Colors.green),
                            _buildBox("Total Interest", "₹${totalInterest.toStringAsFixed(2)}", Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildBox("Payable Amount", "₹${totalPayment.toStringAsFixed(2)}", Colors.lightBlue),
                            _buildBox("Interest Percentage", "${interestPercentage.toStringAsFixed(2)} %", Colors.cyan),
                          ],
                        ),
                      ];
                    }(),
                  ),
                ),
            
                const SizedBox(height: 15),
                Divider(),
                const SizedBox(height: 20),
            
                Center(
                  child: Text(
                    'EMI Calculator',
                    style: customtext(fs18, kred, FontWeight.bold),
                  ),
                ),
            
                // Loan Amount
                textfieldy('Loan Amount', loanamount, numpad: true),
            
                // Interest Rate
                textfieldy('Interest Rate (%)', interestrate, numpad: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Slider(
                    min: 4,
                    max: 20,
                    activeColor: kred,
                    divisions: 160,
                    value: interestValue,
                    label: '${interestValue.toStringAsFixed(1)}%',
                    onChanged: (value) {
                      setState(() {
                        interestValue = value;
                        interestrate.text = value.toStringAsFixed(1);
                      });
                    },
                  ),
                ),
            
                // Loan Term
                textfieldy('Loan Term (in months)', loanterm, numpad: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Slider(
                    min: 1,
                    max: 1000,
                    divisions: 999,
                    activeColor: kred,
                    value: loanTermValue.toDouble(),
                    label: '$loanTermValue months',
                    onChanged: (value) {
                      setState(() {
                        loanTermValue = value.round();
                        loanterm.text = loanTermValue.toString();
                      });
                    },
                  ),
                ),
            
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 248, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
