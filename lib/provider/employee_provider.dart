import 'package:flutter/material.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/services/employee_services.dart';

class EmployeeProvider with ChangeNotifier {
  List<EmployeeModel> _employeeList = [];
  List<EmployeeModel> get employeeList => _employeeList;

  getEmployee() async {
    final response = await EmployeeServices().getEmployee();

    if (response.success!) {
      _employeeList = response.data.map<EmployeeModel>((item) {
        return EmployeeModel(
          name: item['name'] as String?,
          rating: item['rating'] as int?,
          objectId: item['objectId'] as String?,
          age: item['age'] as int?,
        );
      }).toList();

      notifyListeners();
    }
  }

  saveEmployee(
      {required String name,
      required String age,
      required String rating}) async {
    await EmployeeServices().saveEmployee(name: name, age: age, rating: rating);
  }

  deleteEmployee({required String id}) async {
    await EmployeeServices().deleteEmployee(id: id);
  }
}
