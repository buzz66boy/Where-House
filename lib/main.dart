import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/database/ItemManager.dart';

void main() {
  ItemManager itemManager = ItemManager();
  ItemController itemController = ItemController(itemManager: itemManager);
  runApp(MyApp(
    itemManager: itemManager,
    itemController: itemController,
  ));
}

class MyApp extends StatelessWidget {
  final ItemManager itemManager;
  final ItemController itemController;
  MyApp({
    super.key,
    required this.itemManager,
    required this.itemController,
  });
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

      home: MyHomePage(
        title: 'Where?House Main Menu',
        itemController: itemController,
        itemManager: itemManager,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ItemManager itemManager;
  final ItemController itemController;
  MyHomePage(
      {super.key,
      required this.title,
      required this.itemManager,
      required this.itemController});

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
  final Item item = Item(
      uid: 10,
      name: 'Copier Toner',
      description:
          'Tones Copiers but sometimes this is not enough and it needs to tone other things like koalas and crazy kangaroos in the outback',
      barcodes: ['1234', '4321'],
      locationQuantities: <int, int>{1: 2, 3: 4},
      defaultLocation: 0);
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
                onPressed: () {
                  widget.itemController.showItem(context, item);
                },
                child: Text("Scan")),
            ElevatedButton(
                onPressed: () {
                  widget.itemController
                      .showItemList(context, [item, item], null);
                },
                child: Text("Search Items")),
            ElevatedButton(onPressed: () {}, child: Text("Manage Locations")),
            ElevatedButton(onPressed: () {}, child: Text("Manage Users")),
            ElevatedButton(
                onPressed: () {}, child: Text("Transaction History")),
            ElevatedButton(onPressed: () {}, child: Text("Settings")),
            ElevatedButton(
                onPressed: () {
                  widget.itemController
                      .getItemSelection(context, [item, item]).then((item) {
                    if (item != null) {
                      debugPrint(item.name + " selected");
                    }
                  });
                },
                child: Text("Testing Button")),
          ],
        ),
      ),
    );
  }
}
