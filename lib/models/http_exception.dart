import 'dart:io';

class httpException extends HttpException {
  httpException(String message) : super(message);
  @override
  String toString() {
    return message;
  }
}
