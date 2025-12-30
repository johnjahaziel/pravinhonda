import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pravinhonda/salesexecutive/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/salesexecutive/bloc/auth_cubit.dart';
import 'package:pravinhonda/salesexecutive/bloc/enquiry_id_cubit.dart';
import 'package:pravinhonda/salesexecutive/bloc/number_cubit.dart';
import 'package:pravinhonda/salesexecutive/bloc/username_cubit.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/login.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  
  final storedToken = prefs.getString('token');
  final storedUsername = prefs.getString('username');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AuthCubit()..setToken(storedToken)),
        BlocProvider(create: (_) => EnquiryCubit()),
        BlocProvider(create: (_) => ApiresponseCubit()),
        BlocProvider(create: (_) => UsernameCubit()..setusername(storedUsername ?? '')),
        BlocProvider(create: (_) => NumberCubit()),
      ],
      child: MyApp(
        hasToken: storedToken != null && storedToken.isNotEmpty
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  final bool hasToken;

  const MyApp({
    super.key,
    required this.hasToken,
  });

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
          appBarTheme: AppBarTheme(
            backgroundColor: kwhite,
          ),
          primaryColor: kwhite,
          fontFamily: 'Poppins',
        ),
        home: hasToken ? Navigation() : Login(),
      ),
    );
  }
}