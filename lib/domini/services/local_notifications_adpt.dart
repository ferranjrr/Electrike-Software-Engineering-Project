/*
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/page/favourites_page.dart';
import 'package:flutter_project/interficie/page/garage_page.dart';
import 'package:flutter_project/interficie/widget/ocupation_chart.dart';
*/
/*class LocalNotificationAdpt {
  static final _instance = LocalNotificationAdpt._internal();

  factory LocalNotificationAdpt() {
    return _instance;
  }

  LocalNotificationAdpt._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

}
 ------------ Atra versió:

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class LocalNotificationAdpt {
  static final _instance = LocalNotificationAdpt._internal();
  factory LocalNotificationAdpt() {
    return _instance;
  }
  LocalNotificationAdpt._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('assets/images/logo.png');
}
*/
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = AndroidNotificationDetails("id", "channel", /*"description"*/);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", /*"description"*/
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel", /*"description"*/
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Stylish notification", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", /*"description"*/
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
*/


import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter_project/domini/ctrl_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/page/favourites_page.dart';
import 'package:flutter_project/interficie/page/garage_page.dart';
import 'package:flutter_project/interficie/widget/ocupation_chart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationAdpt {
  //NotificationService a singleton object
  static final LocalNotificationAdpt _notificationService =
  LocalNotificationAdpt._internal();

  factory LocalNotificationAdpt() {
    return _notificationService;
  }

  LocalNotificationAdpt._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //List of current notifications. Info for each: id, lat, long, dayOfTheWeek, iniHour, iniMinute
  static final List<Tuple6<int, double, double, int, int, int>> _currentNotifications = [];

  Future<void> init() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    /*
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
*/
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
       /* iOS: initializationSettingsIOS,
        macOS: null*/);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'id',
    'channel',
    channelDescription: 'description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    autoCancel: false,
  );

  Future<void> showInstantNotification(double lat, double long) async {

    CtrlDomain ctrlDomain = CtrlDomain();
    List<String> dadesCargadors = await ctrlDomain.getInfoCharger2(lat,long);

    late String state;
    if (dadesCargadors[5] != "0") {
      state = "<unknown>";
    } else {
      state = 'Schuko: ' + dadesCargadors[4] + ', Mennekes: ' + dadesCargadors[8] + ', Chademo: ' + dadesCargadors[12] + ' and CCSCombo2: ' + dadesCargadors[16];
    }
    await _flutterLocalNotificationsPlugin.show(
      0,
      "Charger point " + dadesCargadors[1] + " state",
      "Your charger point has " +state+ " available chargers.",
      NotificationDetails(android: _androidNotificationDetails),
    );
  }
/*
  Future<void> scheduleNotifications() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification Title",
        "This is the Notification Body!",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
*/


  Future<void> scheduleNotifications(DateTime when, double lat, double long) async {


/*
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification Title",
        "This is the Notification Body!",
        tz.TZDateTime.utc(2022,5,4,8,21),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);


    var interval = RepeatInterval.everyMinute;

    var platform = NotificationDetails(android: _androidNotificationDetails);
 */
    CtrlDomain ctrlDomain = CtrlDomain();
    List<String> dadesCargadors = await ctrlDomain.getInfoCharger2(lat,long);

    late String state;
    if (dadesCargadors[5] != "0") {
      state = "<unknown>";
    } else {
      state = 'Schuko: ' + dadesCargadors[4] + ', Mennekes: ' + dadesCargadors[8] + ', Chademo: ' + dadesCargadors[12] + ' and CCSCombo2: ' + dadesCargadors[16];
    }

    int id = _createId();
    _currentNotifications.add(Tuple6<int, double, double,int, int, int>(id,lat,long,when.weekday,when.hour,when.minute));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Charger point " + dadesCargadors[1] + " state",
        "Your charger point has " +state+ " available chargers.",
        tz.TZDateTime.from(when, tz.local),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime); // en principi això fa que es repeteixi totes les setmanes
  }

  int _createId() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toInt();
  }


  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    /*var bigPicture = const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("logo.png"),
        largeIcon: DrawableResourceAndroidBitmap("logo.png"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);
*/
    var android = const AndroidNotificationDetails("id", "channel", /*"description"
        styleInformation: bigPicture*/);

    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  //Retorna l'id de la notificació identificada pels paràmetres.
  //Pre: Existeix una notificació dins de _currentNotifications identificada pels paràmetres passats
  int _findId(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) {
    Tuple6<int, double, double, int, int, int> l = _currentNotifications.firstWhere((item) {
      item.item2 == lat && item.item3 == long && item.item4 == dayOfTheWeek && item.item5 == iniHour && item.item6 == iniMinute;
      throw StateError("No id found");
    });
    return l.item1;
  }


  Future<void> cancelNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) async {
    int id = _findId(lat,long,dayOfTheWeek,iniHour,iniMinute);
    _currentNotifications.removeWhere((element) => element.item1==id);
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    _currentNotifications.clear();
    await _flutterLocalNotificationsPlugin.cancelAll();
  }



  displayNotification({required String title, required String body}) async {
    //print("doing test");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',  channelDescription: 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
/*
    var flutterLocalNotificationsPlugin;
    await flutterLocalNotificationsPlugin.show(
      0,
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );*/
  }




}

Future selectNotification(String payload) async {
  //handle your logic here
}




