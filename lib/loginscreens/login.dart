import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pravinhonda/utility/custom.dart';
import 'package:pravinhonda/utility/versiontext.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPassword = false;
  TextEditingController useridcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ allows scroll when keyboard pops
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // ✅ makes it fill screen
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // ✅ center
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('images/pravin_honda_logo.png'),
                        height: 150,
                        width: 200,
                      ),
                      const SizedBox(height: 40),
                      textfield(
                        'User ID',
                        useridcontroller
                      ),
                      const SizedBox(height: 20),
                      password(
                        'Password',
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                            icon: isPassword
                                ? const Icon(FontAwesomeIcons.solidEyeSlash,
                                    color: Colors.black, size: 20)
                                : const Icon(FontAwesomeIcons.solidEye,
                                    color: Colors.black, size: 20),
                          ),
                        ),
                        isPassword,
                        passwordcontroller,
                      ),
                      const SizedBox(height: 40),
                      button("Login", () {}),
                      const Spacer(),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                        indent: 25,
                        endIndent: 25,
                      ),
                      const SizedBox(height: 20),
                      const Versiontext(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
