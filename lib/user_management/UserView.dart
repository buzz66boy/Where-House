import 'package:flutter/material.dart';
import '../../database/User.dart';
import 'UserController.dart';

class UserView extends StatefulWidget {
  final User user;
  final UserController userController;

  const UserView({
    super.key,
    required this.user,
    required  this.userController ,

  });

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  _UserViewState();
  late User currentUser;
  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _checkOutItemsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _uidController.text = widget.user.uid.toString();
    _nameController.text = widget.user.name;
    _checkOutItemsController.text = _checkOutItemsToString(widget.user.checkedOutItems);

  }
  String _checkOutItemsToString(List <dynamic> items){
    return items.join(',');
  }
  bool _showUserInfo =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Information'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: () {
                setState(() {
                  _showUserInfo = !_showUserInfo;
                });
              },
                child: const Text("View User"),
              ),
              ElevatedButton(onPressed: () => _editUserInfo(context),
                  child: const Text("Edit User")),
              if(_showUserInfo) displayUserInfo(),
            ],
          ),
        )

      // SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: <Widget>[
      //       ElevatedButton(
      //           onPressed: () => _editUserInfo(context),
      //           child: const Text("Edit User")
      //       ),
      //
      //       Padding(
      //         padding: const EdgeInsets.all(40.0),
      //         child: displayUserInfo(),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }




  /// Contract 1: Display User Information
  displayUserInfo() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Id: ${currentUser.uid}'),
        Text('Name: ${currentUser.name}'),
        Text('Checked Out items: ${currentUser.checkedOutItems}'),

      ],
    );
  }

  /// Private Responsibility: Edit User Information
  void _editUserInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _uidController,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: _checkOutItemsController, // Use check out items controller
                  decoration: InputDecoration(
                    labelText: 'Checked Out Items',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  widget.user.uid = int.tryParse(_uidController.text) ?? widget.user.uid; // Parse UID from text
                  widget.user.name = _nameController.text;
                  widget.user.checkedOutItems = _checkOutItemsController.text.split(',').map((item) => item.trim()).toList();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// void _editUserInfo(BuildContext context) {
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Edit User Information'),
//
//         actions: <Widget>[
//           ElevatedButton(
//             child: const Text('Save'),
//             onPressed: () {
//               setState(() {
//                 widget.user.uid = int.parse(_uidController.toString());
//                 widget.user.name = _nameController.text;
//                 widget.user.checkedOutItems = _checkOutItemsController.text.split(',').map((item) => item.trim()).toList();
//               });
//
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }



}
