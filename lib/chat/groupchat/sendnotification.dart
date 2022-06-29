import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class sendnotification {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAAkw2nRZc:APA91bH52kqvjGtmwgbC1eOTJWNbrqGH7W0olK-q2yH0v78MZAxC6FOJLL6WALUgx_MHsah3VwSGFZRlfy5n7wS1wJP4kzB15_s_GJLxkwltSldTD9byrpBs1lZTEqCtwmnsUKx6W0F3";

  void sendFcm(String title, String body,List<String> tokenlist) async {

    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body = ''' {
 "registration_ids" :$tokenlist ,
 "collapse_key" : "type_a",
 "notification" : {
     "body" : "$body",
     "title": "$title"
 }
 }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void sendFcmIndividual(String title, String body,String token) async {

    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body = ''' {
 "to" :$token ,
 "collapse_key" : "type_a",
 "notification" : {
     "body" : "$body",
     "title": "$title"
 }
 }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.statusCode);
    }
  }
  Future<bool> callOnFcmApiSendPushNotifications(String title,String body,String token) async {

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };

    final response = await http.post(Uri.parse(fcmUrl),
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Testt',
              'title': 'New message'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action':
              'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "screen": "OPEN_NOTIFICATION",
            },
            'to':'$token'
          },
        ),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      print('SENT NOTIFICATION SUCCESSFULLY');
      return true;
    } else {
      print('SENT NOTIFICATION SUCCESSFULLY NOTTTT');
      return false;
    }
  }


}

