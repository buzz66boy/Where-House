import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wherehouse/database/UserManager.dart';
import '../database/User.dart';
import 'UserView.dart';

class UserController {
  late final UserManager userManager;
  late final User user;
  UserController(this.userManager);


  Future<bool> addUser(User user) async{
    try{
      return await userManager.addUser(user.name,user.checkedOutItems);

    }catch (error){
      if (kDebugMode) {
        print('Error adding user: $error');
      }
      return false;

    }

  }
  // In UserController

  Future<Object?> editUser(int uid, String newName, [List<int>? newCheckedOutItems]) async {
    try {
      return await userManager.editUser(uid: uid, name: newName, checkedOutItems: newCheckedOutItems);
    } catch (error) {
      if (kDebugMode) {
        print('Error editing user: $error');
      }
      return false;
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
  Future<Object> setUser() async{
    try {
      return await user.setUser();
    } catch (error){
      if (kDebugMode){
        print('Error setting user: $error');
      }
      return false;
    }
  }

  void setUserViewActive(BuildContext context, int userId) async {
    try {
      /// recheck
      User user =  User(name: 'bob',checkedOutItems: []);
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserView(user: user)));
      } else {
        // Handle the case where the user is not found
        if (kDebugMode) {
          print('User not found for id: $userId');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error setting user view active: $error');
      }
    }
  }

  Future<List<User>> getUsers([String query =''])async{
    try{
      return await userManager.queryUsers(query);

   }catch (error) {
      if (kDebugMode) {
        print("Error getting users $error");
      }
      return [];
      }
  }
}

