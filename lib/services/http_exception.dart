class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException({this.message = 'Internal Server Error', this.statusCode = 500});

  @override
  String toString() {
    return message;
  }
}