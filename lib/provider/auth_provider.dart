import 'package:flutter/material.dart';
import 'package:flutter_parse/model/employee_model.dart';
import 'package:flutter_parse/services/auth_services.dart';
import 'package:flutter_parse/services/employee_services.dart';

class AuthProvider with ChangeNotifier {
  bool? _isLoggedIn;

  bool? get isLoggedIn => _isLoggedIn;

  userLogin({required String adminName, required String adminPassword}) async {
    try {
      final response = await AuthServices().userLogin(
        adminName: adminName,
        adminPassword: adminPassword,
      );
      if (response.success!) {
        _isLoggedIn = true;
        notifyListeners();
      } else {
        _isLoggedIn = false;
        print('error');
        notifyListeners();
      }
    } catch (e) {
      _isLoggedIn = false;
      print('error: $e');
      notifyListeners();
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
