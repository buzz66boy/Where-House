import 'package:flutter/material.dart';
import 'package:wherehouse/database/UserManager.dart';
import '../database/User.dart';
import 'UserController.dart';

class UserView extends StatelessWidget {
  final User user;
  const UserView({Key? key, required this.user}) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {

    final UserController userController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text('User Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Name: ${user.name}'),
            const Spacer(), /// This will push the button towards the bottom
            ElevatedButton(onPressed: () => _editUser(context), child: const Text("Edit User")),
          ],
        ),
      ),
    );

  }
  void _editUser(BuildContext context) async {
    UserManager userManager = UserManager();

    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {

        String? updatedName;

        return AlertDialog(
          title: const Text('Edit User'),
          content: TextField(
            controller: TextEditingController(text: user.name),
            decoration: const InputDecoration(hintText: "Enter user's new name"),
            onChanged: (value) {

              updatedName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                /// Pass the updated name back when the save button is pressed.
                Navigator.of(context).pop(updatedName);
              },
            ),
          ],
        );
      },
    );

    /// Check if the newName is not equal to null .
    if (newName != null && newName.isNotEmpty) {

      UserController userController = UserController(userManager);
      Object? success = await userController.editUser(user.uid, newName);
      if (success != null) {

        userController.setUser();
      }
    }
  }


}
