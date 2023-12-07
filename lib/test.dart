import 'dart:convert';
import 'package:flutter_firebase/chat.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print('===============================');
    print(mytoken);
  }

  // App Terminated
  getmessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.notification != null) {
//      String? title = initialMessage.notification!.title;
      String? body = initialMessage.notification!.body;

      if (initialMessage.data['type'] == 'chat') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Chat(body: body)));
      }
    }
  }

//         if iphone oR IOS devices
  myrequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    //terminated_State
    getmessage();

    // Background Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
                  body: message.notification!.body,
                )));
      }
    });

    // forground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("=========================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("=========================");

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${message.notification!.body}")));
      }
    });

    myrequestPermission();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification Message",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          MaterialButton(
              onPressed: () async {
                await sendTopic(
                    "Hello", "How Are You Today !", "MohamedEbrahem");
              },
              child: const Text(
                "Send Topic Message",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
          MaterialButton(
              onPressed: () async {
                await FirebaseMessaging.instance
                    .subscribeToTopic("MohamedEbrahem");
              },
              child: const Text(
                "Subscribe to Topic",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
          MaterialButton(
              onPressed: () async {
                await FirebaseMessaging.instance
                    .unsubscribeFromTopic("MohamedEbrahem");
              },
              child: const Text(
                "Unsubscribe To Topic",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}

sendNotification(String title, String message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA7X0s_B4:APA91bHSWb_pN5W8ka0X9sNQMJ-_DSohQ-nsmIYJbNOiN_NZUsd6-hnYZm2a14UQ5qHEQXPle-NMeD-whYoCqSvWwGnSQZUPvHM8eNOUVCCpJOLAwrQqB1AEWkR5r89QxdW2BgIcQG1u'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "cJKbPtD5TkiJ2VcCUGrcfm:APA91bEAtiPJ0ROTESqLnlNiULA9EQcvdLqHRuFD1Wj7mSSg5Vlf8I30zy8-UGhdXhrjGVr1NWjycjEfifpvWjFmZeZqjRBAvbEy2HP-mkwbow5oC6hedoFMbzWPKzMHZGm-aRHPWnjB",
    "notification": {"title": title, "body": message}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}

sendTopic(String title, String message, topic) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA7X0s_B4:APA91bHSWb_pN5W8ka0X9sNQMJ-_DSohQ-nsmIYJbNOiN_NZUsd6-hnYZm2a14UQ5qHEQXPle-NMeD-whYoCqSvWwGnSQZUPvHM8eNOUVCCpJOLAwrQqB1AEWkR5r89QxdW2BgIcQG1u'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {"title": title, "body": message}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
