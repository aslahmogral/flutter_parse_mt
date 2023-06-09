import 'package:flutter/material.dart';
import 'package:flutter_parse/components/button.dart';
import 'package:flutter_parse/components/loader.dart';
import 'package:flutter_parse/components/textformfield.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/provider/employee_provider.dart';
import 'package:flutter_parse/screens/login_screen.dart';
import 'package:flutter_parse/utils/apptheme.dart';
import 'package:flutter_parse/utils/colors.dart';
import 'package:flutter_parse/utils/constants.dart';
import 'package:flutter_parse/utils/dimens.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _nameController = TextEditingController();
  final ageController = TextEditingController();
  final ratingController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> isSignOutLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> isEmployeeSaveNotifier = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  Future<List<EmployeeModel>> employeeListMethod() async {
    List<EmployeeModel> employeeList = [];

    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    await employeeProvider.getEmployee();
    employeeList = employeeProvider.employeeList;
    return employeeList;
  }

  Future<dynamic> addEmployeeDialog(BuildContext context,
      EmployeeProvider employeeProvider, void Function()? onPressed) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: FTheme.dialogDecoration,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.padding_3xl),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(Constants.enterEmployeeDetails,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: Dimens.padding_3xl,
                  ),
                  WTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Constants.emptyEmployee;
                      }
                      return null;
                    },
                    label: Constants.enterEmployeeName,
                    textEditingController: _nameController,
                  ),
                  const SizedBox(
                    height: Dimens.padding,
                  ),
                  WTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Constants.enterEmployeeName;
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                    label: Constants.enterEmployeeAge,
                    textEditingController: ageController,
                  ),
                  const SizedBox(
                    height: Dimens.padding,
                  ),
                  WTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Constants.enterRating;
                      } else if (int.parse(value) > 100) {
                        return Constants.ratingWarning;
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                    label: Constants.enterRating,
                    textEditingController: ratingController,
                  ),
                  const SizedBox(
                    height: Dimens.padding,
                  ),
                  ValueListenableBuilder(
                      valueListenable: isEmployeeSaveNotifier,
                      builder: (context, isEmployeeSaved, child) {
                        return isEmployeeSaved
                            ? const CircularProgressIndicator()
                            : FButton(
                                onPressed: onPressed,
                                label: Constants.addEmployee,
                                gradient: true,
                              );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveEmployeeMethod(EmployeeProvider employeeProvider,
      BuildContext context, bool isValidated) async {
    if (isValidated) {
      isEmployeeSaveNotifier.value = true;
      await employeeProvider.saveEmployee(
          name: _nameController.text,
          age: ageController.text,
          rating: ratingController.text);
      _nameController.clear();
      ageController.clear();
      ratingController.clear();
      isEmployeeSaveNotifier.value = false;
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  FutureBuilder<List<EmployeeModel>> employeeListView(
      EmployeeProvider employeeProvider) {
    return FutureBuilder<List<EmployeeModel>>(
      future: employeeListMethod(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: LoaderBird(
                message1: Constants.loadingData,
              ),
            );

          default:
            if (snapshot.hasError) {
              return const Center(
                child: Text("error..."),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("error..."),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final employee = employeeProvider.employeeList[index];
                  final employeeName = employee.name;
                  final employeeRating = employee.rating;
                  final employeeId = employee.objectId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.padding,
                        vertical: Dimens.padding_2xs),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.borderRadiusSmall)),
                      elevation: 6,
                      margin: const EdgeInsets.all(Dimens.paddingXs),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: CircularPercentIndicator(
                              percent: employeeRating! / 100,
                              radius: 28,
                              progressColor: progressColor(employeeRating),
                              center: Text(
                                '$employeeRating%',
                                style: const TextStyle(
                                    fontSize: Dimens.paddingSmall),
                              ),
                            ),
                            title: Text(employeeName!),
                            // subtitle: Text(employeeRating.toString()),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    employeeProvider.deleteEmployee(
                                        id: employeeId.toString());
                                  });
                                  // print(employeeId);
                                },
                                icon: const Icon(Icons.delete))),
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  Color progressColor(value) {
    if (value >= 75) {
      return Colors.green;
    } else if (value >= 35 && value < 75) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String getStringFirstLetter(String input) {
    if (input.isEmpty) {
      return '';
    } else {
      return input.substring(0, 1);
    }
  }

  Future<void> logoutMethod(
      AuthProvider authProvider, BuildContext context) async {
    isSignOutLoadingNotifier.value = true;

    await authProvider.userLogout();
    if (authProvider.isLoggedIn == false) {
      isSignOutLoadingNotifier.value = false;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      isSignOutLoadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);

    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(gradient: FTheme.primaryGradient),
        child: ValueListenableBuilder(
            valueListenable: isLoadingNotifier,
            builder: (context, isLoading, child) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  title: const Text(Constants.employees),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: ValueListenableBuilder(
                                  valueListenable: isSignOutLoadingNotifier,
                                  builder: (context, isSignout, child) {
                                    return Consumer<AuthProvider>(builder:
                                        (context, authProvider, child) {
                                      return Container(
                                        decoration: FTheme.dialogDecoration,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimens.padding_2xl),
                                          child: isSignout
                                              ? const SizedBox(
                                                  height: 300,
                                                  child: LoaderBird(
                                                    message1:
                                                        Constants.signingOut,
                                                  ))
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(Constants
                                                        .signOutWarningMsg1),
                                                    const Text(Constants
                                                        .signOutWarningMsg2),
                                                    const SizedBox(
                                                      height: Dimens.padding,
                                                    ),
                                                    FButton(
                                                      label: Constants.signOut,
                                                      gradient: true,
                                                      onPressed: () {
                                                        logoutMethod(
                                                            authProvider,
                                                            context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                        ),
                                      );
                                    });
                                  }),
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout))
                  ],
                ),
                body: Column(
                  // clipBehavior: Clip.none,
                  children: [
                    Expanded(
                        flex: 9, child: employeeListView(employeeProvider)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // height: 50,
                        color: isLoading
                            ? WColors.brightColor
                            : Colors.transparent,
                      ),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton.extended(
                  label: const Text(Constants.addEmployee),
                  icon: const Icon(Icons.person_add),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    addEmployeeDialog(context, employeeProvider, () {
                      saveEmployeeMethod(employeeProvider, context,
                          _formKey.currentState!.validate());
                    });
                  },
                ),
              );
            }),
      );
    });
  }
}
