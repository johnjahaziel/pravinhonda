import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pravinhonda/bloc/apirespnse_cubit.dart';
import 'package:pravinhonda/bloc/auth_cubit.dart';
import 'package:pravinhonda/bloc/enquiry_id_cubit.dart';
import 'package:pravinhonda/bloc/number_cubit.dart';
import 'package:pravinhonda/bloc/role_cubit.dart';
import 'package:pravinhonda/bloc/username_cubit.dart';
import 'package:pravinhonda/login.dart';
import 'package:pravinhonda/pdimanager/NavigationPdi.dart';
import 'package:pravinhonda/rtomanager/NavigationRTo.dart';
import 'package:pravinhonda/salesexecutive/loginscreens/Navigation.dart';
import 'package:pravinhonda/utility/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isWithinLoginHours() {
  final h = DateTime.now().hour;
  return h >= 8 && h < 20;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  if (!_isWithinLoginHours()) {
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('username');
  }

  final storedToken = prefs.getString('token');
  final storedUsername = prefs.getString('username');
  final storedRole = prefs.getString('role');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AuthCubit()..setToken(storedToken)),
        BlocProvider(create: (_) => EnquiryCubit()),
        BlocProvider(create: (_) => ApiresponseCubit()),
        BlocProvider(create: (_) => UsernameCubit()..setusername(storedUsername ?? '')),
        BlocProvider(create: (_) => NumberCubit()),
        BlocProvider(create: (_) => RoleCubit()..setrole(storedRole ?? '')),
      ],
      child: MyApp(
        hasToken: storedToken != null && storedToken.isNotEmpty,
        role: storedRole,
      ),
    )
  );
}

class MyApp extends StatefulWidget {
  final bool hasToken;
  final String? role;

  const MyApp({
    super.key,
    required this.hasToken,
    required this.role,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  Timer? _hoursTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _hoursTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _enforceLoginWindow();
    });
  }

  @override
  void dispose() {
    _hoursTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enforceLoginWindow();
    }
  }

  Future<void> _enforceLoginWindow() async {
    if (_isWithinLoginHours()) return;

    final navState = _navKey.currentState;
    if (navState == null) return;
    final ctx = navState.context;

    final auth = BlocProvider.of<AuthCubit>(ctx);
    final token = auth.state.token;
    if (token == null || token.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('username');
    auth.cleartoken();

    Fluttertoast.showToast(
      msg: 'Logged out: outside 8 AM – 8 PM window',
      toastLength: Toast.LENGTH_LONG,
    );

    navState.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Login()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget startPage;

    if (!widget.hasToken) {
      startPage = Login();
    } else if (widget.role == 'PDI Incharge') {
      startPage = NavigationPdi();
    } else if (widget.role == 'Sales Representative') {
      startPage = Navigation();
    } else if (widget.role == 'RTO') {
      startPage = NavigationRTO();
    } else {
      startPage = Login();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        navigatorKey: _navKey,
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
        home: startPage,
      ),
    );
  }
}