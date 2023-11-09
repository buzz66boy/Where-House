import 'package:flutter/material.dart';
import 'package:wherehouse/database/User.dart';



class ViewUser extends StatelessWidget {
  final User user;

  const ViewUser({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 8), // Provides some spacing between text fields.
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Checked Out Items:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: user.checkedOutItems.length,
                itemBuilder: (context, index) {
                  int key = user.checkedOutItems.keys.elementAt(index);
                  return ListTile(
                    title: Text('Item ID: $key'),
                    subtitle: Text('Quantity: ${user.checkedOutItems[key]}'),
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
