import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/Item_Management/Controllers/scanner_controller.dart';
import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/database/ItemManager.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'package:wherehouse/database/User.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/login_screen.dart';
import 'package:wherehouse/user_management/UserController.dart';
import 'package:wherehouse/user_management/UserListView.dart';
import 'package:wherehouse/database/TransactionView.dart'; //added transaction view class

class MyApp extends StatelessWidget {
  late ItemManager itemManager;
  late ItemController itemController;
  late ScannerController scannerController;
  final User user;

  /// Added User

  MyApp({super.key, required this.user}) {
    // ItemManager itemManager = ItemManager();
    // ItemController itemController = ItemController(itemManager: itemManager);
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where?House',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: ItemView(item: item),
      // home: ItemListView(
      //   itemList: [item, item, item, item, item, item],
      //   confirmSelect: true,
      // )

      home: MyHomePage(title: 'Where?House Main Menu', user: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // User added
  final User user;
  late UserManager userManager = UserManager();
  late UserController userController = UserController(userManager);

  late ItemManager itemManager;
  late ItemController itemController;
  late ScannerController scannerController;
  late LocationManager locationManager;
  late LocationController locationController;
  late Item item = Item(
      uid: 10,
      name: 'Copier Toner',
      description:
          'Tones Copiers but sometimes this is not enough and it needs to tone other things like koalas and crazy kangaroos in the outback',
      barcodes: ['1234', '4321'],
      //locationQuantities: <int, int>{1: 2, 3: 4},
      locationUID: 1);
  MyHomePage({super.key, required this.title, required this.user}) {
    // userManager.initializeDatabase().then((value) async {
    //   User user = User(
    //       uid: 1, name: "bob", password: "password", checkedOutItems: [1, 3]);
    //   // bool tempUser = await userManager.addUser(user.uid,user.name,user.password,user.checkedOutItems);
    //   // bool tempUser = await userManager.addUser(
    //   //     user.name, user.password, user.checkedOutItems);
    //   // if (tempUser != null) {
    //   //   user = tempUser as User;
    //   // }
    //   userManager.queryUsers('bob').then((value) => print(value.toString()));
    // });
    itemManager = ItemManager();
    itemManager.initializeDatabase().then((value) async {
      Item? tempitem = await itemManager.addItem(
          item.name, item.description, item.barcodes, item.locationUID);
      if (tempitem != null) {
        item = tempitem as Item;
        // itemManager.updateItemCount(0, item.uid, 3);
        itemManager.updateItemCount(1, item.uid, 2);
        // itemManager.updateItemCount(4, item.uid, 4);
      }
      // await itemManager.editItem(
      //     uid: item.uid,
      //     name: item.name,
      //     description: item.description,
      //     barcodes: item.barcodes,
      //     locationUID: item.locationUID);

      itemManager.queryItems('koala').then((value) => print(value.toString()));
    });
    locationManager = LocationManager();
    locationController = LocationController(locationManager: locationManager);
    itemController = ItemControllerHolder.instantiateItemController(
        locationController: locationController,
        itemManager: itemManager,
        user: user);
    scannerController = ScannerController(itemController: itemController);
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateToUserList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListView(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(title: 'Settings'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          _buildUserDropdown(), // Call the method to build the dropdown
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  final result = await BarcodeScanner.scan();
                  debugPrint(result.rawContent.toString());
                  widget.itemController
                      .itemScanned(context, result.rawContent.toString());
                },
                child: Text("Scan")),
            ElevatedButton(
                onPressed: () async {
                  widget.itemController.showItemList(context: context);
                },
                child: Text("Search Items")),
            ElevatedButton(
                onPressed: () {
                  widget.locationController.showLocationList(context: context);
                },
                child: Text("Manage Locations")),
            ElevatedButton(
                onPressed: () async {
                  widget.userController
                      .setUserViewActive(context, widget.user.uid);
                  print("made it here to users");
                },
                child: Text("Manage User")),
            ElevatedButton(
                onPressed: _navigateToUserList, child: Text("Manage Users")),
            /*Added transaction view button*/
            ElevatedButton(
                onPressed: () {
                  // Navigate to transaction history page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionView(),
                      ));
                },
                child: Text("Transaction History")),
            /******/
            ElevatedButton(
                onPressed: _navigateToSettings, child: const Text("Settings")),
            ElevatedButton(
                onPressed: () async {
                  widget.itemController.itemScanned(context, '5555');

                  // widget.itemController.getItemSelection(
                  //     context, [widget.item, widget.item]).then((item) {
                  //   if (item != null) {
                  //     debugPrint(item.name + " selected");
                  //   }
                  // });
                },
                child: Text("Testing Button")),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'logout') {
            // Handle logout action here
            // You may want to navigate to the login screen or perform any other logout logic
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BackgroundVideo()));
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
        ],
        icon: CircleAvatar(
          // Display the user's initials or avatar, adjust as needed
          child: Text(widget.user.name[0]),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  String _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General Settings'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                value: Text(_selectedLanguage),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select Language'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 'English');
                            },
                            child: const Text('English'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 'Spanish');
                            },
                            child: const Text('Spanish'),
                          ),
                        ],
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    }
                  });
                },
              ),
              SettingsTile.switchTile(
                initialValue: true,
                title: const Text('Use System Theme'),
                leading: const Icon(Icons.phone_android),
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SettingsTile(
                title: const Text('Wi-Fi'),
                leading: const Icon(Icons.wifi),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: const Text('Delete Account'),
                leading: const Icon(Icons.delete_forever),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account? This cannot be undone.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Security Settings'),
            tiles: [
              SettingsTile(
                title: const Text('Security'),
                value: const Text('Fingerprint'),
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                initialValue: true,
                title: const Text('Use fingerprint'),
                leading: const Icon(Icons.fingerprint),
                onToggle: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
