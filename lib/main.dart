// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:infinity_board/bt_device.dart';
import 'package:infinity_board/findDevices.dart';

//import 'dart:async';
import 'dart:convert' show utf8;
import 'cardPage.dart';
import 'colorSelector.dart';

void main() => runApp(InfinityControllerLED());

class InfinityControllerLED extends StatefulWidget {
  @override
  _InfinityControllerLEDState createState() => _InfinityControllerLEDState();
}

class _InfinityControllerLEDState extends State<InfinityControllerLED> {
  var bulb = AssetImage('images/BulbON.png');
  bool connectedStatus = true;
  bool glow = true;
  bool ledState = true;
  int _brightness = 0;
  Color onButtonState = Colors.lightBlue[100];

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  String connectedDevice = 'No Device Connected';

  final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
  final String TARGET_DEVICE_NAME = "InfinityBoard";
  String connectionText = '';

discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData("Hi there, HM-10!!");
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });
          }
        });
      }
    });
  }

  writeData(String data) {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: 'Infinity Skateboard',
        home: Builder(
            builder: (BuildContext context) => Scaffold(
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
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
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
                        // Custom mode list App drawer
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Custom',
                              style: TextStyle(
                                  color: Color.fromRGBO(247, 23, 53, 50),
                                  fontSize: 20),
                            ),
                            leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.edit)),
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
                                  color: Color.fromRGBO(247, 23, 53, 50),
                                  fontSize: 20),
                            ),
                            leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.settings)),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            enabled: true,
                            title: Text(
                              'Devices:\n $connectedDevice',
                              style: TextStyle(
                                  color: Color.fromRGBO(247, 23, 53, 50),
                                  fontSize: 20),
                            ),
                            leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.devices)),
                            onTap: () {
                              showDialog<AlertDialog>(
                                context: context,
                                builder: (BuildContext context) {
                                  // return alert dialog object
                                  return AlertDialog(
                                    title: Text('Connected Devices'),
                                    content: Container(child: FlutterBlueApp(
                                      onConnect: (BluetoothDevice device) {
                                        targetDevice = device;
                                        setState(() {
                                          connectedDevice = 'Now Connected';
                                        });
                                      },
                                    )),
                                  );
                                },
                              );
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
                            bulb = AssetImage('images/BulbON.png');
                            connectedStatus = false;
                            onButtonState = Color.fromRGBO(247, 23, 53, 50);
                          } else {
                            writeData('o');
                            glow = false;
                            bulb = AssetImage('images/BulbOFF.png');
                            connectedStatus = true;
                            onButtonState = Colors.green;
                          }
                        });
                      },
                      child: Icon(Icons.power_settings_new),
                      backgroundColor: onButtonState,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          // Top icon Showing Connected Status
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 200, maxWidth: 400),
                                child: AvatarGlow(
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    animate: glow,
                                    child: Image(
                                      image: bulb,
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
                                    inactiveColor:
                                        Color.fromRGBO(154, 184, 4, 100),
                                    activeColor:
                                        Color.fromRGBO(252, 0, 34, 100),
                                    min: 0.0,
                                    max: 100.0,
                                    value: _brightness.toDouble(),
                                    onChanged: (double newValue) {
                                      setState(() {
                                        _brightness = newValue.round();
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
                                child: Text(
                                  '$_brightness',
                                  style: TextStyle(
                                      color: Color.fromRGBO(247, 23, 53, 50),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                )),
                          ),
                          CustomCardBox(
                            cardRadius: 50.0,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.red,
                                            onPressed: () {
                                              //Change Color to RED
                                              print('\n\n Pressing RED button...... \n\n');
                                              writeData('r');
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Red',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.green,
                                            onPressed: () {
                                              //Change Color to Green
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Green',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.blue,
                                            onPressed: () {
                                              //Change Color to Blue
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Blue',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.yellow,
                                            onPressed: () {
                                              //Change Color to Yellow
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Yellow',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.purple,
                                            onPressed: () {
                                              //Change Color to Purple
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Purple',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        ColorSelector(),
                                        Text(
                                          'Custom',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }
}

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Text(
      'Bob Ross',
      style: TextStyle(color: Colors.black),
    );
    final Text email = Text(
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
