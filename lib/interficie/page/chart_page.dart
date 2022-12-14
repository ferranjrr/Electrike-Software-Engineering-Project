import 'package:flutter/material.dart';
import 'package:flutter_project/domini/data_graphic.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/widget/ocupation_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}
class _ChartPageState extends State<ChartPage> {
  String dropdownValue = "Monday";
  bool firstime = false;

  @override
  Widget build(BuildContext context) {
    if(!firstime){
      setState(() {
        dropdownValue = AppLocalizations.of(context).day1;
        firstime = true;
      });
    }

    //dropdownValue = AppLocalizations.of(context).day1;
    final pointTitle = ModalRoute.of(context)!.settings.arguments as String;
    //CtrlPresentation ctrlPresentation = CtrlPresentation();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child:
                RichText(
                  text: TextSpan(
                    text: pointTitle,
                    style: const TextStyle(color: Colors.black, fontSize: 25),


                )
              ),
            ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
                  /*AppLocalizations.of(context).day1, AppLocalizations.of(context).day2,
                  AppLocalizations.of(context).day3, AppLocalizations.of(context).day4,
                  AppLocalizations.of(context).day5, AppLocalizations.of(context).day6,
                  AppLocalizations.of(context).day7,*/
            items: <String>[AppLocalizations.of(context).day1, AppLocalizations.of(context).day2, AppLocalizations.of(context).day3, AppLocalizations.of(context).day4, AppLocalizations.of(context).day5, AppLocalizations.of(context).day6, AppLocalizations.of(context).day7,]
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              alignment: Alignment.bottomCenter,
              child:
                SizedBox(
                  width: 500.0,
                  height: 500.0,
                  child: OcupationChart(createData(dropdownValue), animate: false),
                )
            )
          ]
        ),
      )
    );
  }

  static List<charts.Series<DataGraphic, String>> createData(String dia) {
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    final data = ctrlPresentation.getInfoGraphic(dia);

    return [
      charts.Series<DataGraphic, String>(
        id: 'Ocupacio',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (DataGraphic occupation, _) => occupation.hour.toInt().toString(),
        measureFn: (DataGraphic occupation, _) => occupation.percentage.round(),
        data: data,
        // Set a label accessor to control the text of the bar label.

      )
    ];
  }

  AppBar buildAppBar(BuildContext context) {
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    return AppBar(
      backgroundColor: mPrimaryColor,
      elevation: 0,
      title: const Text('Charts'),//multiidiomas peilin
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context).legend,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: (){
            ctrlPresentation.showLegendDialog(context, "chartPage");
          },
        )
      ],
    );
  }

}