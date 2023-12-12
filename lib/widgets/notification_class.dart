import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/local_notification_service.dart';

notificationFunction() async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationService.initialize();

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  // await Firebase.initializeApp();

  print("message bg: ${message.data.toString()}");

  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
    print("message.data11 ${message.data}");
    //message.data11 {notification_type: shopping, tag_id: ,
    // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
    // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
    // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
    // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}

    LocalNotificationService.createanddisplaynotification(message);
  }
  else{
    LocalNotificationService().showQBNotification(message);
  }
}
