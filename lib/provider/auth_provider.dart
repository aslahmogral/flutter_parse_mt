import 'package:flutter/material.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/services/auth_services.dart';
import 'package:flutter_parse/services/employee_services.dart';

import '../utils/response.dart';

class AuthProvider with ChangeNotifier {
  bool? _isLoggedIn;

  bool? get isLoggedIn => _isLoggedIn;

  Future<FResponse> userLogin(
      {required String adminName, required String adminPassword}) async {
        final response = await AuthServices().userLogin(
        adminName: adminName,
        adminPassword: adminPassword,
      );
    try {
      
      if (response.success!) {
        print('---------------sucees------------');
        _isLoggedIn = true;
        notifyListeners();
        return response;
      } else {
        print('-----------error------sdfgsdf----${response.error}============');
        _isLoggedIn = false;
        print('error');
        notifyListeners();
        return response;

      }
    } catch (e) {
      print('-----------exception-----');
      _isLoggedIn = false;
      print('error: $e');
      notifyListeners();
        return response;
      
      
    }
  }

  userLogout() async {
    try {
      final response = await AuthServices().userLogout();
      if (response.success!) {
        _isLoggedIn = false;
        notifyListeners();
      } else {
        _isLoggedIn = true;
        print('error');
        notifyListeners();
      }
    } catch (e) {
      _isLoggedIn = true;
      print('error: $e');
      notifyListeners();
    }
  }
}
