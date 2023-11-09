import 'package:flutter/material.dart';
import 'package:wherehouse/database/Item.dart';

class ItemListView extends StatefulWidget {
  final List<Item> itemList;
  final bool confirmSelect;

  const ItemListView(
      {super.key, required this.itemList, required this.confirmSelect});

  @override
  State<StatefulWidget> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  _ItemListViewState();
  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold;
    scaffold = Scaffold(
        appBar: AppBar(
          title: Text('Item List View'),
        ),
        body: Center(
            child: Flex(direction: Axis.vertical, children: [
          TextField(
              controller: _queryController,
              decoration: InputDecoration(hintText: 'Item Search')),
          Expanded(
            child:
                // SingleChildScrollView(
                ListView.builder(
              // scrollDirection: Axis.vertical,
              itemCount: widget.itemList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => _selectItem(
                        context, index, widget.itemList[index].name),
                    child: ListTile(
                      title: Text(widget.itemList[index].name),
                      subtitle: Text(widget.itemList[index].description),
                    ));
              },
            ),
            // ),
          )
        ])));

    return scaffold;
  }

  void _selectItem(context, index, name) {
    if (widget.confirmSelect) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text('Confirm Selection'),
              content: Text('Item \'${name}\''),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          });
      debugPrint('${index}');
    } else {}
  }
}

//  @override
//   Widget build(BuildContext context) {
//     Scaffold scaffold;
//     scaffold = Scaffold(
//         appBar: AppBar(
//           title: Text('Item List View'),
//         ),
//         body: Center(
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           TextField(
//               controller: _queryController,
//               decoration: InputDecoration(hintText: 'Item Search')),
//           // SingleChildScrollView(
//           ListView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: widget.itemList.length,
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(widget.itemList[index].name),
//                 subtitle: Text(widget.itemList[index].description),
//               );
//             },
//           ),
//           // ),
//         ])));

//     return scaffold;
//   }