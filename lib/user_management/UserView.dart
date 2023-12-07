import 'package:flutter/material.dart';
import 'package:wherehouse/database/UserManager.dart';
import '../../database/User.dart';
import 'UserController.dart';

class UserView extends StatefulWidget {
  final User user;
  final UserController userController;

  const UserView({
    super.key,
    required this.user,
    required this.userController,
  });

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  _UserViewState();
  late User currentUser;
  late UserManager userManager;
  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _checkOutItemsController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    userManager = UserManager();
    _uidController.text = widget.user.uid.toString();
    _nameController.text = widget.user.name;
    _checkOutItemsController.text =
        _checkOutItemsToString(widget.user.checkedOutItems);
    _passwordController.text = widget.user.password;
  }

  String _checkOutItemsToString(List<dynamic> items) {
    return items.join(',');
  }

  bool _showUserInfo = false;

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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showUserInfo = !_showUserInfo;
                });
              },
              child: const Text("View User"),
            ),
            ElevatedButton(
              onPressed: () => _editUserInfo(context),
              child: const Text("Edit User"),
            ),
            if (_showUserInfo) displayUserInfo(),
          ],
        ),
      ),
    );
  }

  displayUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Id: ${currentUser.uid}'),
        Text('Name: ${currentUser.name}'),
        // Text('Password: ${currentUser.password}'),
        Text('Checked Out items: ${currentUser.checkedOutItems}'),
      ],
    );
  }

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
                  controller: _passwordController, // Add this line
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _checkOutItemsController,
                  decoration: const InputDecoration(
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
                  widget.user.uid =
                      int.tryParse(_uidController.text) ?? widget.user.uid;
                  widget.user.name = _nameController.text;
                  widget.user.password =
                      _passwordController.text; // Update password
                  widget.user.checkedOutItems = _checkOutItemsController.text
                      .split(',')
                      .map((item) => item.trim())
                      .toList();
                });
                userManager.saveUser(widget.user);
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
