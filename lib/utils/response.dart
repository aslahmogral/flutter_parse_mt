class FResponse {//FoodyResponse
  bool? success;
  String? error;
  int? errorCode;
  dynamic data;

  FResponse.success({this.success = true, this.data});

  FResponse.error({this.error, this.errorCode}) : success = false;
}