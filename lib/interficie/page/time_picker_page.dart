import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/widget/edit_car_arguments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TimePickerPage extends StatefulWidget {
  @override
  _TimePickerPageState createState()
  {
    return _TimePickerPageState();
  }
}

class _TimePickerPageState extends State<TimePickerPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> selectedDays = <String>[];
  bool buttonPressed = false;

  List<DayInWeek> _days(context) => [
    DayInWeek(AppLocalizations.of(context).lunes),
    DayInWeek(AppLocalizations.of(context).martes),
    DayInWeek(AppLocalizations.of(context).miercoles),
    DayInWeek(AppLocalizations.of(context).jueves),
    DayInWeek(AppLocalizations.of(context).viernes),
    DayInWeek(AppLocalizations.of(context).sabado),
    DayInWeek(AppLocalizations.of(context).domingo),
  ];

  @override
  Widget build(BuildContext context) {
    final notificationsInfo = ModalRoute.of(context)!.settings.arguments as NewNotificationArgs;
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    String minut = selectedTime.minute.toString();
    if (minut == '0' || minut == '1' || minut == '2'|| minut == '3'|| minut == '4'||
        minut == '5'|| minut == '6'|| minut == '7'|| minut == '8'|| minut == '9') minut = '0' + minut;

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).notificationSettings), // (Peilin) ready for test
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 AutoSizeText(AppLocalizations.of(context).receiveNoti,
                  style: const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ), //(Peilin) ready for test

                const Divider(height: 20,),

                SelectWeekDays(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  days: _days(context),
                  onSelect: (values) {
                    selectedDays = values;
                  },
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      // 10% of the width, so there are ten blinds.
                      colors: [Color(0xFF40ac9c), Color(0xFF203e5a)], // whitish to gray
                      tileMode: TileMode.repeated, // repeats the gradient over the canvas
                    ),
                  ),

                  /*other types of decorations
                  border: false,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      // 10% of the width, so there are ten blinds.
                      colors: [Color(0xFFE55CE4), Color(0xFFBB75FB)], // whitish to gray
                      tileMode: TileMode.repeated, // repeats the gradient over the canvas
                    ),
                  ),

                  **************************************************************************************
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      // 10% of the width, so there are ten blinds.
                      colors: [Color(0xFFE55CE4), Color(0xFFBB75FB)], // whitish to gray
                      tileMode: TileMode.repeated, // repeats the gradient over the canvas
                    ),
                  ),

                   */

                ),

                const Divider(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () {
                        _selectTime(context);
                      },
                      label: Text(AppLocalizations.of(context).time), // (Peilin) ready for test
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        _selectTime(context);
                      },
                      child:
                        AutoSizeText("${selectedTime.hour}:$minut", style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(selectedDays.isEmpty){
            AwesomeDialog(
              context: context,
              width: 500,
              animType: AnimType.LEFTSLIDE,
              dialogType: DialogType.NO_HEADER,
              autoHide: const Duration(seconds: 6),
              title: AppLocalizations.of(context).addAtLeastOneDayTitle,
              desc: AppLocalizations.of(context).addAtLeastOneDayDesc,
              btnOkText:'Ok',
              btnOkOnPress:(){},
              headerAnimationLoop: false,
            ).show();
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).notificationInfoMsg(selectedDays.toString(), selectedTime.hour.toString(), selectedTime.minute.toString()))), // (Peilin) ready for test
            );

            showDialog(
              // The user CANNOT close this dialog  by pressing outsite it
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return Dialog(
                    // The background color
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          // The loading indicator
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 15,
                          ),
                          // Some text
                          Text('Loading...')
                        ],
                      ),
                    ),
                  );
                });

            List<int> selectedDaysInt = daysToInt(selectedDays, context);
            await ctrlPresentation.addNotification(notificationsInfo.latitud, notificationsInfo.longitud, selectedTime.hour, selectedTime.minute, selectedDaysInt);
            Navigator.of(context, rootNavigator: true).pop();

            ctrlPresentation.toNotificationsPage(context, notificationsInfo.latitud, notificationsInfo.longitud, notificationsInfo.title);
          }
        },
        heroTag: AppLocalizations.of(context).addNoti,// (Peilin) ready for test
        tooltip: AppLocalizations.of(context).addNoti,// (Peilin) ready for test
        child: const Icon(Icons.more_time),
        backgroundColor: mPrimaryColor,
      ),
    );
  }
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  List<int> daysToInt(List<String> selectedDays, BuildContext context) {
    List<int> daysAsInt = <int>[];
    for(int i = 0; i < selectedDays.length; ++i){
      switch (selectedDays[i]){
        case "Lunes":
          if(!daysAsInt.contains(1)) daysAsInt.add(1);
          break;
        case "Monday":
          if(!daysAsInt.contains(1)) daysAsInt.add(1);
          break;
        case "Dilluns":
          if(!daysAsInt.contains(1)) daysAsInt.add(1);
          break;
        case "Martes":
          if(!daysAsInt.contains(2)) daysAsInt.add(2);
          break;
        case "Tuesday":
          if(!daysAsInt.contains(2)) daysAsInt.add(2);
          break;
        case "Dimarts":
          if(!daysAsInt.contains(2)) daysAsInt.add(2);
          break;
        case "Dimecres":
          if(!daysAsInt.contains(3)) daysAsInt.add(3);
          break;
        case "Miercoles":
          if(!daysAsInt.contains(3)) daysAsInt.add(3);
          break;
        case "Wednesday":
          if(!daysAsInt.contains(3)) daysAsInt.add(3);
          break;
        case "Jueves":
          if(!daysAsInt.contains(4)) daysAsInt.add(4);
          break;
        case "Dijous":
          if(!daysAsInt.contains(4)) daysAsInt.add(4);
          break;
        case "Thursday":
          if(!daysAsInt.contains(4)) daysAsInt.add(4);
          break;
        case "Friday":
          if(!daysAsInt.contains(5)) daysAsInt.add(5);
          break;
        case "Viernes":
          if(!daysAsInt.contains(5)) daysAsInt.add(5);
          break;
        case "Divendres":
          if(!daysAsInt.contains(5)) daysAsInt.add(5);
          break;
        case "Sabado":
          if(!daysAsInt.contains(6)) daysAsInt.add(6);
          break;
        case "Saturday":
          if(!daysAsInt.contains(6)) daysAsInt.add(6);
          break;
        case "Dissabte":
          if(!daysAsInt.contains(6)) daysAsInt.add(6);
          break;
        case "Diumenge":
          if(!daysAsInt.contains(7)) daysAsInt.add(7);
          break;
        case "Domingo":
          if(!daysAsInt.contains(7)) daysAsInt.add(7);
          break;
        case "Sunday":
          if(!daysAsInt.contains(7)) daysAsInt.add(7);
          break;
      }
    }
    daysAsInt.sort();
    return daysAsInt;
  }
}