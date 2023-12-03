import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wherehouse/user_management/UserController.dart';
import 'package:wherehouse/database/User.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'UserView.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late final UserManager _userManager;
  late final UserController _userController;

  List<User> _users = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _userManager = UserManager();
    _userController = UserController(_userManager);
    _displayUsers();
  }

  void _displayUsers() async {
    List<User> usersList = await _userController.getUsers();
    setState(() {
      _users = usersList;
    });
  }

  void _selectUser(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UserView(user: user, userController: _userController)),
    );
  }

  void _selectAddUser() {
    final BuildContext scaffoldContext = context;
    addUserDialog(scaffoldContext);
  }

  // void _submitUserQuery(String query) {
  //
  //   setState(() {
  //     _query = query;
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text('User List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text("Users"),
            ElevatedButton(
                onPressed: () => _selectAddUser(), child: Text("Add User"))
          ],
        ),
      ),
    );
  }

  Future<void> addUserDialog(BuildContext scaffoldContext) async {
    String userName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController userNameController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: userNameController,
                  decoration:
                      const InputDecoration(hintText: "Enter user's name"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                userName = userNameController.text;
                if (userName.isNotEmpty) {
                  String jsonCheckedOutItems = '["item1", "item2", "item3"]';
                  List<dynamic> checkedOutItems =
                      jsonDecode(jsonCheckedOutItems);
                  User newUser =
                      User(name: userName, checkedOutItems: checkedOutItems);
                  bool success = await _userController.addUser(newUser);
                  Navigator.of(context).pop();
                  if (success) {
                    Builder(
                      builder: (context) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('User "$userName" add successfully')),
                        );
                        return Container();
                      },
                    );

                    _displayUsers(); // Refresh the user list
                  } else {
                    Builder(
                      builder: (context) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to add user "$userName"')),
                        );
                        return Container();
                      },
                    );
                  }
                } else {
                  Builder(
                    builder: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('User name cannot be empty')),
                      );
                      return Container();
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
