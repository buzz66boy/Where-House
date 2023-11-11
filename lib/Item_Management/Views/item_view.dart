import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Item.dart';

class ItemView extends StatefulWidget {
  final Item item;
  final Map<int, int> locationQuantities;
  final ItemController itemController;

  const ItemView(
      {super.key,
      required this.item,
      required this.itemController,
      required this.locationQuantities});

  @override
  State<StatefulWidget> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  _ItemViewState();
  bool switchState = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _defLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name;
    _descriptionController.text = widget.item.description;
    _defLocationController.text = '${widget.item.locationUID}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _defLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold;
    scaffold = switchState
        ? Scaffold(
            appBar: AppBar(
              title: Text('Item Edit View: ${widget.item.name}'),
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 40),
                child: OverflowBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() => switchState = !switchState);
                      },
                    ),
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        setState(() {
                          switchState = !switchState;
                          widget.item.name = _nameController.text;
                          widget.item.description = _descriptionController.text;
                          widget.item.locationUID = int.parse(
                              _defLocationController
                                  .text); //FIXME: validate against known locations
                          widget.itemController.setItemInfo(
                              uid: widget.item.uid,
                              name: widget.item.name,
                              description: widget.item.description,
                              locationUID:
                                  widget.item.locationUID); //save changes
                          //FIXME: barcode handling in save
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: '),
                    TextField(controller: _nameController),
                    Text('Description: '),
                    TextField(
                      controller: _descriptionController,
                      // keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    Text('Location - Quantities'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.locationQuantities.length,
                      itemBuilder: (context, index) {
                        final location =
                            widget.locationQuantities.entries.toList()[index];

                        return ListTile(
                          title: Text(
                              'Location: ${location.key.toString()}'), //FIXME: get location name
                          subtitle:
                              Text('Quantity: ${location.value.toString()}'),
                        );
                      },
                    ),
                    Text('Barcodes'),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: widget.item.barcodes.length + 1,
                        itemBuilder: (context, index) {
                          if (index < widget.item.barcodes.length) {
                            final barcode = widget.item.barcodes[index];

                            return ListTile(
                              title: Text(barcode),
                              trailing: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    widget.item.barcodes.removeAt(index);
                                    widget.itemController.setItemInfo(
                                        uid: widget.item.uid,
                                        barcodes: widget.item.barcodes);
                                    setState(() {}); //FIXME: hack for refresh
                                  }),
                              // subtitle: barcode.buildSubtitle(context),
                            );
                          } else {
                            return ElevatedButton(
                                onPressed: () => {},
                                child: Text('Scan to Add New Barcode'));
                          }
                        },
                      ),
                    ),
                    Text('Default Location:'),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _defLocationController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                    ElevatedButton(
                      onPressed: () => {},
                      child: Text('DELETE ITEM'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Item View: ${widget.item.name}'),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('Name: ${item.name}'),
                      Text('Description: ${widget.item.description}'),
                      Text('Location - Quantities'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.locationQuantities.length + 1,
                        itemBuilder: (context, index) {
                          if (index < widget.locationQuantities.length) {
                            final location = widget.locationQuantities.entries
                                .toList()[index];

                            return ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.add_circle),
                                onPressed: () {
                                  if (widget.locationQuantities
                                          .containsKey(location.key) &&
                                      (widget.locationQuantities[
                                              location.key] !=
                                          null)) {
                                    widget.locationQuantities[location.key] =
                                        (widget.locationQuantities[location.key]
                                                as int) +
                                            1;
                                    widget.itemController
                                        .updateItemLocationQuantities(
                                            widget.item.uid,
                                            widget.locationQuantities);
                                    setState(
                                        () {}); //FIXME: hack for updating UI
                                  }
                                },
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  if (widget.locationQuantities
                                          .containsKey(location.key) &&
                                      (widget.locationQuantities[
                                              location.key] !=
                                          null) &&
                                      (widget.locationQuantities[location.key]
                                              as int >
                                          0)) {
                                    widget.locationQuantities[location.key] =
                                        (widget.locationQuantities[location.key]
                                                as int) -
                                            1;
                                    widget.itemController
                                        .updateItemLocationQuantities(
                                            widget.item.uid,
                                            widget.locationQuantities);
                                    setState(
                                        () {}); //FIXME: hack for updating UI
                                  }
                                },
                              ),
                              title: Text(
                                  'Location: ${location.key.toString()}'), //FIXME: get location name
                              subtitle: Text(
                                  'Quantity: ${location.value.toString()}'),
                            );
                          } else {
                            //last entry
                            return ElevatedButton(
                                onPressed: () =>
                                    {}, //FIXME: Add location controller call here
                                child: Text("Add to other Location"));
                          }
                        },
                      ),

                      Text('Barcodes'),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: widget.item.barcodes.length,
                          itemBuilder: (context, index) {
                            final barcode = widget.item.barcodes[index];

                            return ListTile(
                              title: Text(barcode),
                              // subtitle: barcode.buildSubtitle(context),
                            );
                          },
                        ),
                      ),

                      Text('Default Location: ${widget.item.locationUID}'),
                      ElevatedButton(
                        child: Text('Check Out'),
                        onPressed: () {
                          // lending controller here
                        },
                      ),
                      ElevatedButton(
                        child: Text('Return'),
                        onPressed: () {
                          // lending controller here
                        },
                      ),
                      ElevatedButton(
                        child: Text('Edit Item'),
                        onPressed: () {
                          setState(() => switchState = !switchState);
                        },
                      ),
                      // Switch.adaptive(
                      //     value: switchState,
                      //     onChanged: (value) =>
                      //         setState(() => switchState = value)),
                    ],
                  ),
                ),
              ),
            ),
          );
    return scaffold;
  }
}
