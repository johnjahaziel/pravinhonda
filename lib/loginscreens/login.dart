import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/customs/form-utility.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/versiontext.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPassword = false;
  final TextEditingController useridcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Navigation(),
                    ),
                  );
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
