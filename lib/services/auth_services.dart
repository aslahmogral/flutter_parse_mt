import 'package:flutter_parse/utils/response.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthServices {
  Future<FResponse> userLogin(
      {required String adminName, required String adminPassword}) async {
    print('----------------userlogin services-----------');

    try {
      final user = ParseUser(adminName, adminPassword, null);

      var response = await user.login();

      if (response.success) {
        print('---------------employee services : userlogin : success');
        print('[[[[[[[[[[[[[[[[[[[[$response]]]]]]]]]]]]]]]]]]]]');
        return FResponse.success(data: response);
      } else {
        print('---------------employee services : userlogin : faile');

        return FResponse.error(error: response.error!.message);
      }
    } catch (e) {
      print('[[[[[[[[[[[[[[[[[$e]]]]]]]]]]]]]]]]]');
      print(e);
      return FResponse.error(error: e.toString());
    }
  }

  Future<FResponse> userLogout() async {
    print('----------------userlogout services-----------');

    final user = await ParseUser.currentUser() as ParseUser;

    var response = await user.logout();

    if (response.success) {
      print('---------------employee services : userlogout : success');
      print('[[[[[[[[[[[[[[[[[[[[$response]]]]]]]]]]]]]]]]]]]]');
      return FResponse.success(data: response);
    } else {
      print('---------------employee services : userlogout : faile');

      return FResponse.error();
    }
  }
}
