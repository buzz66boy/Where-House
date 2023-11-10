import 'package:flutter/material.dart';
import '../database/User.dart';
import '../user_management/UserController.dart';
import '../user_management/UserView.dart';

class UserListView extends StatelessWidget {
  final UserController userController;

  const UserListView({Key? key, required this.userController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ///  adding a new user

            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              /// Add for query
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: userController.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return _buildUserTile(context, user);
              },
            );
          } else {
            return const Center(child: Text("No users found"));
          }
        },
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text('ID: ${user.uid}'),
      onTap: () => selectUser(context, user),
    );
  }

  void selectUser(BuildContext context, User user) {
    userController.setUserViewActive(context, user);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserView(user: user),
      ),
    );
  }
}
