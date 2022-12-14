import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'attribute.dart';

CtrlPresentation ctrlPresentation = CtrlPresentation();

class CarDetailInfomation extends StatelessWidget {
  const CarDetailInfomation({
    Key? key,
    required this.car,
  }) : super(key: key);

  final List<String> car;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          color: mPrimaryColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          CarInfo(car: car),
          const Divider(
            height: 16,
            color: Colors.black54,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    EditInfoCar(car: car),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class EditInfoCar extends StatelessWidget {
  const EditInfoCar({
    Key? key,
    required this.car,
  }) : super(key: key);

  final List<String> car;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            ctrlPresentation.toEditCar(context, car);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mCardColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
                side: BorderSide(color: mCardColor)
              )
            )
          ),
          child: Text(
            AppLocalizations.of(context).edit,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            _showMyDialog(context, car[0]);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(mPrimaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                      side: BorderSide(color: mCardColor)
                  )
              )
          ),
          child:Text(
            AppLocalizations.of(context).delete,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  _showMyDialog(BuildContext context, String carId) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: AppLocalizations.of(context).alertSureDeleteCarTitle,
      desc: AppLocalizations.of(context).alertSureDeleteCarContent,
      btnCancelOnPress: () {},
      btnCancelText: AppLocalizations.of(context).cancel,
      btnOkIcon: (Icons.delete),
      btnOkText: AppLocalizations.of(context).delete,
      btnOkOnPress: () {
        ctrlPresentation.deleteCar(context, carId);
      },
      headerAnimationLoop: false,
    ).show();
  }
}


class CarInfo extends StatelessWidget {
  const CarInfo({
    Key? key,
    required this.car,
  }) : super(key: key);

  final List<String> car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          car[1],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Attribute(
              value: car[2],
              name: AppLocalizations.of(context).carBrand,
              textColor: Colors.black87,
            ),
            Attribute(
              value: car[3],
              name: AppLocalizations.of(context).carModelLabel,
              textColor: Colors.black87,
            ),
            Attribute(
              value: car[4],
              name: AppLocalizations.of(context).carBatteryLabel,
              textColor: Colors.black87,
            ),
            Attribute(
              value: car[5],
              name: AppLocalizations.of(context).efficiency,
              textColor: Colors.black87,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        buildConnectors(),
      ],
    );
  }

  Widget buildConnectors() => ResponsiveGridRow(
      children: [
        if(car.contains("Schuko"))
          ResponsiveGridCol(
            xs: 6,
            md: 3,
            child: buildConnectorInfo(
              logoConnector: "assets/images/Schuko.png",
              nameConnector: "Schuko",
            ),
          ),

        if(car.contains("Mennekes"))
          ResponsiveGridCol(
            xs: 6,
            md: 3,
            child: buildConnectorInfo(
              logoConnector: "assets/images/Mennekes.png",
              nameConnector: "Mennekes",
            ),
          ),

        if(car.contains("Chademo"))
          ResponsiveGridCol(
            xs: 6,
            md: 3,
            child: buildConnectorInfo(
              logoConnector: "assets/images/CHAdeMO.png",
              nameConnector: "CHAdeMO",
            ),
          ),

        if(car.contains("CCSCombo2"))
          ResponsiveGridCol(
            xs: 6,
            md: 3,
            child: buildConnectorInfo(
              logoConnector: "assets/images/ComboCCS2.png",
              nameConnector: "CCS Combo",
            ),
          ),
      ]
  );

  Widget buildConnectorInfo({
    required String logoConnector,
    required String nameConnector,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          logoConnector,
          height: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        AutoSizeText(
          nameConnector,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

}