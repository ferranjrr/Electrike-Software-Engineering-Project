import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/domini/usuari.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/widget/lateral_menu_widget.dart';
import 'package:flutter_project/interficie/widget/numbers_widget.dart';
import 'package:flutter_project/interficie/widget/profile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
CtrlPresentation ctrlPresentation = CtrlPresentation();
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String imgPath = ctrlPresentation.photoUrl;
    String name = ctrlPresentation.name;
    String email = ctrlPresentation.email;


    return  Builder(
        builder: (context) => Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).profile),
            backgroundColor: mPrimaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: imgPath,
                  onClicked: () {  },
                ),
                const SizedBox(height: 24),
                buildName(imgPath, name, email),
                const SizedBox(height: 24),
                const NumbersWidget(),
                const SizedBox(height: 48),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: mCardColor,
            child: const Icon(Icons.delete_forever),
            onPressed: () {
              _showDialogDeleteUserAccountConfirmation();
            },
          ),
        ),
    );
  }

  Widget buildName(String imgPath, String name, String email) => Column(
    children: [
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        email,
        style: const TextStyle(color: Colors.grey),
      )
    ],
  );

  _showDialogDeleteUserAccountConfirmation() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: AppLocalizations.of(context).deleteaccountquestion,
      desc: AppLocalizations.of(context).deleteaccountdesc+'\n'+
        AppLocalizations.of(context).deleteaccountquestion +'\n',
      btnCancelOnPress: () {},
      btnCancelText: AppLocalizations.of(context).cancel,
      btnOkIcon: (Icons.delete),
      btnOkText: AppLocalizations.of(context).delete,
      btnOkOnPress: () {
        ctrlPresentation.deleteAccount(context);
      },
      headerAnimationLoop: false,
    ).show();
  }
}