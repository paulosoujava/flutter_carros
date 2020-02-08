import 'package:carros/api/car_api.dart';
import 'package:carros/pages/car_page.dart';
import 'package:carros/pages/farorite_page.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin<Home> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Prefs.getInt("tabIdx").then((idx) {
      _tabController.index = idx;
    });

    _tabController.addListener(() {
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Carros"),
        bottom: TabBar(
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Classicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esporte",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Favorito",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CarPage(TypeCar.classicos),
          CarPage(TypeCar.esportivos),
          CarPage(TypeCar.luxo),
          FavoritePage(),
        ],
      ),
      //drawer: DrawerList()
    );
  }
}
