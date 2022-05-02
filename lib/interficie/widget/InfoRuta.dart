import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class InfoRuta extends StatelessWidget {
  const InfoRuta({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    List<List<String>> userCarList = ctrlPresentation.getCarsList();
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          color: mPrimaryColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            width: 200,
            child: NotificationListener<ScrollEndNotification>(
              child: ListView.builder(
                    itemCount: userCarList.length,
                    itemBuilder: (context, index) => carItem(userCarList[index]),

                    controller: controller,
                    physics: const PageScrollPhysics(), //To stop 1 at a time
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,

                  ),
              onNotification: (notification) {
                print(controller.position.pixels); //dividir el numero de pixeles por el espacio que ocupen los containers. 200 ahora mismo.
                // Return true to cancel the notification bubbling. Return false (or null) to
                // allow the notification to continue to be dispatched to further ancestors.
                return true;
              },
              ),

            ),
          const Divider(
            height: 16,
            color: Colors.black54,
          ),

        ],
      ),
    );
  }

  Widget carItem(List<String> car){
    return Container(
        width: 200.0,
        decoration: const BoxDecoration(
          //color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/brandCars/RAYO.png"),
          ),
        ),
        child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text("Grocery store")
        ),

    );
  }
}