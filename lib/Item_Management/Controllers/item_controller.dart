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

  void itemScanned(context, int barcode) {
    //get items matching barcode
    //show items in itemList
  }

  void showItem(context, Item it) async {
    List<Map<String, dynamic>>? quant =
        await itemManager.queryItemCount(itemUid: it.uid);

    Map<int, int> locQuant = {};
    if (quant != null) {
      //build locationQuant map
      //[{locationUid: 0, itemUid: 10, itemCount: 3}, {locationUid: 1, itemUid: 10, itemCount: 2}]
      // debugPrint('Test Message: ' + quant.toString());
      bool defLocHandled = false;
      for (int i = 0; i < quant.length; i++) {
        if (quant[i]['locationUid'] == it.locationUID) {
          locQuant[quant[i]['locationUid']] = quant[i]['itemCount'];
          defLocHandled = true;
        }
      }
      if (!defLocHandled) {
        locQuant[it.locationUID] = 0;
      }
      for (int i = 0; i < quant.length; i++) {
        if (!defLocHandled || quant[i]['locationUid'] != it.locationUID) {
          locQuant[quant[i]['locationUid']] = quant[i]['itemCount'];
        }
      }
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemView(
                  item: it,
                  itemController: this,
                  locationQuantities: locQuant,
                )));
  }

  void updateItemLocationQuantities(int uid, Map<int, int> locQuant) async {
    locQuant.forEach((key, value) async {
      await itemManager.updateItemCount(
          key, uid, value); //FIXME: return bool for success
    });
  }

  void showItemList(
      {required BuildContext context,
      List<Item>? itemList,
      List<int>? itemUIDList}) async {
    if (itemList == null && itemUIDList == null) {
      //get all items
      itemList = await itemManager.queryItems();
    } else if (itemList == null && itemUIDList != null) {
      //get item list from uid list
      itemList = [];
      Map<int, bool> uidHandled = {};
      for (var idx = 0; idx < itemUIDList.length; idx++) {
        uidHandled[itemUIDList[idx]] = false;
      }
      for (var idx = 0; idx < itemUIDList.length; idx++) {
        List<Item> tempQueryList =
            await itemManager.queryItems(itemUIDList[idx].toString());

        for (var n = 0; n < tempQueryList.length; n++) {
          int id = tempQueryList[n].uid;
          if (uidHandled.containsKey(id) && !(uidHandled[id] as bool)) {
            itemList.add(tempQueryList[n]);
            uidHandled[id] = true;
          }
        }
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

  Future<Item?> setItemInfo({
    required int uid,
    String? name,
    List<String>? barcodes,
    String? description,
    int? locationUID,
  }) async {
    // itemManager.editItem(uid: uid)
    debugPrint('Updating item');
    return await itemManager.editItem(
        uid: uid,
        name: name,
        barcodes: barcodes,
        description: description,
        locationUID: locationUID);

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
        useRootNavigator: false,
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
