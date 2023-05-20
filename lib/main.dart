import 'package:flutter/material.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/provider/employee_provider.dart';
import 'package:flutter_parse/screens/splashscreen.dart';
import 'package:flutter_parse/services/service_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(
      ServiceHelper.keyApplicationId, ServiceHelper.keyParseServerUrl,
      clientKey: ServiceHelper.keyClientKey, debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<EmployeeProvider>(
          create: (context) => EmployeeProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Parse mt',
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xff9170e2),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }

  
}
