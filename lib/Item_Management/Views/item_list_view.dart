import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Item.dart';

class ItemListView extends StatefulWidget {
  final List<Item> initialItemList;
  final bool confirmSelect;
  final ItemController itemController;
  final String barcodeScanned;
  const ItemListView(
      {super.key,
      required this.initialItemList,
      required this.confirmSelect,
      required this.itemController,
      this.barcodeScanned = ''});

  @override
  State<StatefulWidget> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  late List<Item> itemList;
  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _queryController.text = widget.barcodeScanned;

    itemList = widget.initialItemList;
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
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 40),
            child: OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Add New Item'),
                  onPressed: () async {
                    await widget.itemController
                        .createNewItem(context, widget.barcodeScanned);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        body: Center(
            child: Flex(direction: Axis.vertical, children: [
          TextField(
              controller: _queryController,
              onChanged: (value) async {
                itemList = await widget.itemController
                    .getItems(name: _queryController.text, looseMatching: true);
                setState(() {});
                debugPrint("Item Search done");
              },
              decoration: InputDecoration(hintText: 'Item Search')),
          Expanded(
            child:
                // SingleChildScrollView(
                ListView.builder(
              // scrollDirection: Axis.vertical,
              itemCount: itemList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => _selectItem(
                        context,
                        index,
                        itemList[index]
                            .name), //FIXME: rebuild when refreshing screen
                    child: ListTile(
                      title: Text(itemList[index].name),
                      subtitle: Text(itemList[index].description),
                    ));
              },
            ),
            // ),
          )
        ])));

    return scaffold;
  }

  void _selectItem(context, index, name) async {
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
                    Navigator.of(context).pop(itemList[index]);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          });
      debugPrint('${index}');
    } else {
      // Navigator.of(context).pop(widget.itemList[index]);
      if (widget.barcodeScanned.isNotEmpty &&
          !itemList[index].barcodes.contains(widget.barcodeScanned)) {
        Item? updatedItem = await widget.itemController.addBarcodeToItem(
            context, itemList[index].uid, widget.barcodeScanned);
        if (updatedItem != null) {
          itemList[index] = updatedItem;
          Navigator.of(context).pop();
          widget.itemController.showItem(context, itemList[index]);
        }
      } else {
        if (widget.barcodeScanned.isNotEmpty) {
          Navigator.of(context).pop();
        }
        widget.itemController.showItem(context, itemList[index]);
      }
    }
  }
}
