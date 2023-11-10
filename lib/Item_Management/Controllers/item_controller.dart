import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Views/item_list_view.dart';
import 'package:wherehouse/Item_Management/Views/item_view.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/database/ItemManager.dart';

class ItemController {
  final ItemManager itemManager;
  const ItemController({required this.itemManager});

  Future<Item?> getItemSelection(context, List<Item> ilist) async {
    final itemSelected = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemListView(
                itemList: ilist, confirmSelect: true, itemController: this)));
    if (!context.mounted) return null;
    return itemSelected;
  }

  void showItem(context, Item it) async {
    List<Map<String, dynamic>>? quant =
        await itemManager.queryItemCount(itemUid: it.uid);
    if (quant != null) {
      //build locationQuant map

      debugPrint('Test Message: ' + quant.toString());
      Map<int, int> locQuant = Map();
      for (int i = 0; i < quant.length; i++) {}
    }
    int q = 0;
    // if (quant != null) {
    //   q = quant as int;
    // } else {
    //   q = 0;
    // }
    Map<int, int> locQ = {0: q, 1: 2};
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemView(
                  item: it,
                  itemController: this,
                  locationQuantities: locQ,
                )));
  }

  void showItemList(
      context, List<Item>? itemList, List<String>? itemUIDList) async {
    if (itemList == null && itemUIDList == null) {
      //get all items
      itemList = [];
    } else if (itemList == null && itemUIDList != null) {
      //get item list from uid list
      itemList = [];
      for (var idx = 0; idx < itemUIDList.length; idx++) {
        // Item? item = await Item.getItem(itemUIDList[idx])

        // itemList.add(item);
      }
    }
    final itemSelected = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemListView(
                  itemList: itemList as List<Item>,
                  confirmSelect: false,
                  itemController: this,
                )));
    if (itemSelected != null) {
      showItem(context, itemSelected);
    }
  }

  Item setItemInfo(Item item) {
    // itemManager.editItem(uid: uid)
    item.setItem();
    return item;
    // Item();
  }

  List<Item> getItems(int? uid, int? barcode, String? name, String? location,
      String? user, String? description) {
    List<Item> itemList = [];
    if (uid != null) {
    } else if (barcode != null) {
    } else if (name != null) {
    } else if (location != null) {
      //handle searching locations
    } else if (user != null) {
      //handle searching users with item
    } else if (description != null) {}
    return itemList;
  }

  Future<Item?> createNewItem(context, int barcode) async {
    //prompt for item name
    String? text = await _getItemName(context);

    // _getItemName(context, nameController)
    //     .then((value) => {debugPrint(nameController.text)});
    if (text != null) {
      debugPrint(text);
    }
    //create item via ItemManager

    //go to item view in edit mode
    // return null;
  }

  Future<String?> _getItemName(context) async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('New Item Name'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Item Name'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(nameController.text);
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }
}
