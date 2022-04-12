import 'package:flutter/material.dart';
import 'package:flutter_project/domini/coordenada.dart';
import 'package:flutter_project/generated/l10n.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/widget/lateral_menu_widget.dart';


class FavsChargers extends StatefulWidget {
  const FavsChargers({Key? key}) : super(key: key);

  @override
  State<FavsChargers> createState() => _FavsChargersState();
}

class _FavsChargersState extends State<FavsChargers> {
  @override
  Widget build(BuildContext context) {
    CtrlPresentation ctrlPresentation = CtrlPresentation();
    List<Coordenada> chargerPoints = ctrlPresentation.getFavsPoints();
    return ListView.separated(
        itemCount: chargerPoints.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          Coordenada word = chargerPoints[index];
          bool isSaved = ctrlPresentation.isAFavPoint(word.latitud, word.longitud);

          return ListTile(
            title: Text(ctrlPresentation.getInfoCharger(word.latitud, word.longitud)[1]),
            trailing: IconButton(
              icon: (const Icon(Icons.favorite)),
              color: isSaved ? Colors.red : null,
              onPressed: () {
                //WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
                chargerPoints.remove(word);
                ctrlPresentation.loveClicked(context, word.latitud, word.longitud);
                //  }));
                setState(() {});
                }
            ),
            onTap: () {
                ctrlPresentation.moveCameraToSpecificLocation(context, word.latitud, word.longitud);
                //ctrlPresentation.loveClicked(context, word.latitud, word.longitud); //todo: ahora aquí se desalva cuando se clica y debería ir al punto
            },
          );
        },
    );
  }
}


class FilterFavsItems extends StatefulWidget {
  const FilterFavsItems({Key? key}) : super(key: key);

  @override
  State<FilterFavsItems> createState() => _FilterFavsItemsState();
}

class _FilterFavsItemsState extends State<FilterFavsItems> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FavsChargers(), //todo: replicar con bicings y conectar
    FavsChargers(),
    FavsChargers(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Favourites"),
        backgroundColor: mPrimaryColor,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_sharp),
            label: S.of(context).allFavourites,
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.electrical_services),
            label: S.of(context).chargers,
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pedal_bike),
            label: S.of(context).bicing,
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
