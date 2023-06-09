import 'package:flutter/material.dart';
import 'package:flutter_parse/components/animation_container.dart';
import 'package:flutter_parse/components/button.dart';
import 'package:flutter_parse/components/custom_theme.dart';
import 'package:flutter_parse/components/textformfield.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/screens/employee_screen.dart';
import 'package:flutter_parse/utils/apptheme.dart';
import 'package:flutter_parse/utils/constants.dart';
import 'package:flutter_parse/utils/dimens.dart';
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
            return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                // title: Text('login'),
              ),
              body: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: CustomTheme(
                    child1: const AnimationContainer(
                        lottie: 'animation/mobilenumber.json'),
                    child2: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Constants.enterUserNameAndPassword,
                              style: FTheme.primaryHeaderStyle,
                            ),
                            const SizedBox(
                              height: Dimens.padding_3xl,
                            ),
                            WTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Constants.emptyUserName;
                                }
                                return null;
                              },
                              textEditingController: _userNameController,
                              label: Constants.enterUserName,
                            ),
                            const SizedBox(
                              height: Dimens.padding_3xl,
                            ),
                            WTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Constants.emptyPassword;
                                }
                                return null;
                              },
                              textEditingController: _passwordController,
                              obscureText: true,
                              label: Constants.enterPassword,
                            ),
                            const SizedBox(
                              height: Dimens.padding_3xl,
                            ),
                            isLoading
                                ? const CircularProgressIndicator()
                                : FButton(
                                    label: Constants.login,
                                    gradient: true,
                                    onPressed: () =>
                                        loginMethod(authProvider, context),
                                  ),
                            const SizedBox(
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

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loginMethod(
      AuthProvider authProvider, BuildContext context) async {
    bool isValidated = _formKey.currentState!.validate();
    if (isValidated) {
      isLoadingNotifier.value = true;

      final response = await authProvider.userLogin(
          adminName: _userNameController.text.trim(),
          adminPassword: _passwordController.text.trim());

      bool? isloggedIn = authProvider.isLoggedIn;
      if (isloggedIn!) {
        isLoadingNotifier.value = false;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeScreen()),
            (route) => false);
      } else {
        showError(response.error.toString());
        isLoadingNotifier.value = false;
      }
    }
  }
}
