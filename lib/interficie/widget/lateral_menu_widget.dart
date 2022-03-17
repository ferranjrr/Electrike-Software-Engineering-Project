import 'package:flutter/material.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/main_test_V.dart';
import 'package:flutter_project/interficie/page/favourites_page.dart';
import 'package:flutter_project/interficie/page/garage_page.dart';
import 'package:flutter_project/interficie/page/login_page.dart';
import 'package:flutter_project/interficie/widget/drop_down_widget.dart';

import '../page/information_app_page.dart';
import '../page/rewards_page.dart';
import '../page/user_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final name = 'Víctor';
    final email = 'victorasenj@gmail.com';
    final urlImage =
        'https://avatars.githubusercontent.com/u/75260498?v=4&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
        color: mPrimaryColor,
        //definim el color de fons del menú lateral
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => selectedItem(context, 16),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Map',
                    icon: Icons.map_outlined,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Garage',
                    icon: Icons.garage,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Favourites',
                    icon: Icons.favorite_border,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Achievements',
                    icon: Icons.emoji_events,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  const MyStatefulWidget(),

                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Information',
                    icon: Icons.info,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Contact us',
                    icon: Icons.phone,
                    onClicked: () => selectedItem(context, 5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );
}

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 18, color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  //definimos dónde navega cada item del menú lateral
  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop(); //sirve para que se cierre el menú al clicar a una nueva página

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GaragePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FavouritesPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RewardsPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InformationAppPage(),
        ));
        break;
      case 5:
        break;
      case 22:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    }
  }