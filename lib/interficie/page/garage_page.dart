import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/page/profile_page.dart';
import 'package:flutter_project/interficie/widget/car_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    List<List<String>> userCarList = ctrlPresentation.getCarsList();
    return Scaffold(
      backgroundColor: mPrimaryColor,
      appBar: buildAppBar(context),
      body: ListView.builder(
        itemCount: userCarList.length,
        itemBuilder: (context, index) => CarListItem(userCarList[index]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mPrimaryColor,
      elevation: 0,
      title: Text(AppLocalizations.of(context).garage),
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context).addcargarage,
          icon: const Icon(
            Icons.add_circle_rounded,
            color: Colors.white,
          ),
          onPressed: (){
            ctrlPresentation.toFormCar(context);
             },
        )
      ],
    );
  }
}
