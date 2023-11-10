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
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemView(
                  item: it,
                  itemController: this,
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
}
