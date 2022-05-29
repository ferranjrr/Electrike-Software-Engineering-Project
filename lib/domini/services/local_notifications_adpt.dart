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
  late int id;

  InfoNotification(this.lat, this.long, this.dayOfTheWeek, this.iniHour, this.iniMinute, this.active, this.id);
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
  Map<String, InfoNotification> _currentNotifications = {};
  int lastId = 0;

  Future<void> init() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

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

  void showInstantNotification(double lat, double long) async {

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
  void _createNotification(String id, DateTime when, double lat, double long, int apiId) async {
    CtrlDomain ctrlDomain = CtrlDomain();
    List<String> dadesCargadors = await ctrlDomain.getInfoCharger2(lat,long);

    late String state;
    if (dadesCargadors[6] != "0" || dadesCargadors[10] != "0" || dadesCargadors[14] != "0"|| dadesCargadors[18] != "0") {
      state = "<unknown>";
    } else {
      state = 'Schuko: ' + dadesCargadors[4] + ', Mennekes: ' + dadesCargadors[8] + ', Chademo: ' + dadesCargadors[12] + ' and CCSCombo2: ' + dadesCargadors[16];
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        apiId,
        "Charger point " + dadesCargadors[1] + " state", //ToDo: Translate into 3 languages
        "Your charger point has " +state+ " available chargers.",
        tz.TZDateTime.from(when, tz.local),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime); // en principi això fa que es repeteixi totes les setmanes
  }

  String scheduleNotifications(DateTime when, double lat, double long) {

    late bool active;
    if (hasNotificacions(lat,long)) {
      active = notificationsOn(lat, long);
    } else {
      active = true;
    }

    lastId++;
    InfoNotification infN = InfoNotification(lat, long, when.weekday, when.hour, when.minute, active, lastId);
    String id = _genId(lat, long, when.weekday, when.hour, when.minute);

    if (!_existsNotification(id)) {
      _currentNotifications.putIfAbsent(id, () => infN);
      if (active) _createNotification(id, when, lat, long, lastId);
      return id;
    }
    return "-1";
  }

  bool _existsNotification(String id) {
    return _currentNotifications.containsKey(id);
  }

  String _genId(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) {
    return lat.toString() + "," + long.toString() + "," + dayOfTheWeek.toString() + "," + iniHour.toString() + "," + iniMinute.toString();
  }

  Map<Tuple2<int,int>,List<int>> currentScheduledNotificationsOfAChargerPoint(double lat, double long) {
    Map<Tuple2<int,int>,List<int>> m = <Tuple2<int,int>,List<int>>{};

    _currentNotifications.forEach((key, value) {
      if (value.lat == lat && value.long == long) {
        var key = Tuple2(value.iniHour,value.iniMinute);
        if (!m.containsKey(key)) {
          m.putIfAbsent(key, () => [value.dayOfTheWeek]);
        }else {
          m[key]!.add(value.dayOfTheWeek);
        }
      }
    });

    return m;
  }

  bool hasNotificacions(double lat, double long) {
    bool res = false;

    _currentNotifications.forEach((key, value) {
      if (value.lat == lat && value.long == long) {
        res = true;
      }
    });

    return res;
  }

  String enableNotification(DateTime when, double lat, double long) {
    String id = _genId(lat, long, when.weekday, when.hour, when.minute);

    if (_currentNotifications.containsKey(id) && !_currentNotifications[id]!.active) {
      _currentNotifications[id]!.active = true;
      _createNotification(id, when, lat, long, _currentNotifications[id]!.id);
      return id;
    }
    return "-1";
  }

  String disableNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) {
    String id = _genId(lat, long, dayOfTheWeek, iniHour, iniMinute);

    if (_currentNotifications.containsKey(id) && !_currentNotifications[id]!.active) {
      _flutterLocalNotificationsPlugin.cancel(_currentNotifications[id]!.id);
      _currentNotifications[id]!.active = false;
      return id;
    }

    return "-1";
  }

  //Si el punt de càrrega no existeix o no té cap notificació per aquest punt de càrrega retorna false.
  bool notificationsOn(double lat, double long) {
    bool res = false;

    _currentNotifications.forEach((key, value) {
      if (value.lat == lat && value.long == long && value.active) {
        res = true;
      }
    });

    return res;
  }

  String cancelNotification(double lat, double long, int dayOfTheWeek, int iniHour, int iniMinute) {
    String id = _genId(lat, long, dayOfTheWeek, iniHour, iniMinute);

    if (_currentNotifications.containsKey(id)) {
      if (_currentNotifications[id]!.active) _flutterLocalNotificationsPlugin.cancel(_currentNotifications[id]!.id);
      _currentNotifications.remove(id);
      return id;
    }

    return "-1";
  }

  void cancelAllNotifications() {
    _currentNotifications.clear();
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}