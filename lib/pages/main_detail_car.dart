import 'package:carros/entity/car.dart';
import 'package:carros/pages/car_form_page.dart';
import 'package:carros/pages/delete_car.dart';
import 'package:carros/pages/detail_car.dart';
import 'package:carros/pages/map.dart';
import 'package:carros/pages/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';

class MainDetailCar extends StatefulWidget {
  Car car;

  MainDetailCar(this.car);

  @override
  _MainDetailCarState createState() => _MainDetailCarState();
}

class _MainDetailCarState extends State<MainDetailCar> {

  _MainDetailCarState();

  List<ScreenHiddenDrawer> itens = new List();
  @override
  void initState() {
    Car car = widget.car;
    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Home",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.teal,
        ),
        DetailCar(car)));
    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Editar",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.teal,
        ),
        CarFormPage(car:car)));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Deletar",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.red,
        ),
        DeleteCar(car)));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Video",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.orange,
        ),
        Video(car)));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Mapa",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.blue,
        ),
        Mapa(car)));



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.black,
      backgroundColorAppBar: Colors.black,
      backgroundColorContent: Colors.black,
      screens: itens,
         typeOpen: TypeOpen.FROM_RIGHT,
          enableScaleAnimin: true,
          enableCornerAnimin: true,
          slidePercent: 80.0,
          verticalScalePercent: 80.0,
          contentCornerRadius: 10.0,
          iconMenuAppBar: Icon(Icons.menu),
          whithAutoTittleName: true,
          styleAutoTittleName: TextStyle(color: Colors.red),
          actionsAppBar: <Widget>[],
          elevationAppBar: 4.0,
          tittleAppBar: Center(child: Icon(Icons.directions_car),),
          enableShadowItensMenu: true,
          backgroundMenu: DecorationImage(image: NetworkImage(widget.car.urlFoto),fit: BoxFit.cover),
    );
  }
}
