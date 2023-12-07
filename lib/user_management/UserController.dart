import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wherehouse/database/UserManager.dart';
import '../database/User.dart';
import 'UserView.dart';

class UserController {
  late final UserManager userManager;
  late final User user;
  UserController(this.userManager);

  Future<bool> addUser(User user) async {
    try {
      /// added user.uid to search.
      return await userManager.addUser(user.uid,
          user.name, user.password, user.checkedOutItems);
    } catch (error) {
      if (kDebugMode) {
        print('Error adding user: $error');
      }
      return false;
    }
  }

  /// User Controller Edit user Contract 4.
  Future<User?> editUser(
    int uid,
    String name,
    String password,
    List<String> checkOutItems,
  ) async {
    return userManager.editUser(
        uid: uid,
        name: name,
        password: password,
        checkedOutItems: checkOutItems);
  }

  /// User Controller remove User Contract
  Future<bool> removeUser(int uid) async {
    bool removeUser = await userManager.removeUser(uid);
    return removeUser;
  }

  Future<bool> setUser() async {
    try {
      bool userSet = await user.setUser();
      return userSet;
    } catch (e) {
      print("Error setting user:$e");
      return false;
    }
  }

  void setUserViewActive(BuildContext context, int userUid) async {
    try {
      User user = await User.getUser(userUid);  // Added await here
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserView(user: user, userController: this)
            )
        );
      } else {
        if (kDebugMode) {
          print('User not found for id: $userUid');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error setting user view active: $error');
      }
    }
  }


  Future<List<User>> getUsers([String query = '']) async {
    try {
      return await userManager.queryUsers(query);
    } catch (error) {
      if (kDebugMode) {
        print("Error getting users $error");
      }
      return [];
    }
  }
}

