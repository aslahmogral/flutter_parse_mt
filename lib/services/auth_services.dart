import 'package:flutter_parse/services/service_helper.dart';
import 'package:flutter_parse/utils/response.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  Future<FResponse> userLogin(
      {required String adminName, required String adminPassword}) async {
    try {
      final user = ParseUser(adminName, adminPassword, null);

      var response = await user.login();

      if (response.success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(ServiceHelper.userLoggedInKey, 'true');
        final check = await prefs.getString('logged');
        print(check);

        return FResponse.success(data: response);
      } else {
        return FResponse.error(error: response.error!.message);
      }
    } catch (e) {
      print(e);
      return FResponse.error(error: e.toString());
    }
  }

  Future<FResponse> userLogout() async {

    final user = await ParseUser.currentUser() as ParseUser;

    var response = await user.logout();

    if (response.success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(ServiceHelper.userLoggedInKey);
      final check = await prefs.getString('logged');
      print(check);
      return FResponse.success(data: response);
    } else {

      return FResponse.error();
    }
  }
}
