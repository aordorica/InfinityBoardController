// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'cardPage.dart';

void main() => runApp(InfinityControllerLED());

class InfinityControllerLED extends StatefulWidget {
  @override
  _InfinityControllerLEDState createState() => _InfinityControllerLEDState();
}

class _InfinityControllerLEDState extends State<InfinityControllerLED> {
  var connectedStatus = true;
  var bulbStatus = 'BulbOFF.png';
  var glow = true;
  var _brightness = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Infinity Skateboard',
      home: Scaffold(
        backgroundColor: Color.fromRGBO(37, 50, 68, 100),
        appBar: AppBar(
          centerTitle: true,
          title: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
            child: Image(
              image: AssetImage('images/infinityRED.png'),
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(247, 23, 53, 50),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Top ListView Header with User info
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: MyInfo(),
              ),

              //Auto App drawer list
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Default',
                    style: TextStyle(
                        color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                  ),
                  leading: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Image(
                      image: AssetImage('images/Auto.png'),
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    Navigator.pop(context);
                  },
                ),
              ),

              // Manual mode list App drawer
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Custom',
                    style: TextStyle(
                        color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        'images/manual.png',
                      ),
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    Navigator.pop(context);
                  },
                ),
              ),

              // Manual mode list App drawer
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(
                        color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        'images/Gear.png',
                      ),
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (connectedStatus == true) {
                  glow = true;
                  bulbStatus = 'images/BulbOn.png';
                  connectedStatus = false;
                } else {
                  glow = false;
                  bulbStatus = 'images/BulbOFF.png';
                  connectedStatus = true;
                }
              });
            },
            child: Icon(Icons.power_settings_new),
            backgroundColor: Color.fromRGBO(247, 23, 53, 50),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              // Top icon Showing Connected Status
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200, maxWidth: 400),
                    child: AvatarGlow(
                        curve: Curves.fastLinearToSlowEaseIn,
                        animate: glow,
                        child: Image(
                          image: AssetImage('$bulbStatus'),
                        ),
                        endRadius: 90.0,
                        glowColor: Colors.white),
                  ),
                ),
                alignment: Alignment.center,
              ),

              // Slider to controll brightness level
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Brightness',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromRGBO(247, 23, 53, 50)),
                    ),
                    Container(
                      width: 400.0,
                      child: Slider(
                        divisions: 20,
                        min: 0.0,
                        max: 100.0,
                        value: _brightness,
                        onChanged: (newValue) {
                          setState(() {
                            _brightness = newValue;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),

            // Display light brightness
              CustomCardBox(
                cardRadius: 50.0,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('$_brightness',
                  style: TextStyle(
                    color: Color.fromRGBO(247, 23, 53, 50),
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                  ),)
                ),
              ),
              CustomCardBox(
                cardRadius: 50.0,
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 10.0,
                        backgroundImage: AssetImage('images/Headshot.jpg'),
                      ),
                      Text(
                        'Custom Settings',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var name = Text(
      'Bob Ross',
      style: TextStyle(color: Colors.black),
    );
    var email = Text(
      'bobRoss@infinityBoards.com',
      style: TextStyle(color: Colors.black),
    );

    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
            color: Color.fromRGBO(247, 23, 53, 80),
            borderRadius: BorderRadius.circular(10),
            backgroundBlendMode: BlendMode.darken),
        accountEmail: email,
        accountName: name,
        currentAccountPicture: Align(
          child: CircleAvatar(
            maxRadius: 40.0,
            backgroundImage: AssetImage('images/Headshot.jpg'),
          ),
        ));
  }
}
