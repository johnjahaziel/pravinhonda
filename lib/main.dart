import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/enquiry_id_cubit.dart';
import 'package:pravinhonda/loginscreens/Navigation.dart';
import 'package:pravinhonda/loginscreens/login.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('token');

  final authCubit = AuthCubit();

  if (storedToken != null && storedToken.isNotEmpty) {
    authCubit.setToken(storedToken);
  }

  runApp(
    MyApp(
      authCubit: authCubit,
      hasToken: storedToken != null
    )
  );
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final bool hasToken;

  const MyApp({
    super.key,
    required this.authCubit,
    required this.hasToken,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => EnquiryCubit()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
      ),
    );
  }
}