import 'package:flutter/material.dart';
import 'package:flutter_parse/components/loader.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/provider/auth_provider.dart';
import 'package:flutter_parse/provider/employee_provider.dart';
import 'package:flutter_parse/screens/login_screen.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('employee screen'),
        actions: [
          IconButton(
              onPressed: () {
                logoutMethod(authProvider, context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<employeeModel>>(
        future: employeeListMethod(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                    
                    child: LoaderBird(message1: 'loading data.....',message2: '',)),
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

                    return ListTile(
                      title: Text(employeeName!),
                      subtitle: Text(employeeRating.toString()),
                      // subtitle: Text(employeeRating.toString()),
                    );
                  },
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                  ),
                  TextField(
                    controller: ageController,
                  ),
                  TextField(
                    controller: ratingController,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await employeeProvider.saveEmployee(
                            name: nameController.text,
                            age: ageController.text,
                            rating: ratingController.text);
                            setState(() {
                              
                            });

                        Navigator.pop(context);
                      },
                      child: Text('save'))
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> logoutMethod(
      AuthProvider authProvider, BuildContext context) async {
    await authProvider.userLogout();
    if (authProvider.isLoggedIn == false) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }
}
