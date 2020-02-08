import 'package:carros/pages/favorito_model.dart';
import 'package:carros/pages/splash.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventBus>(
          builder: (context)=> EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<FavoritoModel>(
          builder: (context)=> FavoritoModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch:
          Colors.blue,
          brightness: Brightness.dark
        ),
        home: Splash(),
      ),
    );
  }


}
