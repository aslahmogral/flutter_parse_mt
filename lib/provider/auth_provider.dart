import 'package:flutter/material.dart';
import 'package:flutter_parse/services/auth_services.dart';

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
        _isLoggedIn = true;
        notifyListeners();
        return response;
      } else {
        _isLoggedIn = false;
        notifyListeners();
        return response;

      }
    } catch (e) {
      _isLoggedIn = false;
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
        notifyListeners();
      }
    } catch (e) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}
