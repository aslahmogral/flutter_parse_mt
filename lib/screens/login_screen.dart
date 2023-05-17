import 'package:flutter/material.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/screens/employee_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userNameController,
          ),
          TextField(
            controller: _passwordController,
          ),
          ElevatedButton(
              onPressed: ()  {
                 loginMethod(authProvider, context);
              },
              child: Text('login')),
          ElevatedButton(
              onPressed: () {
                print('login button : ${authProvider.isLoggedIn}');
              },
              child: Text('data'))
        ],
      )),
    );
  }

  Future<void> loginMethod(AuthProvider authProvider, BuildContext context) async {
    await authProvider.userLogin(
        adminName: _userNameController.text.trim(),
        adminPassword: _passwordController.text.trim());
    bool? isloggedIn = await authProvider.isLoggedIn;
    if (isloggedIn!) {
      print('/////////////////////employeescreen');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeScreen(),
          ));
    }
  }
}
