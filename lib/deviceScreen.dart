import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Manual mode list App drawer
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Custom',
                  style: TextStyle(color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                ),
                leading: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.edit)),
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
                  style: TextStyle(color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                ),
                leading: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings)),
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
                title: Text(
                  'Devices',
                  style: TextStyle(color: Color.fromRGBO(247, 23, 53, 50), fontSize: 20),
                ),
                leading: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.devices)),
                onTap: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(builder: (BuildContext context) => DeviceScreen()),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Text('Second Screen!'),
    );
  }
}

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Text name = Text(
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
