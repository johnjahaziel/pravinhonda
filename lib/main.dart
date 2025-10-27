import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pravinhonda/loginscreens/login.dart';
import 'package:pravinhonda/utility/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: const TextScaler.linear(0.9),
            ),
            child: child!,
          );
        },
        theme: ThemeData(
          scaffoldBackgroundColor: kwhite,
          primaryColor: kwhite,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',
        routes: {
          '/' : (context) => Login(),
        },
      ),
    );
  }
}