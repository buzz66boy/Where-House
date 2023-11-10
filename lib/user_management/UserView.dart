import 'package:flutter/material.dart';

import '../database/User.dart';

class UserView extends StatelessWidget {
  final User user;

  const UserView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Decode Json
    Map<int, int> checkedOutItems = User.decodeCheckedOutItems(user.checkedOutItems);

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('User ID: ${user.uid}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Checked Out Items:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: checkedOutItems.length,
                itemBuilder: (context, index) {
                  int key = checkedOutItems.keys.elementAt(index);
                  return ListTile(
                    title: Text('Item ID: $key'),
                    subtitle: Text('Quantity: ${checkedOutItems[key]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
