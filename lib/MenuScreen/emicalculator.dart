import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
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

  bool _isLoading = false;
  Map<String, dynamic>? _emiResult;
  String? _errorMessage;

  final String _baseUrl = 'https://app.pravinhonda.com';
  String get _emiUrl => '$_baseUrl/api/emi/calculate';

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
      final parsedInterest = double.tryParse(interestrate.text);
      if (parsedInterest != null && parsedInterest >= 4 && parsedInterest <= 20) {
        interestValue = parsedInterest;
      }

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

  Future<void> _calculateEmi() async {
    final loanAmountText = loanamount.text.trim();
    final interestText = interestrate.text.trim();
    final monthsText = loanterm.text.trim();

    if (loanAmountText.isEmpty || interestText.isEmpty || monthsText.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields to calculate EMI';
        _emiResult = null;
      });
      return;
    }

    final double? loanAmountValue = double.tryParse(loanAmountText);
    final double? rateValue = double.tryParse(interestText);
    final int? monthsValue = int.tryParse(monthsText);

    if (loanAmountValue == null || rateValue == null || monthsValue == null) {
      setState(() {
        _errorMessage = 'Please enter valid numeric values';
        _emiResult = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = BlocProvider.of<AuthCubit>(context).state.token;

    try {
      final response = await http.post(
        Uri.parse(_emiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "loan_amount": loanAmountValue,
          "rate": rateValue,
          "months": monthsValue,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        if (resBody['status'] == true && resBody['data'] != null) {
          setState(() {
            _emiResult = resBody['data'] as Map<String, dynamic>;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _emiResult = null;
            _errorMessage = resBody['message']?.toString() ?? 'Failed to calculate EMI';
          });
        }
      } else {
        setState(() {
          _emiResult = null;
          _errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _emiResult = null;
        _errorMessage = 'Error calculating EMI: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildResultSection(),
                ),

                const SizedBox(height: 15),
                const Divider(),
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

                const SizedBox(height: 10),

                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _calculateEmi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kred,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2,color: kred,),
                          )
                        : const Text(
                            'Calculate EMI',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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

  /// Builds the top EMI result section based on API response / errors / empty state
  Widget _buildResultSection() {
    if (_isLoading && _emiResult == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: kred,
          ),
        ),
      );
    }

    if (_errorMessage != null && _errorMessage!.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    if (_emiResult == null) {
      return const Center(
        child: Text(
          "Enter details and tap 'Calculate EMI'",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      );
    }

    // Safe extraction from API data
    final String loanAmount = _emiResult?['loan_amount']?.toString() ?? '0.00';
    final String totalInterest = _emiResult?['total_interest_amount']?.toString() ?? '0.00';
    final String totalPayable = _emiResult?['total_payable_amount']?.toString() ?? '0.00';
    final String emi = _emiResult?['calculated_emi']?.toString() ?? '0.00';
    final String interestPercentage = _emiResult?['rate_of_interest']?.toString() ?? '0.00';
    final int months = _emiResult?['loan_period_months'] ?? 0;

    return Column(
      children: [
        Row(
          children: [
            _buildBox("Monthly EMI", "₹$emi", Colors.green),
            _buildBox("Total Interest", "₹$totalInterest", Colors.orange),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildBox("Payable Amount", "₹$totalPayable", Colors.lightBlue),
            _buildBox("Interest Rate", "$interestPercentage %", Colors.cyan),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Loan Amount: ₹$loanAmount   |   Tenure: $months months",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
