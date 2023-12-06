import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:bcrypt/bcrypt.dart';

class User {
  late int uid;
  String name;
  String passwordHash; // Store the hashed password
  List<dynamic> checkedOutItems;

  User({
    this.uid = -1,
    required this.name,
    String? password, // Accept plain password during object creation
    required this.checkedOutItems,
  }) : passwordHash = _hashPassword(password!); // Hash the password

  static String _hashPassword(String password) {
    // Use bcrypt to hash the password
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static Future<User> getUser(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results =
        await db.query('User', where: 'UID = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return User(
        uid: results[0]['uid'],
        name: results[0]['name'],
        checkedOutItems:
            List<int>.from(jsonDecode(results[0]['checkedOutItems'])),
      );
    } else {
      throw Exception("User not found in the database");
    }
  }

  static Future<User?> getUserLogin(String name, String password) async {
    print("here");
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results =
        await db.query('User', where: 'name = ?', whereArgs: [name]);
    await db.close();

    if (results.isNotEmpty) {
      String storedHash = results[0]['password'];
      print(password);
      print(storedHash);
      final bool result = BCrypt.checkpw(password, storedHash);
      print(result);
      if (BCrypt.checkpw(password, storedHash)) {
        return User(
          uid: results[0]['uid'],
          name: results[0]['name'],
          password: storedHash,
          checkedOutItems:
              List<int>.from(jsonDecode(results[0]['checkedOutItems'])),
        );
      } else {
        print("wrong password");
        return null;
      }
    } else {
      print("User not found in the database");
      return null;
    }
  }

  Future<bool> setUser() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      uid = await db.insert(
        'User',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      password: map['password'],
      checkedOutItems: List<int>.from(jsonDecode(map['checkedOutItems'])),
    );
  }

  Map<String, dynamic> toMap() {
    if (uid > -1) {
      return {
        'uid': uid,
        'name': name,
        'password': passwordHash,
        'checkedOutItems': jsonEncode(checkedOutItems),
      };
    } else {
      return {
        'name': name,
        'password': passwordHash,
        'checkedOutItems': jsonEncode(checkedOutItems),
      };
    }
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, password: $passwordHash, checkedOutItems: $checkedOutItems}';
  }
}
