import 'package:flutter/material.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/services/employee_services.dart';

class EmployeeProvider with ChangeNotifier{
  List<employeeModel> _employeeList = [];
  List<employeeModel> get employeeList => _employeeList;


  getEmployee() async {
    print('aslah : provider : getemployee');
    final response = await EmployeeServices().getEmployee();
    print('------------------getemployee---------------------');
    print(response.data);

    print('--------------------------------');

    if (response.success!) {
      print('------------------getemployee---------------------');
      _employeeList = response.data.map<employeeModel>((item) {
        return employeeModel(
          name: item['name'] as String?,
          rating: item['rating'] as int?,
          objectId: item['objectId'] as String?,
          age: item['age'] as int?,
        );
      }).toList();

      print('///////////////////////');
      print(employeeList.runtimeType);

      notifyListeners();
    }
  }

  saveEmployee(
      {required String name,
      required String age,
      required String rating}) async {
    print('aslah : provider : getemployee');
    await EmployeeServices().saveEmployee(name: name, age: age, rating: rating);
  }
}