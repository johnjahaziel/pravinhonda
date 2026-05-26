import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/role_cubit.dart';
import 'package:pravinhonda/bloc/username_cubit.dart';
import 'package:pravinhonda/pdimanager/NavigationPdi.dart';
import 'package:pravinhonda/rtomanager/NavigationRTo.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
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
  final TextEditingController pincontroller = TextEditingController();
  // final TextEditingController lattitudecontroller = TextEditingController();
  // final TextEditingController longitudecontroller = TextEditingController();

  Future<void> login() async {
    final hour = DateTime.now().hour;
    if (hour < 8 || hour >= 20) {
      Fluttertoast.showToast(
        msg: 'Login allowed only between 8 AM and 8 PM',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    final url = Uri.parse('https://app.pravinhonda.com/api/login');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'username': useridcontroller.text,
          'password': passwordcontroller.text,
          'pin': pincontroller.text,
          // 'latitude': lattitudecontroller.text,
          // 'longitude': longitudecontroller.text,
          // 'username': 'rto1@pravinhonda.com',
          // 'password': "12345678",
          // 'latitude': '9.1737612',
          // 'longitude': '77.8626703',
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      );

      final responseData = json.decode(response.body);

      print('Full response: $responseData');

      if (response.statusCode == 200 && responseData['status'] == true) {

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

        String username = responseData['user']['name'];

        final usernamestore = await SharedPreferences.getInstance();
        await usernamestore.setString('username', username);

        String? storedUsername = usernamestore.getString('username');

        BlocProvider.of<UsernameCubit>(context).setusername(storedUsername ?? 'User');

        String role = responseData['user']['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', role);

        final access = responseData['user']['access'];
        String? accessKey;
        if (role == 'Sales Representative') {
          accessKey = 'sales';
        } else if (role == 'PDI Incharge') {
          accessKey = 'pdi';
        } else if (role == 'RTO') {
          accessKey = 'rto';
        }
        if (access is Map && accessKey != null && access[accessKey] is List) {
          final roleAccess = (access[accessKey] as List).map((e) => e.toString()).toList();
          await prefs.setStringList('access_list', roleAccess);
        } else {
          await prefs.remove('access_list');
        }

        BlocProvider.of<RoleCubit>(context).setrole(role);

        if (role == 'Sales Representative') {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigation(),       //Navigation
            ),
            ((route) => false)
          );

          Fluttertoast.showToast(msg: responseData['message']);

        } else if (role == 'PDI Incharge') {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationPdi(),
            ),
            ((route) => false)
          );

          Fluttertoast.showToast(msg: responseData['message']);

        } else if (role == 'RTO') {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationRTO(),
            ),
            ((route) => false)
          );

          Fluttertoast.showToast(msg: responseData['message']);

        } else {
          Fluttertoast.showToast(msg: "Access denied");
        }

      } else {
        print('Server error: ${response.statusCode}');
        print(responseData);
        Fluttertoast.showToast(msg: responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     getLocation();
  //   });
  // }

  // Future<void> getLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // 🔹 Check if location service is ON
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Fluttertoast.showToast(msg: "Please turn on location services");
  //     await Geolocator.openLocationSettings();
  //     return;
  //   }

  //   // 🔹 Check permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Fluttertoast.showToast(msg: "Location permission denied");
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     Fluttertoast.showToast(msg: "Permission permanently denied");
  //     await Geolocator.openAppSettings();
  //     return;
  //   }

  //   // 🔹 Get location
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   setState(() {
  //     lattitudecontroller.text = position.latitude.toString();
  //     longitudecontroller.text = position.longitude.toString();
  //   });
  // }

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
              SizedBox(height: SizeConfig.h(15)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: textfieldy(
                  'Pin',
                  pincontroller,
                  numpad: true,
                ),
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 25),
              //       child: Column(
              //         children: [
              //           SizedBox(height: SizeConfig.h(5)),
              //           textfieldy(
              //             'Lattitude',
              //             lattitudecontroller,
              //             readonly: true
              //           ),
              //           SizedBox(height: SizeConfig.h(5)),
              //           textfieldy(
              //             'Longitude',
              //             longitudecontroller,
              //             readonly: true
              //           ),
              //           SizedBox(height: SizeConfig.h(5)),
              //         ],
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 15),
              //       child: TextButton(
              //         onPressed: () {
              //           getLocation();
              //         },
              //         child: Text(
              //           "Get Location",
              //           style: TextStyle(
              //             color: Colors.black
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(height: SizeConfig.h(40)),
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
