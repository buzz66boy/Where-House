import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Controllers/lending_controller.dart';
import 'package:wherehouse/Item_Management/Views/item_list_view.dart';
import 'package:wherehouse/Item_Management/Views/item_view.dart';
import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/database/ItemManager.dart';
import 'package:wherehouse/database/Location.dart';

class ItemControllerHolder {
  static late ItemController itemController;

  static ItemController instantiateItemController(
      {required locationController, required itemManager}) {
    itemController = ItemController(
        locationController: locationController, itemManager: itemManager);
    return itemController;
  }

  static ItemController getInstance() {
    return itemController;
  }
}

class ItemController {
  final ItemManager itemManager;
  final LocationController locationController;
  late LendingController lendingController;

  ItemController(
      {required this.locationController, required this.itemManager}) {
    lendingController = LendingController(itemController: this);
  }

  Future<Item?> getItemSelection(context, List<Item> ilist) async {
    final itemSelected = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemListView(
                  initialItemList: ilist,
                  confirmSelect: true,
                  itemController: this,
                  barcodeScanned: '',
                )));
    if (!context.mounted) return null;
    return itemSelected;
  }

  void itemScanned(context, String barcode) async {
    //get items matching barcode
    List<Item> itemList = await getItems(barcode: barcode);
    showItemList(
      context: context,
      itemList: itemList,
      barcodeScanned: barcode,
    );
    //show items in itemList
  }

  void checkoutItem(context, int itemUid) async {
    List<Item?> qRes = await getItems(uid: itemUid, looseMatching: false);
    if (qRes != null && qRes.length > 0) {
      lendingController.checkOut(context, qRes[0]!);
    } else {
      throw Exception(
          "Item meant to be checked in not found via query: ${itemUid}");
    }
  }

  void checkinItem(context, int itemUid) async {
    List<Item?> qRes = await getItems(uid: itemUid, looseMatching: false);
    if (qRes != null && qRes.length > 0) {
      lendingController.checkIn(context, qRes[0]!);
    } else {
      throw Exception(
          "Item meant to be checked in not found via query: ${itemUid}");
    }
  }

  void showItem(context, Item it) async {
    Map<int, int> locQuant = await getItemLocationQuantities(item: it);

    List<int> locIds = locQuant.keys.toList();
    List<String> locNames = await getLocationNames(locIds);

    Map<int, String> locNameMap = {};

    for (int i = 0; i < locIds.length; i++) {
      locNameMap[locIds[i]] = locNames[i];
    }
    debugPrint(locNames.toString());
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemView(
                  item: it,
                  itemController: this,
                  locationQuantities: locQuant,
                  locationNames: locNameMap,
                )));
  }

  Future<List<String>> getLocationNames(List<int> uidList) {
    return locationController.getLocationNames(uidList);
  }

  Future<String> getLocationName(int uid) {
    return locationController.getLocationName(uid);
  }

  Future<Map<int, int>> getItemLocationQuantities(
      {int? uid, Item? item}) async {
    if (item == null && uid != null) {
      item = (await getItems(
          uid: uid, looseMatching: false))[0]; //FIXME: check for empty list
    }
    Map<int, int> locQuant = {};
    if (item != null) {
      List<Map<String, dynamic>>? quant =
          await itemManager.queryItemCount(itemUid: item.uid);

      if (quant != null) {
        //build locationQuant map
        //[{locationUid: 0, itemUid: 10, itemCount: 3}, {locationUid: 1, itemUid: 10, itemCount: 2}]
        // debugPrint('Test Message: ' + quant.toString());
        bool defLocHandled = false;
        if (item.locationUID >= 0) {
          for (int i = 0; i < quant.length; i++) {
            if (quant[i]['locationUid'] == item.locationUID) {
              locQuant[quant[i]['locationUid']] = quant[i]['itemCount'];
              defLocHandled = true;
            }
          }
          if (!defLocHandled) {
            locQuant[item.locationUID] = 0;
          }
        }
        for (int i = 0; i < quant.length; i++) {
          if (!defLocHandled || quant[i]['locationUid'] != item.locationUID) {
            locQuant[quant[i]['locationUid']] = quant[i]['itemCount'];
          }
        }
      }
    }
    return locQuant;
  }

  Future<Map<int, int>> getLocationItems(int locUid) async {
    Map<int, int> itemQuant = {};
    List<Map<String, dynamic>>? quant =
        await itemManager.queryItemCount(locationUid: locUid);

    if (quant != null) {
      //build itemQuant map for location
      //[{itemUid: 0, itemCount: 3}, {itemUid: 1, itemCount: 2}]
      for (int i = 0; i < quant.length; i++) {
        itemQuant[quant[i]['itemUid']] = quant[i]['itemCount'];
      }
    }

    return itemQuant;
  }

  void updateItemLocationQuantities(
      {int? itemUid, int? locUid, required Map<int, int> uidQuantMap}) async {
    if (itemUid != null) {
      uidQuantMap.forEach((key, value) async {
        await itemManager.updateItemCount(
            key, itemUid, value); //FIXME: return bool for success
      });
    } else if (locUid != null) {
      uidQuantMap.forEach((key, value) async {
        await itemManager.updateItemCount(
            locUid, key, value); //FIXME: return bool for success
      });
    }
  }

  void showItemList(
      {required BuildContext context,
      List<Item>? itemList,
      List<int>? itemUIDList,
      String barcodeScanned = ''}) async {
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
                  initialItemList: itemList as List<Item>,
                  confirmSelect: false,
                  itemController: this,
                  barcodeScanned: barcodeScanned,
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
    Map<int, int>? locationQuantityMap,
    int? locationUID,
    bool delete = false,
  }) async {
    // itemManager.editItem(uid: uid)
    // debugPrint('Updating item');
    if (!delete) {
      Item? retItem;
      if (name != null ||
          barcodes != null ||
          description != null ||
          locationUID != null) {
        retItem = await itemManager.editItem(
            uid: uid,
            name: name,
            barcodes: barcodes,
            description: description,
            locationUID: locationUID);
      } else {
        retItem = (await getItems(uid: uid))[0]; //FIXME: should check if exists
      }
      if (locationQuantityMap != null) {
        updateItemLocationQuantities(
          itemUid: uid,
          uidQuantMap: locationQuantityMap,
        );
        // updateItemLocationQuantities(itemUid: itemuid, ui locationQuantityMap);
      }
      return retItem;
      // Item();
    } else {
      bool delSuccess = await itemManager.removeItem(uid);
      return null;
    }
  }

  Future<List<Item>> getItems(
      {int? uid,
      String? barcode,
      String? name,
      String? location,
      String? user,
      String? description,
      bool looseMatching = false}) async {
    List<Item> itemList = [];
    if (uid != null) {
      List<Item> queryRes = await itemManager.queryItems(uid.toString());

      for (var i = 0; i < queryRes.length; i++) {
        if (!looseMatching && queryRes[i].uid == uid) {
          itemList.add(queryRes[i]);
          break;
        } else if (looseMatching &&
            queryRes[i].uid.toString().contains(uid.toString())) {
          itemList.add(queryRes[i]);
        }
      }
    } else if (barcode != null) {
      List<Item> queryRes = await itemManager.queryItems(barcode.toString());

      for (var i = 0; i < queryRes.length; i++) {
        if (queryRes[i].barcodes.contains(barcode)) {
          itemList.add(queryRes[i]);
        } //FIXME: implement loose matching
      }
    } else if (name != null) {
      List<Item> queryRes = await itemManager.queryItems(name);

      for (var i = 0; i < queryRes.length; i++) {
        if (!looseMatching &&
            queryRes[i].name.toLowerCase() == name.toLowerCase()) {
          itemList.add(queryRes[i]);
        } else if (looseMatching &&
            queryRes[i].name.toLowerCase().contains(name.toLowerCase())) {
          itemList.add(queryRes[i]);
        }
      }
    } else if (location != null) {
      //FIXME: handle searching locations
    } else if (user != null) {
      //FIXME: handle searching users with item
    } else if (description != null) {
      List<Item> queryRes = await itemManager.queryItems(description);

      for (var i = 0; i < queryRes.length; i++) {
        if (!looseMatching &&
            queryRes[i].description.toLowerCase() ==
                description.toLowerCase()) {
          itemList.add(queryRes[i]);
        } else if (looseMatching &&
            queryRes[i]
                .description
                .toLowerCase()
                .contains(description.toLowerCase())) {
          itemList.add(queryRes[i]);
        }
      }
    }
    return itemList;
  }

  Future<Item?> addBarcodeToItem(context, int itemUid, String barcode) async {
    Item item = (await getItems(uid: itemUid))[0];
    //Confirm they want to add barcode to the item
    bool? confirm = await _confirmAddBarcodeDialog(context, item.name, barcode);

    if (confirm != null && confirm) {
      item.barcodes.add(barcode);
      setItemInfo(uid: itemUid, barcodes: item.barcodes);
      return item;
    }
    return null;
  }

  Future<Item?> createNewItem(context, String barcode) async {
    //prompt for item name
    String? text = await _getItemName(context);

    // _getItemName(context, nameController)
    //     .then((value) => {debugPrint(nameController.text)});
    if (text != null) {
      // debugPrint(text);
      //get default location selection
      int defaultLocUid = -1;

      Location? defLocSelected = await _getDefaultLocationPopup(context);
      if (defLocSelected != null) {
        defaultLocUid = defLocSelected.uid;
      }
      //create item via ItemManager
      List<String> barcodes = [];
      if (barcode.isNotEmpty) {
        // debugPrint('Barcode found ' + barcode);
        barcodes.add(barcode);
      }
      Item? newItem = await itemManager.addItem(text, '', barcodes,
          defaultLocUid); //FIXME: avoid hardcoding 0 as default location
      //go to item view in edit mode
      if (newItem != null) {
        showItem(context, newItem);
      }
      return newItem;
    }
    return null;
  }

  Future<bool?> _confirmAddBarcodeDialog(
      context, String itemName, String newBarcode) async {
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Add Barcode to Item?'),
            content: Text("Name: $itemName \nNew Barcode: $newBarcode"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text('Confirm'),
              ),
            ],
          );
        });
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

  Future<Location?> _getDefaultLocationPopup(context) {
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Item Default Location'),
            content: Text('Would you like to set a default location?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pop(await getLocationSelection(context));
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  Future<Location?> getLocationSelection(BuildContext context) {
    return locationController.getLocationSelection(context: context);
  }
}
