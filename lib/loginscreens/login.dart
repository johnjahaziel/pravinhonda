import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/versiontext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPassword = false;
  final TextEditingController useridcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('https://app.pravinhonda.com/api/login');

    try {
      final response = await http.post(
        url,
        body: {
          'username': useridcontroller.text,
          'password': passwordcontroller.text,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {

        print('Token: ${responseData['token']}');

        final token = responseData['token'];

        final prefstoken = await SharedPreferences.getInstance();
        await prefstoken.setString('token', token);

        String? storedToken = prefstoken.getString('token');

        if (storedToken != null) {

          final authCubit = BlocProvider.of<AuthCubit>(context);
          authCubit.setToken(storedToken);

        } else {
          Fluttertoast.showToast(
            msg: "Failed to read token",
            toastLength: Toast.LENGTH_LONG
          );
        }
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation(),
          ),
          ((route) => false)
        );

        Fluttertoast.showToast(msg: responseData['message']);

      } else {
        print('Server error: ${response.statusCode}');
        Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.h(80)),
              Image(
                image: AssetImage('images/pravin_honda_logo.png'),
                height: SizeConfig.h(150),
                width: SizeConfig.w(200),
              ),
              SizedBox(height: SizeConfig.h(40)),
              textfield(
                'User ID',
                useridcontroller
              ),
              SizedBox(height: SizeConfig.h(20)),
              password(
                'Password',
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: isPassword
                        ? Icon(FontAwesomeIcons.solidEyeSlash,
                            color: Colors.black, size: 20)
                        : Icon(FontAwesomeIcons.solidEye,
                            color: Colors.black, size: 20),
                  ),
                ),
                isPassword,
                passwordcontroller,
              ),
              SizedBox(height: SizeConfig.h(60)),
              button(
                "Login",
                () {
                  login();
                },
                padding: true
              ),
              SizedBox(height: SizeConfig.h(100)),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                indent: 25,
                endIndent: 25,
              ),
              SizedBox(height: SizeConfig.h(30)),
              Versiontext(),
              SizedBox(height: SizeConfig.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}
