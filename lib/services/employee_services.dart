import 'package:flutter_parse/utils/response.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class EmployeeServices {

  Future<FResponse> getEmployee() async {
    QueryBuilder<ParseObject> queryEmployee =
        QueryBuilder<ParseObject>(ParseObject('employees'));
    queryEmployee.orderByDescending('rating');
    final ParseResponse apiResponse = await queryEmployee.query();
    try {
      if (apiResponse.success && apiResponse.results != null) {
        print('*************************1');
        return FResponse.success(
            data: apiResponse.results as List<ParseObject>);
      } else {
        print('*************************2');

        return FResponse.error();
      }
    } catch (e) {
      print('*************************3');

      print(e);
      return FResponse.error();
    }
  }

  Future<FResponse> saveEmployee({required String name, required String age, required String rating}) async {
   
    try {
      final employee = ParseObject('employees')
      ..set('name', name)
      ..set('rating', int.parse(rating))
      ..set('age', int.parse(age));

    await employee.save();
    return FResponse.success(success:true );
    } catch (e) {
      print('*************************3');

      print(e);
      return FResponse.error();
    }
  }


 
}
