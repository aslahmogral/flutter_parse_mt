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
import 'package:flutter_parse/utils/dimens.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final ratingController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> isSignOutLoadingNotifier = ValueNotifier(false);

  Future<List<employeeModel>> employeeListMethod() async {
    List<employeeModel> employeeList = [];

    final employeeProvider =
        await Provider.of<EmployeeProvider>(context, listen: false);
    await employeeProvider.getEmployee();
    employeeList = await employeeProvider.employeeList;
    return employeeList;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);

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
                title: Text('Employee Details'),
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
                                  return Container(
                                    decoration: FTheme.dialogDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: isSignout
                                          ? Container(
                                              height: 300,
                                              child: LoaderBird(
                                                message1: 'Signing Out.....',
                                              ))
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Are You Sure '),
                                                Text('You Want to Signout'),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                FButton(
                                                  label: 'Sign Out',
                                                  gradient: true,
                                                  onPressed: () {
                                                    logoutMethod(
                                                        authProvider, context);
                                                  },
                                                )
                                              ],
                                            ),
                                    ),
                                  );
                                }),
                          ),
                        );
                        // logoutMethod(authProvider, context);
                      },
                      icon: Icon(Icons.logout))
                ],
              ),
              body: Column(
                // clipBehavior: Clip.none,
                children: [
                  Expanded(
                    flex: 9,
                    child: employeeListView(employeeProvider)),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // height: 50,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: Text('Add Employee'),
                icon: Icon(Icons.person_add),
                backgroundColor: Colors.black,
                onPressed: () {
                  alertDialog(context, employeeProvider, () {
                    saveEmployeeMethod(employeeProvider, context);
                    nameController.clear();
                    ageController.clear();
                    ratingController.clear();
                  });
                },
              ),
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerFloat,
            );
          }),
    );
  }

  Future<dynamic> alertDialog(BuildContext context,
      EmployeeProvider employeeProvider, void Function()? onPressed) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: FTheme.dialogDecoration,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.padding_xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter Employee Details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: Dimens.padding_xxl,
                ),
                WTextFormField(
                  label: 'Enter Name',
                  textEditingController: nameController,
                ),
                SizedBox(
                  height: Dimens.padding,
                ),
                WTextFormField(
                  label: 'Enter Age',
                  textEditingController: ageController,
                ),
                SizedBox(
                  height: Dimens.padding,
                ),
                WTextFormField(
                  label: 'Enter Rating',
                  textEditingController: ratingController,
                ),
                SizedBox(
                  height: Dimens.padding,
                ),
                FButton(
                  onPressed: onPressed,
                  //  () {
                  //   // saveEmployeeMethod(employeeProvider, context);
                  // },
                  label: 'Save',
                  gradient: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveEmployeeMethod(
      EmployeeProvider employeeProvider, BuildContext context) async {
    await employeeProvider.saveEmployee(
        name: nameController.text,
        age: ageController.text,
        rating: ratingController.text);
    setState(() {
      Navigator.pop(context);
    });
  }

  FutureBuilder<List<employeeModel>> employeeListView(
      EmployeeProvider employeeProvider) {
    return FutureBuilder<List<employeeModel>>(
      future: employeeListMethod(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Container(
                  child: LoaderBird(
                message1: 'loading data.....',
                message2: '',
              )),
            );

          default:
            if (snapshot.hasError) {
              return Center(
                child: Text("error..."),
              );
            } else if (!snapshot.hasData) {
              return Center(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 6,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: WColors.primaryColor,
                            child: Text(
                              getStringFirstLetter(
                                  employeeName.toString().toUpperCase()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: WColors.brightColor),
                            ),
                          ),
                          title: Text(employeeName!),
                          subtitle: Text(employeeRating.toString()),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  employeeProvider.deleteEmployee(
                                      id: employeeId.toString());
                                });
                                // print(employeeId);
                              },
                              icon: Icon(Icons.delete))),
                    ),
                  );
                },
              );
            }
        }
      },
    );
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

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  // Future<void> updateTodo(String id, bool done) async {
  //   var todo = ParseObject('Todo')
  //     ..objectId = id
  //     ..set('name', nameController)
  //     ..set('rating', int.parse(ratingController.text))
  //     ..set('age', int.parse(ageController.text));
  //   await todo.save();
  // }
}
