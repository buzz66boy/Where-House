

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/User.dart';

import '../database/UserManager.dart';
import 'UserListView.dart';
import 'UserView.dart';

class UserController {
  final UserManager userManager;

  UserController(this.userManager);


  Future<bool> addUser(User user) async {
    try {
      /// Decode the JSON string back to a Map<int, int> before passing
      Map<int, int> checkedOutItemsMap = User.decodeCheckedOutItems(user.checkedOutItems);
      return await userManager.addUser(user.uid, user.name, checkedOutItemsMap);
    } catch (error) {
      if (kDebugMode) {
        print('Error adding user: $error');
      }
      return false;
    }
  }



  Future<User?> editUser(User user) async {
    try {
      Map<int, int> checkedOutItemsMap = User.decodeCheckedOutItems(user.checkedOutItems);
      return await userManager.editUser(uid: user.uid, name: user.name, checkedOutItems: checkedOutItemsMap);
    } catch (error) {
      if (kDebugMode) {
        print('Error editing user: $error');
      }
      return null;
    }
  }

  Future<bool> removeUser(int uid) async {
    try {
      return await userManager.removeUser(uid);
    } catch (error) {
      if (kDebugMode) {
        print('Error removing user: $error');
      }
      return false;
    }
  }


  void setUserViewActive(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserView(user: user)),
    );
  }

  void setUserListViewActive(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserListView(userController: this)),
    );
  }


  Future<List<User>> getUsers([String query = '']) async {
    try {
      return await userManager.queryUsers(query);
    } catch (error) {
      if (kDebugMode) {
        print('Error querying users: $error');
      }
      return [];
    }
  }

}
