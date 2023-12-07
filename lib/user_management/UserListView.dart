import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wherehouse/user_management/UserController.dart';
import 'package:wherehouse/database/User.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'UserView.dart';
//
// class UserListView extends StatefulWidget {
//   const UserListView({super.key});
//
//   @override
//   _UserListViewState createState() => _UserListViewState();
// }
//
// class _UserListViewState extends State<UserListView> {
//   late final UserManager _userManager;
//   late final UserController _userController;
//
//   List<User> _users = [];
//   String _query = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _userManager = UserManager();
//     _userController = UserController(_userManager);
//     _displayUsers();
//   }
//
//   void _displayUsers() async {
//     List<User> usersList = await _userController.getUsers();
//     setState(() {
//       _users = usersList;
//     });
//   }
//
//   void _selectUser(User user) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               UserView(user: user, userController: _userController)),
//     );
//   }
//
//   void _selectAddUser() {
//     final BuildContext scaffoldContext = context;
//     addUserDialog(scaffoldContext);
//   }
//
//   // void _submitUserQuery(String query) {
//   //
//   //   setState(() {
//   //     _query = query;
//   //   });
//   //
//   // }
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



  @override
  void initState() {
    super.initState();
    _userManager = UserManager();
    _userController = UserController(_userManager);
    _displayUsers();
  }

  void _displayUsers() async {
    List<User> usersList = await _userController.getUsers();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListScreen(users: usersList),
      ),
    );
  }


  void _selectAddUser() {
    final BuildContext scaffoldContext = context;
    addUserDialog(scaffoldContext);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor:  Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text('User List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
                onPressed: () => _selectAddUser(), child: const Text("Add User")),
            ElevatedButton(
                onPressed: () => _displayUsers(), child: const Text("Display Users")),
          ],
        ),
      ),
    );
  }

  Future<void> addUserDialog(BuildContext scaffoldContext) async {
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController checkedOutItemsController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(hintText: "Enter user's ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: passwordController,
                  decoration:  const InputDecoration(hintText: "Enter password"),
                ),
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(hintText: "Enter user's name"),
                ),
                TextField(
                  controller: checkedOutItemsController,
                  decoration: const InputDecoration(hintText: "Enter checked out items (comma separated)"),
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
                String userName = userNameController.text;
                String userPassword = passwordController.text;
                String checkedOutItemsString = checkedOutItemsController.text;

                List<dynamic> checkedOutItems = checkedOutItemsString.isNotEmpty
                    ? jsonDecode('[$checkedOutItemsString]')
                    : [];

                if (userName.isNotEmpty) {
                  int? userId = int.tryParse(userIdController.text);
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid User ID')),
                    );
                    return;
                  }

                  User newUser = User(uid: userId, name: userName,password:userPassword,checkedOutItems: checkedOutItems);
                  bool success = await _userController.addUser(newUser);
                  Navigator.of(context).pop();

                  if (success) {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(content: Text('User "$userName" added successfully')),
                    );
                    _displayUsers();
                  } else {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      const SnackBar(content: Text('Failed to add the user')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text('User name cannot be empty')),
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
class UserListScreen extends StatelessWidget {
  final List<User> users;

  const UserListScreen({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('Checked Out Items: ${user.checkedOutItems.join(', ')}'),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserView(
                    user: user,
                    userController: UserController(UserManager()),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

