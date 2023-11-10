import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wherehouse/database/Item.dart';

class ItemView extends StatefulWidget {
  final Item item;

  const ItemView({super.key, required this.item});

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
    _nameController.text = '${widget.item.name}';
    _descriptionController.text = '${widget.item.description}';
    _defLocationController.text = '${widget.item.defaultLocation}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold;
    scaffold = switchState
        ? Scaffold(
            appBar: AppBar(
              title: Text('Item Edit View: ${widget.item.name}'),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: '),
                    TextField(controller: _nameController),
                    Text('Description: '),
                    TextField(controller: _descriptionController),
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
                    Text('Location - Quantities'),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: widget.item.locationQuantities.length,
                        itemBuilder: (context, index) {
                          final location = widget
                              .item.locationQuantities.entries
                              .toList()[index];

                          return ListTile(
                            title: Text(
                                'Location: ${location.key.toString()}'), //FIXME: get location name
                            subtitle:
                                Text('Quantity: ${location.value.toString()}'),
                          );
                        },
                      ),
                    ),
                    Text('Default Location: ${widget.item.defaultLocation}'),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _defLocationController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                    ButtonBar(
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
                              widget.item.description =
                                  _descriptionController.text;
                              widget.item.defaultLocation = int.parse(
                                  _defLocationController
                                      .text); //FIXME: validate against known locations
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Item View: ${widget.item.name}'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text('Name: ${item.name}'),
                  Text('Description: ${widget.item.description}'),
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
                  Text('Location - Quantities'),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: widget.item.locationQuantities.length,
                      itemBuilder: (context, index) {
                        final location = widget.item.locationQuantities.entries
                            .toList()[index];

                        return ListTile(
                          title: Text(
                              'Location: ${location.key.toString()}'), //FIXME: get location name
                          subtitle:
                              Text('Quantity: ${location.value.toString()}'),
                        );
                      },
                    ),
                  ),
                  Text('Default Location: ${widget.item.defaultLocation}'),
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
          );
    return scaffold;
  }
}
