import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/entity/user.dart';
import 'package:carros/pages/login.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:loading_animations/loading_animations.dart';

class GuillotineMenu extends StatefulWidget {
  User user;

  GuillotineMenu(this.user);

  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

class _GuillotineMenuState extends State<GuillotineMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationControllerMenu;
  Animation<double> animationMenu;
  Animation<double> animationTitleFadeInOut;
  _GuillotineAnimationStatus menuAnimationStatus;

  final List<Map> _menus = <Map>[
    {
      "icon": Icons.directions_car,
      "title": "Luxo",
      "color": Colors.white,
    },
    {
      "icon": Icons.directions_car,
      "title": "Classicos",
      "color": Colors.white,
    },
    {
      "icon": Icons.directions_car,
      "title": "Esportivos",
      "color": Colors.white,
    },
    {
      "icon": Icons.settings,
      "title": "Logout",
      "color": Colors.white,
    },
    {
      "icon": Icons.home,
      "title": "Home",
      "color": Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    menuAnimationStatus = _GuillotineAnimationStatus.closed;

    ///
    /// Initialization of the animation controller
    ///
    animationControllerMenu = new AnimationController(
        duration: const Duration(
          milliseconds: 1000,
        ),
        vsync: this)
      ..addListener(() {});

    ///
    /// Initialization of the menu appearance animation
    ///
    animationMenu =
        new Tween(begin: -pi / 2.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: Curves.bounceOut,
      reverseCurve: Curves.bounceIn,
    ))
          ..addListener(() {
            setState(() {
              // force refresh
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              menuAnimationStatus = _GuillotineAnimationStatus.open;
            } else if (status == AnimationStatus.dismissed) {
              menuAnimationStatus = _GuillotineAnimationStatus.closed;
            } else {
              menuAnimationStatus = _GuillotineAnimationStatus.animating;
            }
          });

    ///
    /// Initialization of the menu title fade out/in animation
    ///
    animationTitleFadeInOut =
        new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: new Interval(
        0.0,
        0.5,
        curve: Curves.ease,
      ),
    ));
  }

  @override
  void dispose() {
    animationControllerMenu.dispose();
    super.dispose();
  }

  ///
  /// Play the animation in the direction that depends on the current menu status
  ///
  void _playAnimation() {
    try {
      if (menuAnimationStatus == _GuillotineAnimationStatus.animating) {
        // During the animation, do not do anything
      } else if (menuAnimationStatus == _GuillotineAnimationStatus.closed) {
        animationControllerMenu.forward().orCancel;
      } else {
        animationControllerMenu.reverse().orCancel;
      }
    } on TickerCanceled {
      // the animation go cancelled, probably because disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    double angle = animationMenu.value;

    return new Transform.rotate(
      angle: angle,
      origin: new Offset(24.0, 56.0),
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.black,
          child: new Stack(
            children: <Widget>[
              ///
              /// Menu title
              ///
              new Positioned(
                top: 32.0,
                left: 40.0,
                width: screenWidth,
                height: 24.0,
                child: new Transform.rotate(
                    alignment: Alignment.topLeft,
                    origin: Offset.zero,
                    angle: pi / 2.0,
                    child: new Center(
                      child: new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new Opacity(
                          opacity: animationTitleFadeInOut.value,
                          child: new Text('Carro',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              )),
                        ),
                      ),
                    )),
              ),

              ///
              /// Hamburger icon
              ///
              new Positioned(
                top: 32.0,
                left: 4.0,
                child: new IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: _playAnimation,
                ),
              ),

              ///
              /// Menu content
              ///
              new Padding(
                padding: const EdgeInsets.only(left: 64.0, top: 96.0),
                child: new Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 40),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              imageCar(widget.user.urlFoto),
                              Text(widget.user.nome),
                              Text(widget.user.email),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _menus.map((menuItem) {
                          return ListTile(
                            leading: new Icon(
                              menuItem["icon"],
                              color: menuItem["color"],
                            ),
                            title: RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                print('Button clicked ${menuItem['title']}');
                                if (menuItem['title'].toString() == "Logout") {
                                  User.clear();
                                  Navigator.pop(context);
                                  push(context, Login(), replace: true);
                                }
                              },
                              child: new Text(
                                menuItem["title"],
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Menu animation status
///
enum _GuillotineAnimationStatus { closed, open, animating }

imageCar(String url) {
  return CachedNetworkImage(
    imageUrl: url ??
        "http://www.livroandroid.com.br/livro/carros/esportivos/Maserati_Grancabrio_Sport.png",
    width: 60,
    placeholder: (context, url) => SizedBox(
      height: 90,
      width: 90,
      child: LoadingBouncingGrid.circle(
        size: 25,
        backgroundColor: Colors.greenAccent,
        duration: Duration(milliseconds: 900),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
