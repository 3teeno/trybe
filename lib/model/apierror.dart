import 'dart:ui';

class APIError {
  String status;
  dynamic message;
  // int status;
  VoidCallback onAlertPop;

  APIError({this.status, /*this.status,*/ this.message, this.onAlertPop});

  APIError.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
