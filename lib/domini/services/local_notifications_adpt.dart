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

class InfoNotification {
  late double lat;

  late double long;

  late int dayOfTheWeek;

  late int iniHour;

  late int iniMinute;

  late bool active;

  InfoNotification(this.lat, this.long, this.dayOfTheWeek, this.iniHour, this.iniMinute, this.active);
}

class LocalNotificationAdpt {
  //NotificationService a singleton object
  static final LocalNotificationAdpt _notificationService =
  LocalNotificationAdpt._internal();

  factory LocalNotificationAdpt() {
    return _notificationService;
  }

  LocalNotificationAdpt._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //Map of current notifications. Key: id
  static final Map<int, InfoNotification> _currentNotifications = {};

  static late int lastIdCreated = 0;

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
    'Charger Ponints',
    channelDescription: 'Will display a notification about the state of your favourite charger points you have set',
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

  //Afegeix una notificació local al mòbil
  Future<void> _createNotification(int id, DateTime when, double lat, double long) async {
    CtrlDomain ctrlDomain = CtrlDomain();
    List<String> dadesCargadors = await ctrlDomain.getInfoCharger2(lat,long);

    late String state;
    if (dadesCargadors[6] != "0" || dadesCargadors[10] != "0" || dadesCargadors[14] != "0"|| dadesCargadors[18] != "0") {
      state = "<unknown>";
    } else {
      state = 'Schuko: ' + dadesCargadors[4] + ', Mennekes: ' + dadesCargadors[8] + ', Chademo: ' + dadesCargadors[12] + ' and CCSCombo2: ' + dadesCargadors[16];
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Charger point " + dadesCargadors[1] + " state", //ToDo: Translate into 3 languages
        "Your charger point has " +state+ " available chargers.",
        tz.TZDateTime.from(when, tz.local),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime); // en principi això fa que es repeteixi totes les setmanes
  }

  Future<int> scheduleNotifications(DateTime when, double lat, double long, int id) async {
    late bool active;
    if (hasNotificacions(lat,long)) {
      active = notificationsOn(lat, long);
    } else {
      active = true;
    }
    InfoNotification infN = InfoNotification(lat, long, when.weekday, when.hour, when.minute, active);

    if (!(await _existsNotification(lat, long, when.weekday, when.hour, when.minute))) {
      if (id == -1) {
        id = _createId();
      } else if (lastIdCreated < id) {
        lastIdCreated = id;
      }

      var entry = <int, InfoNotification>{id: infN};
      _currentNotifications.addEntries(entry.entries);
      if (active) await _createNotification(id, when, lat, long);
      return id;
    }
    return -1;
  }

  Future<bool> _existsNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) async {
    for (var id in _currentNotifications.keys) {
      if (_currentNotifications[id]!.lat == lat &&
          _currentNotifications[id]!.long == long &&
          _currentNotifications[id]!.dayOfTheWeek == dayOfTheWeek &&
          _currentNotifications[id]!.iniHour == iniHour &&
          _currentNotifications[id]!.iniMinute == iniMinute) {
        return true;
      }
    }
    return false;
  }

  int _createId() {
    if (lastIdCreated == 2^31 - 1) {
      lastIdCreated = 1;
    } else {
      lastIdCreated += 1;
    }
    return lastIdCreated;
  }

  int _findId(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) {
    for (var id in _currentNotifications.keys) {
      if (_currentNotifications[id]!.lat == lat &&
          _currentNotifications[id]!.long == long &&
          _currentNotifications[id]!.dayOfTheWeek == dayOfTheWeek &&
          _currentNotifications[id]!.iniHour == iniHour &&
          _currentNotifications[id]!.iniMinute == iniMinute) {
        return id;
      }
    }
    return -1;
  }

  Map<Tuple2<int,int>,List<int>> currentScheduledNotificationsOfAChargerPoint(double lat, double long) {
    Map<Tuple2<int,int>,List<int>> m = <Tuple2<int,int>,List<int>>{};
    for (var i in _currentNotifications.keys) {
      if (_currentNotifications[i]?.lat == lat && _currentNotifications[i]?.long == long) {

        if (m[Tuple2(_currentNotifications[i]!.iniHour,_currentNotifications[i]!.iniMinute)] == null) {
          var entry = <Tuple2<int,int>,List<int>>{
            Tuple2(_currentNotifications[i]!.iniHour,_currentNotifications[i]!.iniMinute): [_currentNotifications[i]!.dayOfTheWeek]
          };
          m.addEntries(entry.entries);
        }
        else {
          m[Tuple2(_currentNotifications[i]!.iniHour,_currentNotifications[i]!.iniMinute)]!.add(_currentNotifications[i]!.dayOfTheWeek);
        }
      }
    }
    return m;
  }

  bool hasNotificacions(double lat, double long) {
    for (var id in _currentNotifications.keys) {
      if (_currentNotifications[id]!.lat == lat &&
          _currentNotifications[id]!.long == long) {
        return true;
      }
    }
    return false;
  }

  Future<int> enableNotification(DateTime when, double lat, double long) async {
    int id = _findId(lat, long, when.weekday, when.hour, when.minute);
    if (id != -1 && !_currentNotifications[id]!.active) {
      _currentNotifications[id]!.active = true;
      await _createNotification(id, when, lat, long);
    }
    return id;
  }

  Future<int> disableNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) async {
    int id = _findId(lat, long, dayOfTheWeek, iniHour, iniMinute);
    if (id != -1 && _currentNotifications[id]!.active) {
      await _flutterLocalNotificationsPlugin.cancel(id);
      _currentNotifications[id]!.active = false;
    }

    return id;
  }

  //Si el punt de càrrega no existeix o no té cap notificació per aquest punt de càrrega retorna false.
  bool notificationsOn(double lat, double long) {
    for (var idNotif in _currentNotifications.keys) {
      if (_currentNotifications[idNotif]!.lat == lat
      && _currentNotifications[idNotif]!.long == long
      && _currentNotifications[idNotif]!.active) {
        return true;
      }
    }
    return false;
  }

  Future<int> cancelNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) async {
    int id = _findId(lat, long, dayOfTheWeek, iniHour, iniMinute);
    if (id != -1) {
      if (_currentNotifications[id]!.active) await _flutterLocalNotificationsPlugin.cancel(id);
      _currentNotifications.remove(id);
      if (lastIdCreated == id) --lastIdCreated;
    }
    return id;
  }

  Future<void> cancelAllNotifications() async {
    _currentNotifications.clear();
    lastIdCreated = 0;
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}