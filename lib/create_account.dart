import 'package:flutter/material.dart';
import 'package:wherehouse/database/User.dart';

import 'package:wherehouse/database/UserManager.dart';

class CreateView extends StatefulWidget {
  final UserManager userManager;

  const CreateView({required this.userManager});

  @override
  _CreateViewState createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('New Account'),
          content: Text('Account has been created.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.userManager.initializeDatabase().then((value) async {
                    User user = User(
                        name: _usernameController.text.trim(),
                        password: _passwordController.text.trim(),
                        checkedOutItems: []);
                    widget.userManager.addUser(
                        user.name, user.password, user.checkedOutItems);
                  });
                  Navigator.pop(context);
                  showAlert(context);
                },
                child: const Text('Create'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
