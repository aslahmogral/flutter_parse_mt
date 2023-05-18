import 'package:flutter/material.dart';
import 'package:flutter_parse/components/animation_container.dart';
import 'package:flutter_parse/components/button.dart';
import 'package:flutter_parse/components/custom_theme.dart';
import 'package:flutter_parse/components/loader.dart';
import 'package:flutter_parse/components/textformfield.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/screens/employee_screen.dart';
import 'package:flutter_parse/utils/apptheme.dart';
import 'package:flutter_parse/utils/constants.dart';
import 'package:flutter_parse/utils/dimens.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(gradient: FTheme.primaryGradient),
      child: ValueListenableBuilder(
          valueListenable: isLoadingNotifier,
          builder: (context, bool isLoading, child) {
            return isLoading
                ? LoaderBird(
                    message1: 'plzzz wait.....',
                    message2: 'Logging.... in....',
                  )
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      // title: Text('login'),
                    ),
                    body: GestureDetector(
                        onTap: () =>
                            FocusManager.instance.primaryFocus!.unfocus(),
                        child: CustomTheme(
                          child1: AnimationContainer(
                              lottie: 'animation/mobilenumber.json'),
                          child2: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Constants.enter_username_and_password,
                                    style: FTheme.primaryHeaderStyle,
                                  ),
                                  SizedBox(
                                    height: Dimens.padding_xxl,
                                  ),
                                  WTextFormField(
                                    textEditingController: _userNameController,
                                    label: Constants.enter_username,
                                  ),
                                  SizedBox(
                                    height: Dimens.padding_xxl,
                                  ),
                                  WTextFormField(
                                    textEditingController: _passwordController,
                                    obscureText: true,
                                    label: Constants.enter_password,
                                  ),
                                  SizedBox(
                                    height: Dimens.padding_xxl,
                                  ),
                                  FButton(
                                    label: Constants.login,
                                    gradient: true,
                                    onPressed: () =>
                                        loginMethod(authProvider, context),
                                  ),
                                  SizedBox(
                                    height: Dimens.padding,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
          }),
    );
  }

  Future<void> loginMethod(
      AuthProvider authProvider, BuildContext context) async {
    isLoadingNotifier.value = true;

    await authProvider.userLogin(
        adminName: _userNameController.text.trim(),
        adminPassword: _passwordController.text.trim());
    bool? isloggedIn = await authProvider.isLoggedIn;
    if (isloggedIn!) {
      print('/////////////////////employeescreen');
      isLoadingNotifier.value = false;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EmployeeScreen()),
          (route) => false);
    }
  }
}
