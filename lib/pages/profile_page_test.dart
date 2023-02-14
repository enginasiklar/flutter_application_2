import 'package:flutter/material.dart';

class ProfilePageTest extends StatelessWidget {
  const ProfilePageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(10), children: const [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(
          Icons.person_add,
          size: 30,
        ),
        title: Text(
          'Add profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(
          Icons.person_remove,
          size: 30,
        ),
        title: Text(
          'Remove profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(
          Icons.settings,
          size: 30,
        ),
        title: Text(
          'App setting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
