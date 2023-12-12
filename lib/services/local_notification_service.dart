import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/app_config.dart';
import '../widgets/constants.dart';

class LocalNotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static void initialize() {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      // iOS: IOSInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (payload) async {
      //   print('payload: $payload');
      //   onNotifications.add(payload);
      //   // Get.to(() => const NotificationsList());
      //   // print("onSelectNotification");
      //   // if (id!.isNotEmpty) {
      //   //   print("Router Value1234 $id");
      //
      //   //   // Navigator.of(context).push(
      //   //   //   MaterialPageRoute(
      //   //   //     builder: (context) => const NotificationsList(),
      //   //   //   ),
      //   //   // );
      //   // }
      // },
    );

  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          AppConfig.notification_channelId,
          AppConfig.notification_channelName,
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          color: gMainColor.withOpacity(0.4),
          colorized: true
          //   sound: RawResourceAndroidNotificationSound('yourmp3files.mp3'),
        ),
        // iOS: IOSNotificationDetails(
        //   //  sound: 'azan1.mp3',
        //   presentSound: true,
        // ),
        // macOS: MacOSNotificationDetails(
        //   presentSound: true,
        // ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      ).then((value) {
        print("notify:}");
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  /// this function is not using now
  /// it will helps when quickblox package used
  void showQBNotification(RemoteMessage message) {
    print("Notification Message: ${message.toMap()}");
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'channel_id', 'some_title', description: 'some_description',
        importance: Importance.high);

    // message recieved: {senderId: null, category: null, collapseKey: event38739295,
    // contentAvailable: false, data: {msg: hello sjsnjlasjnas,
    // fcm: abc, message: This is Notification Test Message},
    // from: 728114586270, messageId: 0:1672989796313608%021842b3f9fd7ecd,
    // messageType: null, mutableContent: false, notification: null,
    // sentTime: 1672989796282, threadId: null, ttl: 86400}

    //Notification Message: {
    // senderId: null, category: null,
    // collapseKey: event38755058, contentAvailable: false,
    // data: {message: {"title":"You have New Message","message":"ghghghgh","type":"chat"}},
    // from: 223001521272, messageId: 0:1673589826135148%021842b3f9fd7ecd,
    // messageType: null,
    // mutableContent: false,
    // notification: null, sentTime: 1673589826107, threadId: null, ttl: 86400}

    AndroidNotificationDetails details = AndroidNotificationDetails(
        channel.id, channel.name, channelDescription:  channel.description,
        icon: "@mipmap/ic_launcher");

    if(message.data != null ||message.data.isNotEmpty){
      //message.data11 {notification_type: shopping, tag_id: ,
      // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
      // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
      // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
      // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
      int id = message.hashCode;
      String title = "New Chat Message";
      String body = message.data["message"];

      Map payload = jsonDecode(body);
      String textMsg = payload["message"];
      payload["type"] = "chat";
      String senderId = payload['senderId'].toString();

      final _pref = AppConfig().preferences;
      int? userId = int.parse(_pref!.getString(AppConfig.QB_CURRENT_USERID)!);

      if(senderId != userId.toString()){
        _notificationsPlugin.show(id, title, textMsg,
            NotificationDetails(android: details),
            payload: message.data.toString()
        );
      }
    }
  }

}
